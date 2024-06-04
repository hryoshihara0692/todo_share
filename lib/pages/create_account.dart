// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_share/pages/create_user.dart';
// import 'package:intl/intl.dart';
import 'package:todo_share/components/screen_pod.dart';
import 'package:todo_share/components/ad_mob.dart';
import 'package:todo_share/widgets/admob_banner.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _mailaddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _mailaddressFocusNode = FocusNode();

  final AdMob _adMob = AdMob();

  @override
  void initState() {
    super.initState();
    _adMob.load();
    Future.delayed(Duration.zero, () {
      _mailaddressFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _adMob.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = ScreenRef(context).watch(screenProvider);
    final designW = screen.designW(200);
    final designH = screen.designH(50);

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(designH),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: kToolbarHeight,
                  child: TabBar(
                    indicatorColor: Colors.blue,
                    labelColor: Colors.black,
                    tabs: [
                      Tab(
                        text: 'メールアドレスで登録',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.fromLTRB(32.0, 16.0, 16.0, 8.0),
                              child: Text('メールアドレス'),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                              controller: _mailaddressController,
                              focusNode:
                                  _mailaddressFocusNode, // 追加: フォーカスノードを設定
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 3)),
                                hintText: '\u{2709}  sample@todolist.com',
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(32.0, 8.0, 16.0, 8.0),
                              child: Text('パスワード'),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 3)),
                                hintText: '\u{1F511}  パスワードを入力',
                              ),
                              obscureText: true,
                              obscuringCharacter: '*',
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('キャンセル'),
                                ),
                              ),
                              Container(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _createAccount(
                                        context,
                                        _mailaddressController.text,
                                        _passwordController.text);
                                  },
                                  child: Text('登録する'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AdMobBanner(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _createAccount(
      BuildContext context, String mailaddress, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mailaddress,
        password: password,
      );

      // ユーザー情報の再取得（UIDを取得するため）
      await credential.user?.reload();

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return CreateUserPage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // 右から左
            final Offset begin = Offset(1.0, 0.0);
            // 左から右
            // final Offset begin = Offset(-1.0, 0.0);
            final Offset end = Offset.zero;
            final Animatable<Offset> tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: Curves.easeInOut));
            final Animation<Offset> offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    }

    /// アカウントに失敗した場合のエラー処理
    on FirebaseAuthException catch (e) {
      /// パスワードが弱い場合
      if (e.code == 'weak-password') {
        print('パスワードが弱いです');
      }

      /// メールアドレスが既に使用中の場合
      else if (e.code == 'email-already-in-use') {
        print('すでに使用されているメールアドレスです');
      }
      // メールアドレスがおかしい場合
      else if (e.code == 'invalid-email') {
        print('メールアドレスが有効ではありません。');
      }

      /// その他エラー
      else {
        print('アカウント作成エラー');
      }
    } catch (e) {
      print(e);
    }
  }
}
