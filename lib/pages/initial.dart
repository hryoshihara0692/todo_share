import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/pages/create_account.dart';
import 'package:todo_share/pages/login.dart';
import 'package:todo_share/components/screen_pod.dart';
import 'package:sign_button/sign_button.dart';
import 'package:todo_share/pages/home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class InitialPage extends StatefulWidget {
  final bool isNewAccount;

  const InitialPage({Key? key, required this.isNewAccount}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  bool _isLoading = false;
  late int initialTabIndex;

  @override
  void initState() {
    super.initState();
    initialTabIndex = widget.isNewAccount ? 1 : 0;
  }

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
            child: Scaffold(
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
                  Container(
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
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return HomePage();
                                        },
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          // 右から左
                                          final Offset begin = Offset(1.0, 0.0);
                                          // 左から右
                                          // final Offset begin = Offset(-1.0, 0.0);
                                          final Offset end = Offset.zero;
                                          final Animatable<Offset> tween =
                                              Tween(begin: begin, end: end)
                                                  .chain(CurveTween(
                                                      curve: Curves.easeInOut));
                                          final Animation<Offset>
                                              offsetAnimation =
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
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return HomePage();
                                        },
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          // 右から左
                                          final Offset begin = Offset(1.0, 0.0);
                                          // 左から右
                                          // final Offset begin = Offset(-1.0, 0.0);
                                          final Offset end = Offset.zero;
                                          final Animatable<Offset> tween =
                                              Tween(begin: begin, end: end)
                                                  .chain(CurveTween(
                                                      curve: Curves.easeInOut));
                                          final Animation<Offset>
                                              offsetAnimation =
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
                                  customImage:
                                      CustomImage('assets/images/mail.png'),
                                  imagePosition: ImagePosition.left,
                                  buttonSize: ButtonSize.large,
                                  btnColor: Color.fromARGB(255, 202, 233, 248),
                                  btnTextColor: Colors.black87,
                                  width: 300,
                                  btnText: 'メールアドレス で新規登録',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return CreateAccountPage();
                                        },
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          // 右から左
                                          final Offset begin = Offset(1.0, 0.0);
                                          // 左から右
                                          // final Offset begin = Offset(-1.0, 0.0);
                                          final Offset end = Offset.zero;
                                          final Animatable<Offset> tween =
                                              Tween(begin: begin, end: end)
                                                  .chain(CurveTween(
                                                      curve: Curves.easeInOut));
                                          final Animation<Offset>
                                              offsetAnimation =
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
                                  btnText: '登録しないで使う※要検討',
                                  onPressed: () async {
                                    // await signInAnonymous();
                                    // await checkUserCollection();
                                    Navigator.of(context).pushReplacement(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return HomePage();
                                        },
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          // 右から左
                                          final Offset begin = Offset(1.0, 0.0);
                                          // 左から右
                                          // final Offset begin = Offset(-1.0, 0.0);
                                          final Offset end = Offset.zero;
                                          final Animatable<Offset> tween =
                                              Tween(begin: begin, end: end)
                                                  .chain(CurveTween(
                                                      curve: Curves.easeInOut));
                                          final Animation<Offset>
                                              offsetAnimation =
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
                  ),

                  ///
                  /// ログイン側
                  ///
                  Container(
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
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return HomePage();
                                        },
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          // 右から左
                                          final Offset begin = Offset(1.0, 0.0);
                                          // 左から右
                                          // final Offset begin = Offset(-1.0, 0.0);
                                          final Offset end = Offset.zero;
                                          final Animatable<Offset> tween =
                                              Tween(begin: begin, end: end)
                                                  .chain(CurveTween(
                                                      curve: Curves.easeInOut));
                                          final Animation<Offset>
                                              offsetAnimation =
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
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return HomePage();
                                        },
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          // 右から左
                                          final Offset begin = Offset(1.0, 0.0);
                                          // 左から右
                                          // final Offset begin = Offset(-1.0, 0.0);
                                          final Offset end = Offset.zero;
                                          final Animatable<Offset> tween =
                                              Tween(begin: begin, end: end)
                                                  .chain(CurveTween(
                                                      curve: Curves.easeInOut));
                                          final Animation<Offset>
                                              offsetAnimation =
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
                                  customImage:
                                      CustomImage('assets/images/mail.png'),
                                  imagePosition: ImagePosition.left,
                                  buttonSize: ButtonSize.large,
                                  btnColor: Color.fromARGB(255, 202, 233, 248),
                                  btnTextColor: Colors.black87,
                                  width: 300,
                                  btnText: 'メールアドレスでログイン',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return LoginPage();
                                        },
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          // 右から左
                                          final Offset begin = Offset(1.0, 0.0);
                                          // 左から右
                                          // final Offset begin = Offset(-1.0, 0.0);
                                          final Offset end = Offset.zero;
                                          final Animatable<Offset> tween =
                                              Tween(begin: begin, end: end)
                                                  .chain(CurveTween(
                                                      curve: Curves.easeInOut));
                                          final Animation<Offset>
                                              offsetAnimation =
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
                                  //アプリのアイコンを設定する！！
                                  customImage:
                                      CustomImage('assets/images/mail.png'),
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
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return HomePage();
                                        },
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          // 右から左
                                          final Offset begin = Offset(1.0, 0.0);
                                          // 左から右
                                          // final Offset begin = Offset(-1.0, 0.0);
                                          final Offset end = Offset.zero;
                                          final Animatable<Offset> tween =
                                              Tween(begin: begin, end: end)
                                                  .chain(CurveTween(
                                                      curve: Curves.easeInOut));
                                          final Animation<Offset>
                                              offsetAnimation =
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
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5), // 半透明の黒色
            child: Center(
              // child: CircularProgressIndicator(), // ローディングインジケーター
              child: Image.asset('assets/images/tmp.gif'),
            ),
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
}
