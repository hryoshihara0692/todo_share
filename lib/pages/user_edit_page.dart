import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_share/pages/home.dart';
import 'package:todo_share/riverpod/selected_icon.dart';
import 'package:todo_share/widgets/group_leave_dialog.dart';
import 'package:todo_share/widgets/icon_setting_dialog_update.dart';
import 'package:todo_share/widgets/responsive_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

class UserEditPage extends ConsumerStatefulWidget {
  const UserEditPage({super.key});

  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends ConsumerState<UserEditPage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _nameController = TextEditingController();
  // Map<String, String> groupList = {};
  // List<Map<String, dynamic>> groupList = [];
  List<Map<String, dynamic>> groupData = [];

  Future<Uint8List> loadImageBytes(String path) async {
    return await File(path).readAsBytes();
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userDoc = await firestore.collection('USER').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data();
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<void> _fetchUserData() async {
    final data = await getUserData(uid);
    setState(() {
      userData = data;
      if (userData != null) {
        _nameController.text = userData!['USER_NAME'] ?? '';
      }
      isLoading = false;
    });
  }

  ///
  /// 新規でfetchデータ関数作成
  ///
  Future<void> fetchGroups() async {
    setState(() {
      isLoading = true; // ローディング開始
    });

    final data = await fetchGroupData(uid);

    setState(() {
      groupData = data;
      isLoading = false; // ローディング終了
    });
  }

  Future<List<Map<String, dynamic>>> fetchGroupData(String uid) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('USER').doc(uid);
      final groupSnapshot = await userRef.collection('GROUP').get();
      final List<Map<String, dynamic>> groupData = [];

      for (var doc in groupSnapshot.docs) {
        final groupId = doc.id;
        final orderNo = doc['ORDER_NO'];

        final groupDoc = await FirebaseFirestore.instance
            .collection('GROUP')
            .doc(groupId)
            .get();

        if (groupDoc.exists) {
          groupData.add({
            'GROUP_ID': groupId,
            'ORDER_NO': orderNo,
            'GROUP_NAME': groupDoc['GROUP_NAME'],
          });
        }
      }

      groupData.sort((a, b) => a['ORDER_NO'].compareTo(b['ORDER_NO']));
      return groupData;
    } catch (e) {
      print('Error fetching group data: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    // _fetchUserGroups();
    fetchGroups();
  }

  Future<void> _updateUserName() async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('USER').doc(uid).update({
        'USER_NAME': _nameController.text,
      });
      // スナックバーを表示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("ユーザー名が更新されました！"),
          backgroundColor: Colors.blue, // エラーを強調する赤色
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('Error updating user name: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('名前の更新に失敗しました')),
      );
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = groupData.removeAt(oldIndex);
      groupData.insert(newIndex, item);

      // ORDER_NOを更新
      for (int i = 0; i < groupData.length; i++) {
        groupData[i]['ORDER_NO'] = i;
      }
    });

    // Firestoreへ保存
    _updateOrderInFirestore(groupData);
  }

  Future<void> _updateOrderInFirestore(
      List<Map<String, dynamic>> sortedGroupData) async {
    final batch = FirebaseFirestore.instance.batch();
    final userRef = FirebaseFirestore.instance.collection('USER').doc(uid);

    for (var group in sortedGroupData) {
      final groupDocRef = userRef.collection('GROUP').doc(group['GROUP_ID']);
      batch.update(groupDocRef, {'ORDER_NO': group['ORDER_NO']});
    }

    await batch.commit();
    print('Order updated successfully in Firestore');
  }

  @override
  Widget build(BuildContext context) {
    var selectedIcon = ref.watch(selectedIconNotifierProvider);
    if (isLoading) {
      // return Center(child: CircularProgressIndicator());
      return Center(
          // child: Image.asset('assets/images/tmp.gif'),
          );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64.0,
        backgroundColor: Color.fromARGB(255, 235, 235, 235),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return HomePage();
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  // 右から左
                  // final Offset begin = Offset(1.0, 0.0);
                  // 左から右
                  final Offset begin = Offset(-1.0, 0.0);
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
          },
        ),
        centerTitle: true,
        title: Text(
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
      ),
      body: Container(
        height: 840,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 235, 235, 235),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16.0),
              Stack(
                children: [
                  // Container(
                  //   width: 160,
                  //   height: 160,
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     color: Colors.grey[300], // 画像がない場合の背景色
                  //   ),
                  //   child: FutureBuilder<String>(
                  //     future: getUserIconPath(
                  //         uid), // ユーザーのアイコンのローカルファイルパスを取得する非同期関数
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return Center(
                  //             // child: CircularProgressIndicator(),
                  //             // child: Image.asset(
                  //             //     'assets/images/tmp.gif'),
                  //             );
                  //       } else if (snapshot.hasError) {
                  //         return Center(
                  //           child: Text('Error: ${snapshot.error}'),
                  //         );
                  //       } else {
                  //         String? iconPath = snapshot.data;
                  //         if (iconPath != null && File(iconPath).existsSync()) {
                  //           // ローカル画像を取得
                  //           return Container(
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               image: DecorationImage(
                  //                 image: FileImage(File(iconPath)),
                  //                 fit: BoxFit.cover, // 画像を中央に拡大して丸く収める
                  //               ),
                  //             ),
                  //           );
                  //         } else {
                  //           print('Firestore Storageから直接表示してます');
                  //           // ファイルが存在しない場合はFirestoreからアイコンのURLを取得して表示
                  //           return FutureBuilder<String>(
                  //             future: _getUserIconUrl(uid),
                  //             builder: (context, snapshot) {
                  //               if (snapshot.connectionState ==
                  //                   ConnectionState.waiting) {
                  //                 return Center(
                  //                     // child:
                  //                     // CircularProgressIndicator(),
                  //                     // Image.asset(
                  //                     //     'assets/images/tmp.gif'),
                  //                     );
                  //               } else if (snapshot.hasError) {
                  //                 return Center(
                  //                   child: Text('Failed to load image'),
                  //                 );
                  //               } else {
                  //                 String iconUrl = snapshot.data ?? '';

                  //                 return Image.network(
                  //                   iconUrl,
                  //                   width: 32,
                  //                   height: 32,
                  //                   loadingBuilder: (BuildContext context,
                  //                       Widget child,
                  //                       ImageChunkEvent? loadingProgress) {
                  //                     if (loadingProgress == null) return child;
                  //                     return Center(
                  //                         // child:
                  //                         //     CircularProgressIndicator(
                  //                         //   value: loadingProgress
                  //                         //               .expectedTotalBytes !=
                  //                         //           null
                  //                         //       ? loadingProgress
                  //                         //               .cumulativeBytesLoaded /
                  //                         //           loadingProgress
                  //                         //               .expectedTotalBytes!
                  //                         //       : null,
                  //                         // ),
                  //                         // child: Image.asset(
                  //                         //     'assets/images/tmp.gif'),
                  //                         );
                  //                   },
                  //                   errorBuilder: (BuildContext context,
                  //                       Object exception,
                  //                       StackTrace? stackTrace) {
                  //                     // エラー時の処理
                  //                     return Center(
                  //                       child: Text('Failed to load image'),
                  //                     );
                  //                   },
                  //                 );
                  //               }
                  //             },
                  //           );
                  //         }
                  //       }
                  //     },
                  //   ),
                  // ),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300], // 画像がない場合の背景色
                    ),
                    child: FutureBuilder<String>(
                      future: getUserIconPath(uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          String? iconPath = snapshot.data;
                          if (iconPath != null && File(iconPath).existsSync()) {
                            // 🔥 `MemoryImage` に変換するための `FutureBuilder` をネストする
                            return FutureBuilder<Uint8List>(
                              future: loadImageBytes(iconPath),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError ||
                                    snapshot.data == null) {
                                  return Center(
                                      child: Text('Failed to load image'));
                                } else {
                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: MemoryImage(
                                            snapshot.data!), // キャッシュ回避
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          } else {
                            print('Firestore Storageから直接表示してます');
                            return FutureBuilder<String>(
                              future: _getUserIconUrl(uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Failed to load image'));
                                } else {
                                  String iconUrl = snapshot.data ?? '';
                                  return Image.network(
                                    iconUrl,
                                    width: 160,
                                    height: 160,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                          child: CircularProgressIndicator());
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                          child: Text('Failed to load image'));
                                    },
                                  );
                                }
                              },
                            );
                          }
                        }
                      },
                    ),
                  ),
                  Positioned(
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return IconSettingUpdateDialog();
                          },
                        ).then((result) {
                          if (result != 'confirmed') {
                            // ダイアログが決定ボタン以外で閉じられた場合の処理
                            // var notifier = ref.read(
                            //     selectedIconNotifierProvider.notifier);
                            // notifier.update('');
                            print('confirmed来てる');
                            uploadAndSaveAssetImage(context, selectedIcon, uid);
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
                            child: Image.asset('assets/images/UserSetting.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
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
              SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                height: 56,
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
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '名前を入力してください',
                          ),
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: GoogleFonts.notoSansJp(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ).fontFamily,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.save),
                      onPressed: _updateUserName,
                    ),
                  ],
                ),
              ),

              ///
              /// グループ一覧
              ///
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'グループ一覧',
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
                height: 240,
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
                child: ReorderableListView(
                  onReorder: _onReorder,
                  children: List.generate(groupData.length, (index) {
                    print("表示直前：$groupData");
                    // final groupId = groupList.keys.elementAt(index);
                    final groupId = groupData[index]['GROUP_ID'];
                    // final groupName = groupList[groupId]!;
                    final groupName = groupData[index]['GROUP_NAME'];
                    return ListTile(
                      key: ValueKey(groupId),
                      title: Row(
                        children: [
                          Expanded(
                            child: ResponsiveText(
                              text: groupName,
                              maxFontSize: 20,
                              minFontSize: 16,
                              maxLines: 1,
                              shadowEnabled: false,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                builder: (_) {
                                  return GroupLeaveDialog(
                                    groupId: groupId,
                                    groupName: groupName,
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                width: 32,
                                height: 32,
                                child: Image.asset('assets/images/Exit.png'),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onPanUpdate: (details) {
                              // ユーザーがハンバーガーアイコンをドラッグした場合の処理
                              // ここで並び替え処理を組み込む
                              print('Dragging...');
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              child: Image.asset('assets/images/humburger.png'),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),

              ///
              /// グループ作成ボタン
              ///
              Container(
                width: 240,
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
                  onPressed: () {},
                  // ボタンの色と枠線を設定する
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 122, 195, 220),
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                  child: Padding(
                    // 指マーク用として右にスペースを開ける＋テキスト下がるので4上げる
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'グループを作成する',
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getUserIconPath(String userId) async {
    // アプリのドキュメントディレクトリーを取得
    final directory = await getApplicationDocumentsDirectory();
    final String dirPath = path.join(directory.path, 'user_icons');

    // ユーザーごとのアイコン画像のファイルパス
    final String filePath = path.join(dirPath, '$userId.png');

    // ファイルが存在するかチェック
    bool fileExists = await File(filePath).exists();

    if (fileExists) {
      // ローカルにファイルがある場合はそのパスを返す
      print('ローカルを使ってます。');
      return filePath;
    } else {
      print('Firestoreからダウンロードします');
      // FirestoreからアイコンURLを取得して、ローカルに保存する
      final iconUrl = await _getUserIconUrl(userId);
      await _downloadAndSaveImage(iconUrl, filePath);
      return filePath;
    }
  }

  // UIDを用いてユーザーのICON_URLを取得する関数
  Future<String> _getUserIconUrl(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('USER').doc(uid).get();
    return userDoc.data()?['ICON_URL'] ?? '';
  }

  Future<void> _downloadAndSaveImage(String imageUrl, String filePath) async {
    final response =
        await FirebaseStorage.instance.refFromURL(imageUrl).getData();
    await File(filePath).writeAsBytes(response!);
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
      'PRIMARY_GROUP_ID': '',
      'CREATE_DATE': Timestamp.now(),
      'UPDATE_DATE': Timestamp.now(),
    });
  } catch (e) {
    print('Error saving URL to Firestore: $e');
    throw e;
  }
}

///
/// ダウンロードURLをUSERコレクションに追加
///
Future<void> updateUserImageToFirestore(String uid, String iconURL) async {
  try {
    await FirebaseFirestore.instance.collection('USER').doc(uid).update({
      'ICON_URL': iconURL,
      'UPDATE_DATE': Timestamp.now(),
    });
  } catch (e) {
    print('Error updating user image in Firestore: $e');
    throw e;
  }
}

Future<void> uploadAndSaveAssetImage(
    BuildContext context, String imagePath, String uid) async {
  print('どうでしょうか$imagePath');
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
    await updateUserImageToFirestore(uid, downloadURL);

    ///
    /// スナックバー
    ///
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text('File uploaded and saved locally as $newFileName.png!'),
    // ));

    // Navigator.of(context).pushReplacement(
    //   PageRouteBuilder(
    //     pageBuilder: (context, animation, secondaryAnimation) {
    //       return CreateGroupPage();
    //     },
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       // 右から左
    //       final Offset begin = Offset(1.0, 0.0);
    //       // 左から右
    //       // final Offset begin = Offset(-1.0, 0.0);
    //       final Offset end = Offset.zero;
    //       final Animatable<Offset> tween = Tween(begin: begin, end: end)
    //           .chain(CurveTween(curve: Curves.easeInOut));
    //       final Animation<Offset> offsetAnimation = animation.drive(tween);
    //       return SlideTransition(
    //         position: offsetAnimation,
    //         child: child,
    //       );
    //     },
    //   ),
    // );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Failed to upload, download, and save file'),
    ));
  }
}
