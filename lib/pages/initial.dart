import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/pages/create_group.dart';
import 'package:todo_share/pages/create_user.dart';
import 'package:todo_share/components/screen_pod.dart';
import 'package:sign_button/sign_button.dart';
import 'package:todo_share/pages/home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InitialPage extends StatefulWidget {
  final bool isNewAccount;

  const InitialPage({Key? key, required this.isNewAccount}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late int initialTabIndex;
  bool _isEmailCreateAccountFormVisible = false; // メールアドレスフォームを表示するかのフラグ
  bool _isEmailLoginFormVisible = false; // メールアドレスフォームを表示するかのフラグ

  // late TabController _tabController;

  @override
  void initState() {
    super.initState();
    initialTabIndex = widget.isNewAccount ? 1 : 0;

    // // TabController を初期化
    // _tabController = TabController(length: 2, vsync: this);

    // // タブが変更された際のリスナーを追加
    // _tabController.addListener(() {
    //   if (_tabController.indexIsChanging) {
    //     // タブが切り替わる前に実行したい処理
    //     print('タブが切り替わります: ${_tabController.index}');
    //   } else if (!_tabController.indexIsChanging) {
    //     // タブが切り替わった後に実行したい処理
    //     print('タブが切り替わりました: ${_tabController.index}');
    //   }
    // });
  }

  // @override
  // void dispose() {
  //   // TabControllerを破棄
  //   // _tabController.dispose();
  //   super.dispose();
  // }

  // const InitialPage({Key? key, required this.isNewAccount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    int initialTabIndex = widget.isNewAccount ? 1 : 0;

    final screen = ScreenRef(context).watch(screenProvider);
    final designW = screen.designW(200);
    final designH = screen.designH(400);

    return Stack(
      children: [
        DefaultTabController(
          initialIndex: initialTabIndex,
          length: 2,
          child: PopScope(
            canPop: false,
            child: Builder(builder: (context) {
              // DefaultTabController の TabController を取得
              final TabController tabController =
                  DefaultTabController.of(context)!;

              // リスナーを追加
              tabController.addListener(() {
                if (tabController.indexIsChanging) {
                  print('タブが切り替わります: ${tabController.index}');
                  if (tabController.index == 0) {
                    // 新規登録に切り替わり＝ログインタブの初期化
                    _idLoginController.text = '';
                    _passLoginController.text = '';
                    _isObscuredLogin = true;
                    setState(() {
                      _isEmailLoginFormVisible = false;
                    });
                  } else {
                    // ログインに切り替わり＝新規登録タブの初期化
                    _idCreateAccountController.text = '';
                    _passCreateAccountController.text = '';
                    _isObscuredCreateAccount = true;
                    setState(() {
                      _isEmailCreateAccountFormVisible = false;
                    });
                  }
                } else {
                  print('タブが切り替わりました: ${tabController.index}');
                }
              });

              return Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(designH),
                  child: AppBar(
                    backgroundColor: Color.fromARGB(255, 249, 245, 236),
                    automaticallyImplyLeading: false,
                    flexibleSpace: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: Image.asset('assets/images/Logo.png'),
                        ),
                        // Container(
                        //   height: screen.designH(250),
                        //   decoration: const BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     color: Colors.blue,
                        //   ),
                        //   margin: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                        //   child: const Center(child: Text('Flex 1')),
                        // ),
                        Container(
                          height: kToolbarHeight,
                          child: TabBar(
                            overlayColor: MaterialStateProperty.all<Color>(
                              Colors.grey.withOpacity(0.3),
                            ),
                            indicatorColor: Colors.blueGrey,
                            labelColor: Colors.black,
                            // indicatorWeight: 12.0, // 下線の太さ
                            indicatorPadding:
                                EdgeInsets.symmetric(horizontal: 0), // 左右のパディング
                            // labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(
                                child: Text(
                                  '    新規登録     ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: GoogleFonts.notoSansJp(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ).fontFamily,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  '    ログイン    ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: GoogleFonts.notoSansJp(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ).fontFamily,
                                  ),
                                ),
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
                    ///
                    /// 登録側
                    ///
                    // _buildCreateAccountButtons(context),
                    Container(
                      // padding: EdgeInsets.all(16.0),
                      child: _isEmailCreateAccountFormVisible
                          ? _buildEmailCreateAccountForm() // メールアドレスフォーム
                          : _buildCreateAccountButtons(context), // ログインボタン群
                    ),

                    ///
                    /// ログイン側
                    ///
                    // _buildLoginButtons(context)
                    Container(
                      // padding: EdgeInsets.all(16.0),
                      child: _isEmailLoginFormVisible
                          ? _buildEmailLoginForm() // メールアドレスフォーム
                          : _buildLoginButtons(context), // ログインボタン群
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5), // 半透明の黒色
            // child: Center(
            //   // child: CircularProgressIndicator(), // ローディングインジケーター
            //   child: Image.asset('assets/images/tmp.gif'),
            // ),
          ),
      ],
    );
  }

  ///
  /// ここからコメントアウト
  ///

  Future<void> _handleSignInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await signInWithGoogle();
      // ログイン成功後の処理
    } catch (e) {
      // エラー処理
      print("Google Sign In Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<UserCredential> signInWithGoogle() async {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  ///
  ///だれでもろぐいん
  ///
  // // Future<UserCredential> signInWithGoogle() async {
  // Future<void> signInAnonymous() async {
  //   // // Trigger the authentication flow
  //   // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   // // Obtain the auth details from the request
  //   // final GoogleSignInAuthentication? googleAuth =
  //   //     await googleUser?.authentication;

  //   // // Create a new credential
  //   // final credential = GoogleAuthProvider.credential(
  //   //   accessToken: googleAuth?.accessToken,
  //   //   idToken: googleAuth?.idToken,
  //   // );

  //   // // Once signed in, return the UserCredential
  //   // return await FirebaseAuth.instance.signInWithCredential(credential);

  //   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //   try {
  //     await firebaseAuth.signInAnonymously();
  //   } catch (e) {
  //     await showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: Text('エラー'),
  //             content: Text(e.toString()),
  //           );
  //         });
  //   }
  // }

  // Future<void> checkUserCollection() async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;

  //   ///
  //   /// checkUidの名前を変える
  //   /// 取得したuidでTodoListIDを生成して登録する処理を追加予定
  //   ///
  //   if (uid != null) {
  //     String todoListID =
  //         DateFormat('yyyyMMddHHmmss').format(DateTime.now()) + '-' + uid;
  //     Random random = Random();
  //     int randomNumber = random.nextInt(1000000);
  //     String sixDigitRandomNumber = randomNumber.toString().padLeft(6, '0');
  //     String userName = 'アプリ名$sixDigitRandomNumber';

  //     // USERコレクション用データ
  //     Map<String, dynamic> userRow = {
  //       //UserName取得
  //       "UserName": userName,
  //       "TodoLists": {todoListID: "マイリスト"},
  //       "CreatedAt": Timestamp.fromDate(DateTime.now()),
  //       "UpdatedAt": Timestamp.fromDate(DateTime.now()),
  //       "IconNo": '001',
  //       "IconFileName": "",
  //     };

  //     // USERコレクションにドキュメント追加
  //     await UserDataService.createUserData(uid, userRow);

  //     Map<String, dynamic> todolistRow = {
  //       "TodoListName": "マイリスト",
  //       "Administrator": uid,
  //       "UserIDs": [uid],
  //       "EditingPermission": 0,
  //       "CreatedAt": Timestamp.fromDate(DateTime.now()),
  //       "UpdatedAt": Timestamp.fromDate(DateTime.now()),
  //     };

  //     // TODOLISTコレクションにドキュメント追加
  //     await TodoListDataService.createTodoListData(todoListID, todolistRow);

  //     var uuid = Uuid();
  //     var todoId = uuid.v4();

  //     Map<String, dynamic> todoRow = {
  //       "Content": "",
  //       "isChecked": 0,
  //       "CreatedAt": Timestamp.fromDate(DateTime.now()),
  //       "UpdatedAt": Timestamp.fromDate(DateTime.now()),
  //     };

  //     // TODOコレクションにドキュメント追加
  //     await TodoDataService.createTodoData(todoListID, todoId, todoRow);

  //     // Map<String, dynamic> data = {date + '-' + uid: 'マイリスト'};
  //     // await FirebaseFirestore.instance.collection('USER').doc(uid).set(data);

  //     //   String date = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
  //     //   Map<String, dynamic> data = {date + '-' + uid: 'マイリスト'};
  //     //   final _movieRef = FirebaseFirestore.instance.collection('USER').doc(uid);
  //     //   await _movieRef.get().then(
  //     //         (docSnapshot) => {
  //     //           if (docSnapshot.exists)
  //     //             {
  //     //               // 既に登録されているドキュメントの場合
  //     //               print('追加しない')
  //     //             }
  //     //           else
  //     //             {
  //     //               // // 登録されてない新しいドキュメントの場合
  //     //               // FirebaseFirestore.instance
  //     //               //     .collection('USER')
  //     //               //     .doc(uid)
  //     //               //     .set({'id': movieId, 'title': title})
  //     //               //     .then(
  //     //               //       (value) => print('追加しました'),
  //     //               //     )
  //     //               //     .catchError((error) {
  //     //               //       print('追加失敗！')
  //     //               //     }),
  //     //               FirebaseFirestore.instance
  //     //                   .collection('USER')
  //     //                   .doc(uid)
  //     //                   .set(data)
  //     //             }
  //     //         },
  //     //       );
  //     // } else {}
  //   }
  // }

  Future<void> _handleSignInWithApple() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await signInWithApple();
      // ログイン成功後の処理
    } catch (e) {
      // エラー処理
      print("Apple Sign In Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<UserCredential> signInWithApple() async {
    print('AppSignInを実行');
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(appleCredential);
    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    // // ここに画面遷移をするコードを書く!
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => NextPage()));
    // print(appleCredential);

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  ///
  /// 新規登録ボタンたち
  ///
  Widget _buildCreateAccountButtons(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 249, 245, 236),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: SignInButton(
                    buttonType: ButtonType.appleDark,
                    imagePosition: ImagePosition.left,
                    buttonSize: ButtonSize.large,
                    btnTextColor: Colors.white,
                    btnColor: Colors.black,
                    width: 300,
                    btnText: 'AppleID で新規登録',
                    onPressed: () async {
                      // await _handleSignInWithApple();
                      // await checkUserCollection();
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return HomePage();
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            // 右から左
                            final Offset begin = Offset(1.0, 0.0);
                            // 左から右
                            // final Offset begin = Offset(-1.0, 0.0);
                            final Offset end = Offset.zero;
                            final Animatable<Offset> tween =
                                Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: Curves.easeInOut));
                            final Animation<Offset> offsetAnimation =
                                animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: SignInButton(
                    buttonType: ButtonType.google,
                    imagePosition: ImagePosition.left,
                    buttonSize: ButtonSize.large,
                    btnTextColor: Colors.black87,
                    btnColor: Colors.white,
                    width: 300,
                    btnText: 'Google で新規登録',
                    onPressed: () async {
                      // await _handleSignInWithGoogle();
                      // await checkUserCollection();
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return HomePage();
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            // 右から左
                            final Offset begin = Offset(1.0, 0.0);
                            // 左から右
                            // final Offset begin = Offset(-1.0, 0.0);
                            final Offset end = Offset.zero;
                            final Animatable<Offset> tween =
                                Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: Curves.easeInOut));
                            final Animation<Offset> offsetAnimation =
                                animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: SignInButton(
                    buttonType: ButtonType.custom,
                    customImage: CustomImage('assets/images/mail.png'),
                    imagePosition: ImagePosition.left,
                    buttonSize: ButtonSize.large,
                    btnColor: Color.fromARGB(255, 202, 233, 248),
                    btnTextColor: Colors.black87,
                    width: 300,
                    btnText: 'メールアドレス で新規登録',
                    onPressed: () {
                      // Navigator.of(context).push(
                      //   PageRouteBuilder(
                      //     pageBuilder:
                      //         (context, animation, secondaryAnimation) {
                      //       return CreateAccountPage();
                      //     },
                      //     transitionsBuilder:
                      //         (context, animation, secondaryAnimation, child) {
                      //       // 右から左
                      //       final Offset begin = Offset(1.0, 0.0);
                      //       // 左から右
                      //       // final Offset begin = Offset(-1.0, 0.0);
                      //       final Offset end = Offset.zero;
                      //       final Animatable<Offset> tween =
                      //           Tween(begin: begin, end: end)
                      //               .chain(CurveTween(curve: Curves.easeInOut));
                      //       final Animation<Offset> offsetAnimation =
                      //           animation.drive(tween);
                      //       return SlideTransition(
                      //         position: offsetAnimation,
                      //         child: child,
                      //       );
                      //     },
                      //   ),
                      // );
                      setState(() {
                        _isEmailCreateAccountFormVisible = true;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: SignInButton(
                    buttonType: ButtonType.google,
                    imagePosition: ImagePosition.left,
                    buttonSize: ButtonSize.large,
                    btnTextColor: Colors.black87,
                    btnColor: Colors.white,
                    width: 300,
                    btnText: '登録しないで使う※要検討',
                    onPressed: () async {
                      // await signInAnonymous();
                      // await checkUserCollection();
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return HomePage();
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            // 右から左
                            final Offset begin = Offset(1.0, 0.0);
                            // 左から右
                            // final Offset begin = Offset(-1.0, 0.0);
                            final Offset end = Offset.zero;
                            final Animatable<Offset> tween =
                                Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: Curves.easeInOut));
                            final Animation<Offset> offsetAnimation =
                                animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// ログインボタンたち
  ///
  Widget _buildLoginButtons(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 249, 245, 236),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: SignInButton(
                    buttonType: ButtonType.appleDark,
                    imagePosition: ImagePosition.left,
                    buttonSize: ButtonSize.large,
                    btnTextColor: Colors.white,
                    btnColor: Colors.black,
                    width: 300,
                    btnText: 'AppleID でログイン',
                    onPressed: () async {
                      await _handleSignInWithApple();
                      // await checkUserCollection();
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return HomePage();
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            // 右から左
                            final Offset begin = Offset(1.0, 0.0);
                            // 左から右
                            // final Offset begin = Offset(-1.0, 0.0);
                            final Offset end = Offset.zero;
                            final Animatable<Offset> tween =
                                Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: Curves.easeInOut));
                            final Animation<Offset> offsetAnimation =
                                animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: SignInButton(
                    buttonType: ButtonType.google,
                    imagePosition: ImagePosition.left,
                    buttonSize: ButtonSize.large,
                    btnTextColor: Colors.black87,
                    btnColor: Colors.white,
                    width: 300,
                    btnText: 'Google でログイン',
                    onPressed: () async {
                      await _handleSignInWithGoogle();
                      // await checkUserCollection();
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return HomePage();
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            // 右から左
                            final Offset begin = Offset(1.0, 0.0);
                            // 左から右
                            // final Offset begin = Offset(-1.0, 0.0);
                            final Offset end = Offset.zero;
                            final Animatable<Offset> tween =
                                Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: Curves.easeInOut));
                            final Animation<Offset> offsetAnimation =
                                animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: SignInButton(
                    buttonType: ButtonType.custom,
                    customImage: CustomImage('assets/images/mail.png'),
                    imagePosition: ImagePosition.left,
                    buttonSize: ButtonSize.large,
                    btnColor: Color.fromARGB(255, 202, 233, 248),
                    btnTextColor: Colors.black87,
                    width: 300,
                    btnText: 'メールアドレスでログイン',
                    onPressed: () {
                      // Navigator.of(context).push(
                      //   PageRouteBuilder(
                      //     pageBuilder: (context, animation,
                      //         secondaryAnimation) {
                      //       return LoginPage();
                      //     },
                      //     transitionsBuilder: (context, animation,
                      //         secondaryAnimation, child) {
                      //       // 右から左
                      //       final Offset begin = Offset(1.0, 0.0);
                      //       // 左から右
                      //       // final Offset begin = Offset(-1.0, 0.0);
                      //       final Offset end = Offset.zero;
                      //       final Animatable<Offset> tween =
                      //           Tween(begin: begin, end: end)
                      //               .chain(CurveTween(
                      //                   curve: Curves.easeInOut));
                      //       final Animation<Offset>
                      //           offsetAnimation =
                      //           animation.drive(tween);
                      //       return SlideTransition(
                      //         position: offsetAnimation,
                      //         child: child,
                      //       );
                      //     },
                      //   ),
                      // );
                      setState(() {
                        _isEmailLoginFormVisible = true;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: SignInButton(
                    buttonType: ButtonType.custom,
                    //アプリのアイコンを設定する！！
                    customImage: CustomImage('assets/images/mail.png'),
                    imagePosition: ImagePosition.left,
                    buttonSize: ButtonSize.large,
                    btnTextColor: Colors.black87,
                    btnColor: Colors.white,
                    width: 300,
                    btnText: 'ゲストとして利用する',
                    onPressed: () async {
                      // await signInAnonymous();
                      // await checkUserCollection();
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return HomePage();
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            // 右から左
                            final Offset begin = Offset(1.0, 0.0);
                            // 左から右
                            // final Offset begin = Offset(-1.0, 0.0);
                            final Offset end = Offset.zero;
                            final Animatable<Offset> tween =
                                Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: Curves.easeInOut));
                            final Animation<Offset> offsetAnimation =
                                animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final TextEditingController _idCreateAccountController =
      TextEditingController();
  final TextEditingController _passCreateAccountController =
      TextEditingController();
  bool _isObscuredCreateAccount = true; // パスワードの表示/非表示状態を管理
  Widget _buildEmailCreateAccountForm() {
    return Container(
      color: Color.fromARGB(255, 249, 245, 236),
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(32.0, 8.0, 16.0, 8.0),
                        child: Text('メールアドレス'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        // backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        controller: _idCreateAccountController,
                        // focusNode: _idFocusNode,
                        decoration: const InputDecoration(
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(width: 3),
                          // ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.black), // 通常時の外枠
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.black), // フォーカス時の外枠
                          ),
                          hintText: '\u{2709}  todo_share@xxxxx.com',
                          // labelText: '\u{2709}  メールアドレス',
                          filled: true, // 背景色を有効にする
                          fillColor: Colors.white, // 背景色を白に設定
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
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
                  SizedBox(
                    height: 50,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _passCreateAccountController,
                        decoration: InputDecoration(
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(width: 3),
                          // ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.black), // 通常時の外枠
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.black), // フォーカス時の外枠
                          ),
                          hintText: '\u{1F511} Password1234',
                          filled: true, // 背景色を有効にする
                          fillColor: Colors.white, // 背景色を白に設定
                          // labelText: 'パスワード',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscuredCreateAccount
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscuredCreateAccount =
                                    !_isObscuredCreateAccount; // 表示/非表示を切り替え
                              });
                            },
                          ),
                        ),
                        obscureText: _isObscuredCreateAccount,
                        obscuringCharacter: '*',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 160,
                        height: 40,
                        // ボタンの形と影を設定する
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 0,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // print('Tapおっけー');
                            // _showModal(context);
                            // Navigator.of(context).pop();
                            _idCreateAccountController.text = '';
                            _passCreateAccountController.text = '';
                            _isObscuredCreateAccount = true;
                            setState(() {
                              _isEmailCreateAccountFormVisible = false;
                            });
                          },
                          // ボタンの色と枠線を設定する
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 255, 102, 112),
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                          child: Padding(
                            // 指マーク用として右にスペースを開ける＋テキスト下がるので4上げる
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                            child: Text(
                              'キャンセル',
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: GoogleFonts.notoSansJp(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ).fontFamily,
                                shadows: [
                                  Shadow(
                                    color: Color.fromARGB(255, 128, 128, 128),
                                    blurRadius: 0,
                                    offset: Offset(0, 2.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      // Container(
                      //   width: 150,
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       _loginAccount(context, _idController.text,
                      //           _passController.text);
                      //     },
                      //     child: Text('ログイン'),
                      //   ),
                      // ),
                      Container(
                        width: 160,
                        height: 40,
                        // ボタンの形と影を設定する
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 0,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _createAccount(
                                context,
                                _idCreateAccountController.text,
                                _passCreateAccountController.text);
                          },
                          // ボタンの色と枠線を設定する
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 116, 199, 156),
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                          child: Padding(
                            // 指マーク用として右にスペースを開ける＋テキスト下がるので4上げる
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                            child: Text(
                              '新規登録',
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: GoogleFonts.notoSansJp(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ).fontFamily,
                                shadows: [
                                  Shadow(
                                    color: Color.fromARGB(255, 118, 168, 141),
                                    blurRadius: 0,
                                    offset: Offset(0, 2.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // adMobNotifier.getAdBanner(),
        ],
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
      String message; // スナックバーに表示するメッセージ
      /// パスワードが弱い場合
      if (e.code == 'weak-password') {
        message = 'パスワードが弱いです。もう少し複雑にしてください。';
      }

      /// メールアドレスが既に使用中の場合
      else if (e.code == 'email-already-in-use') {
        message = '登録済みのメールアドレスです。ログインするか別のメールアドレスを使用してください。';
      }

      /// メールアドレスがおかしい場合
      else if (e.code == 'invalid-email') {
        message = 'メールアドレスが有効ではありません。正しい形式で入力してください。';
      }

      /// その他エラー
      else {
        message = 'アカウント作成中にエラーが発生しました。もう一度お試しください。';
      }

      // スナックバーを表示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red, // スナックバーの背景色（エラーを強調するため赤に設定）
          duration: const Duration(seconds: 3), // スナックバーの表示時間
        ),
      );
    } catch (e) {
      // その他の予期しないエラー処理
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('予期しないエラーが発生しました。: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      print(e);
    }
  }

  final TextEditingController _idLoginController = TextEditingController();
  final TextEditingController _passLoginController = TextEditingController();
  bool _isObscuredLogin = true; // パスワードの表示/非表示状態を管理
  Widget _buildEmailLoginForm() {
    return Container(
      color: Color.fromARGB(255, 249, 245, 236),
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(32.0, 8.0, 16.0, 8.0),
                        child: Text('メールアドレス'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        // backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        controller: _idLoginController,
                        // focusNode: _idFocusNode,
                        decoration: const InputDecoration(
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(width: 3),
                          // ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.black), // 通常時の外枠
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.black), // フォーカス時の外枠
                          ),
                          hintText: '\u{2709}  todo_share@xxxxx.com',
                          // labelText: '\u{2709}  メールアドレス',
                          filled: true, // 背景色を有効にする
                          fillColor: Colors.white, // 背景色を白に設定
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
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
                  SizedBox(
                    height: 50,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _passLoginController,
                        decoration: InputDecoration(
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(width: 3),
                          // ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.black), // 通常時の外枠
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.black), // フォーカス時の外枠
                          ),
                          hintText: '\u{1F511} Password1234',
                          filled: true, // 背景色を有効にする
                          fillColor: Colors.white, // 背景色を白に設定
                          // labelText: 'パスワード',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscuredLogin
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscuredLogin =
                                    !_isObscuredLogin; // 表示/非表示を切り替え
                              });
                            },
                          ),
                        ),
                        obscureText: _isObscuredLogin,
                        obscuringCharacter: '*',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(
                      //   width: 150,
                      //   child: ElevatedButton(
                      //     // onPressed: () {
                      //     //   Navigator.pop(context);
                      //     // },
                      //     onPressed: () {
                      //       _idController.text = '';
                      //       _passController.text = '';
                      //       setState(() {
                      //         _isEmailLoginFormVisible =
                      //             false; // メールアドレスフォームを非表示にする
                      //       });
                      //     },
                      //     child: Text('キャンセル'),
                      //   ),
                      // ),
                      Container(
                        width: 160,
                        height: 40,
                        // ボタンの形と影を設定する
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 0,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // print('Tapおっけー');
                            // _showModal(context);
                            // Navigator.of(context).pop();
                            _idLoginController.text = '';
                            _passLoginController.text = '';
                            _isObscuredLogin = true;
                            setState(() {
                              _isEmailLoginFormVisible = false;
                            });
                          },
                          // ボタンの色と枠線を設定する
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 255, 102, 112),
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                          child: Padding(
                            // 指マーク用として右にスペースを開ける＋テキスト下がるので4上げる
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                            child: Text(
                              'キャンセル',
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: GoogleFonts.notoSansJp(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ).fontFamily,
                                shadows: [
                                  Shadow(
                                    color: Color.fromARGB(255, 128, 128, 128),
                                    blurRadius: 0,
                                    offset: Offset(0, 2.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      // Container(
                      //   width: 150,
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       _loginAccount(context, _idController.text,
                      //           _passController.text);
                      //     },
                      //     child: Text('ログイン'),
                      //   ),
                      // ),
                      Container(
                        width: 160,
                        height: 40,
                        // ボタンの形と影を設定する
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 0,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _loginAccount(context, _idLoginController.text,
                                _passLoginController.text);
                          },
                          // ボタンの色と枠線を設定する
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 116, 199, 156),
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                          child: Padding(
                            // 指マーク用として右にスペースを開ける＋テキスト下がるので4上げる
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                            child: Text(
                              'ログイン',
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: GoogleFonts.notoSansJp(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ).fontFamily,
                                shadows: [
                                  Shadow(
                                    color: Color.fromARGB(255, 118, 168, 141),
                                    blurRadius: 0,
                                    offset: Offset(0, 2.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // adMobNotifier.getAdBanner(),
        ],
      ),
    );
  }

  void _loginAccount(BuildContext context, String id, String pass) async {
    try {
      /// credential にはアカウント情報が記録される
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: id,
        password: pass,
      );

      final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('USER').doc(uid);

      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        // ドキュメントが存在する場合
        String? primaryGroupId = userDoc['PRIMARY_GROUP_ID'] as String?;

        if (primaryGroupId == null || primaryGroupId.isEmpty) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return CreateGroupPage();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // 右から左
                final Offset begin = Offset(1.0, 0.0);
                // 左から右
                // final Offset begin = Offset(-1.0, 0.0);
                final Offset end = Offset.zero;
                final Animatable<Offset> tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: Curves.easeInOut));
                final Animation<Offset> offsetAnimation =
                    animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return HomePage();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // 右から左
                final Offset begin = Offset(1.0, 0.0);
                // 左から右
                // final Offset begin = Offset(-1.0, 0.0);
                final Offset end = Offset.zero;
                final Animatable<Offset> tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: Curves.easeInOut));
                final Animation<Offset> offsetAnimation =
                    animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        }
      } else {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return CreateUserPage();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
    }

    /// アカウントに失敗した場合のエラー処理
    on FirebaseAuthException catch (e) {
      String message; // スナックバーに表示するメッセージ

      /// エラーに応じたメッセージを設定
      if (e.code == 'invalid-email') {
        message = 'メールアドレスが有効ではありません。正しい形式で入力してください。';
      } else if (e.code == 'user-disabled') {
        message = '入力したメールアドレスは無効になっています。';
      } else if (e.code == 'user-not-found') {
        message = 'メールアドレスが登録されていません。新規登録してください。';
      } else if (e.code == 'wrong-password') {
        message = 'パスワードが正しくありません。もう一度お試しください。';
      } else {
        message = 'ログイン中にエラーが発生しました。再度お試しください。';
      }

      // スナックバーを表示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red, // エラーを強調する赤色
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // その他の予期しないエラー処理
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('予期しないエラーが発生しました: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      print(e);
    }
  }
}
