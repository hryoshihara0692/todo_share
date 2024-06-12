import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/components/admob/ad_mob_provider.dart';
import 'package:todo_share/pages/create_group.dart';
// import 'package:intl/intl.dart';
import 'package:todo_share/components/screen_pod.dart';
import 'package:todo_share/components/admob/ad_mob.dart';
import 'package:todo_share/riverpod/selected_icon.dart';
import 'package:todo_share/widgets/admob_banner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_share/widgets/icon_setting_dialog.dart';
import 'package:todo_share/widgets/todolist_setting_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class CreateUserPage extends ConsumerWidget {
  const CreateUserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedIcon = ref.watch(selectedIconNotifierProvider);
    final adMobNotifier = ref.watch(adMobProvider);

    final TextEditingController _userNameController = TextEditingController();
    final TextEditingController _passController = TextEditingController();
    final FocusNode _userNameFocusNode = FocusNode();

    final screen = ScreenRef(context).watch(screenProvider);
    final designW = screen.designW(200);
    final designH = screen.designH(50);

    final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

    // Post-frame callback to request focus after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userNameFocusNode.requestFocus();
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ユーザー設定',
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: GoogleFonts.notoSansJp(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ).fontFamily,
                    shadows: [
                      Shadow(
                        color: Color.fromARGB(255, 195, 195, 195),
                        blurRadius: 0,
                        offset: Offset(0, 2.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),

            ///
            /// ユーザー画像
            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 190, 190, 190),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                            selectedIcon,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const IconSettingDialog();
                            },
                          ).then((result) {
                            if (result != 'confirmed') {
                              // ダイアログが決定ボタン以外で閉じられた場合の処理
                              var notifier = ref
                                  .read(selectedIconNotifierProvider.notifier);
                              notifier.update('');
                            }
                          });
                        },
                        child: Container(
                          width: 160,
                          height: 160,
                          child: Center(
                            child: Container(
                              width: 48,
                              height: 48,
                              child:
                                  Image.asset('assets/images/UserSetting.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),

            ///
            /// なまえ
            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'なまえ',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: GoogleFonts.notoSansJp(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ).fontFamily,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              width: double.infinity,
              height: 40.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 0,
                    offset: Offset(2.5, 2.5),
                  )
                ],
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
                child: TextField(
                  controller: _userNameController,
                  focusNode: _userNameFocusNode,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '\u{2709}  sample@todolist.com',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 48,
            ),

            ///
            /// 次へボタン
            ///
            Container(
              width: 128,
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
                  uploadAndSaveAssetImage(
                      context, selectedIcon, uid!, _userNameController.text);
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
                    '次  へ',
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
            adMobNotifier.getAdBanner(),
          ],
        ),
      ),
    );
  }
}

///
/// テンプレートアイコン画像を、ユーザ画像として保存
///
Future<String> saveAssetAsFile(String assetPath, String newFileName) async {
  try {
    ByteData byteData = await rootBundle.load(assetPath);
    Uint8List fileBytes = byteData.buffer.asUint8List();

    final directory = await getApplicationDocumentsDirectory();
    final String dirPath = '${directory.path}/user_icons';
    final String newFilePath = '$dirPath/$newFileName.png';

    // ディレクトリが存在するか確認し、存在しない場合は作成する
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    File newFile = File(newFilePath);
    await newFile.writeAsBytes(fileBytes);

    return newFilePath;
  } catch (e) {
    print('Error saving asset as file: $e');
    throw e;
  }
}

///
/// テンプレートアイコン画像を、ユーザ画像として、Storageにアップロード
/// ＋ダウンロードURLを取得
///
Future<String> uploadFileToFirebaseStorage(
    String filePath, String newFileName) async {
  try {
    File file = File(filePath);
    Uint8List fileBytes = await file.readAsBytes();

    final Reference storageRef =
        FirebaseStorage.instance.ref().child('user_icons/$newFileName.png');
    final UploadTask uploadTask = storageRef.putData(fileBytes);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
    final String downloadURL = await snapshot.ref.getDownloadURL();

    return downloadURL;
  } catch (e) {
    print('Error uploading file to Firebase Storage: $e');
    throw e;
  }
}

///
/// ダウンロードURLをUSERコレクションに追加
///
Future<void> saveUrlToFirestore(
    String uid, String userName, String iconURL) async {
  try {
    await FirebaseFirestore.instance.collection('USER').doc(uid).set({
      'USER_NAME': userName,
      'ICON_URL': iconURL,
      'GROUP_LIST': [],
      'SELECTED_GROUP_ID': '',
      'CREATE_DATE': Timestamp.now(),
      'UPDATE_DATE': Timestamp.now(),
    });
  } catch (e) {
    print('Error saving URL to Firestore: $e');
    throw e;
  }
}

///
/// 別名保存
/// Storageアップロード
/// USERコレクション登録
/// をすべて行うまとめ関数
///
Future<void> uploadAndSaveAssetImage(
    BuildContext context, String imagePath, String uid, String userName) async {
  try {
    ///
    /// 別名保存
    ///
    String newFilePath = await saveAssetAsFile(imagePath, uid);

    ///
    /// アップロード＋ダウンロードURL取得
    ///
    String downloadURL = await uploadFileToFirebaseStorage(newFilePath, uid);

    ///
    /// Firestore登録
    ///
    await saveUrlToFirestore(uid, userName, downloadURL);

    ///
    /// スナックバー
    ///
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text('File uploaded and saved locally as $newFileName.png!'),
    // ));

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return CreateGroupPage();
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
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Failed to upload, download, and save file'),
    ));
  }
}
