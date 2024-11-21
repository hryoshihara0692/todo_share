import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/database/singleton/uid.dart';
import 'package:todo_share/database/user_data_service.dart';
import 'package:todo_share/pages/create_group.dart';
import 'package:todo_share/riverpod/selected_group.dart';
import 'package:todo_share/utils/modal_utils.dart';
import 'package:todo_share/widgets/group_join_dialog.dart';
import 'package:todo_share/widgets/responsive_text.dart';
import 'package:todo_share/widgets/user_edit_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

class SideMenu extends ConsumerWidget {
  const SideMenu({Key? key}) : super(key: key);

  Future<String> _getDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final String dirPath = '${directory.path}/user_icons';
    return dirPath;
  }

  // UIDを用いてユーザーのグループ名とユーザーID一覧を取得する関数
  Future<Map<String, dynamic>> _getUserGroupsAndUserIds(String uid) async {
    // USERコレクションからPRIMARY_GROUP_IDを取得
    final userDoc =
        await FirebaseFirestore.instance.collection('USER').doc(uid).get();
    final primaryGroupId = userDoc.data()?['PRIMARY_GROUP_ID'];

    // USERコレクションのGROUPサブコレクションのドキュメントIDを取得
    final userGroupsSnapshot = await FirebaseFirestore.instance
        .collection('USER')
        .doc(uid)
        .collection('GROUP')
        .get();

    // ドキュメントIDリストを作成
    List<String> groupIds =
        userGroupsSnapshot.docs.map((doc) => doc.id).toList();

    // ドキュメントIDに対応するGroupコレクションからGROUP名を取得
    Map<String, String> groupMap = {};
    Map<String, List<String>> groupUsersMap = {};
    for (String groupId in groupIds) {
      final groupSnapshot = await FirebaseFirestore.instance
          .collection('GROUP')
          .doc(groupId)
          .get();
      if (groupSnapshot.exists) {
        groupMap[groupId] = groupSnapshot.data()?['GROUP_NAME'] ?? 'No Name';

        // GROUPコレクション配下のUSERサブコレクションのドキュメントID一覧を取得
        final groupUsersSnapshot = await FirebaseFirestore.instance
            .collection('GROUP')
            .doc(groupId)
            .collection('USER')
            .get();
        groupUsersMap[groupId] =
            groupUsersSnapshot.docs.map((doc) => doc.id).toList();
      }
    }

    // PRIMARY_GROUP_IDをマップに追加
    groupMap['PRIMARY_GROUP_ID'] = primaryGroupId ?? '';

    return {'groupMap': groupMap, 'groupUsersMap': groupUsersMap};
  }

  // UIDを用いてユーザーのICON_URLを取得する関数
  Future<String> _getUserIconUrl(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('USER').doc(uid).get();
    return userDoc.data()?['ICON_URL'] ?? '';
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
      return filePath;
    } else {
      // FirestoreからアイコンURLを取得して、ローカルに保存する
      final iconUrl = await _getUserIconUrl(userId);
      await _downloadAndSaveImage(iconUrl, filePath);
      return filePath;
    }
  }

  Future<void> _downloadAndSaveImage(String imageUrl, String filePath) async {
    final response =
        await FirebaseStorage.instance.refFromURL(imageUrl).getData();
    await File(filePath).writeAsBytes(response!);
  }

  Future<String> _getUserName(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('USER').doc(uid).get();
    return userDoc.data()?['USER_NAME'] ?? 'Unknown User';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    var selectedGroupID = ref.read(selectedGroupNotifierProvider);

    return FutureBuilder<String>(
      future: _getDirectory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final dirPath = snapshot.data ?? '';

          return FutureBuilder<Map<String, dynamic>>(
            future: _getUserGroupsAndUserIds(uid!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final groupData = snapshot.data ?? {};
                final groupMap = groupData['groupMap'] as Map<String, String>;
                final groupUsersMap =
                    groupData['groupUsersMap'] as Map<String, List<String>>;
                final primaryGroupId = groupMap.remove('PRIMARY_GROUP_ID');

                return Drawer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0),
                    ),
                    child: Container(
                      width: 272,
                      color: Color.fromARGB(255, 249, 245, 236),

                      ///
                      /// ユーザー部分
                      ///
                      child: Padding(
                        padding: const EdgeInsets.only(top: 48.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 4.0, 16.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    child: FutureBuilder<String>(
                                      future: getUserIconPath(
                                          uid), // ユーザーのアイコンのローカルファイルパスを取得する非同期関数
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'),
                                          );
                                        } else {
                                          String? iconPath = snapshot.data;

                                          if (iconPath != null) {
                                            // ローカルにファイルが存在する場合はその画像を表示
                                            return Image.file(
                                              File(iconPath),
                                              width: 32,
                                              height: 32,
                                            );
                                          } else {
                                            print(
                                                'Firestore Storageから直接表示してます');
                                            // ファイルが存在しない場合はFirestoreからアイコンのURLを取得して表示
                                            return FutureBuilder<String>(
                                              future: _getUserIconUrl(uid),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return Center(
                                                    child: Text(
                                                        'Failed to load image'),
                                                  );
                                                } else {
                                                  String iconUrl =
                                                      snapshot.data ?? '';

                                                  return Image.network(
                                                    iconUrl,
                                                    width: 32,
                                                    height: 32,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      );
                                                    },
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      // エラー時の処理
                                                      return Center(
                                                        child: Text(
                                                            'Failed to load image'),
                                                      );
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
                                  SizedBox(width: 16.0),
                                  FutureBuilder<String>(
                                    future: _getUserName(uid),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else {
                                        final userName =
                                            snapshot.data ?? 'Unknown User';
                                        return Container(
                                          width: 144,
                                          child: Text(
                                            userName.length > 16
                                                ? '${userName.substring(0, 16)}…'
                                                : userName,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily:
                                                  GoogleFonts.notoSansJp(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ).fontFamily,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  // Text(
                                  //   'あおやぎ',
                                  //   style: TextStyle(
                                  //     fontSize: 18,
                                  //     fontFamily: GoogleFonts.notoSansJp(
                                  //       textStyle: TextStyle(
                                  //         fontWeight: FontWeight.w700,
                                  //       ),
                                  //     ).fontFamily,
                                  //   ),
                                  // ),
                                  Expanded(child: Container()),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      child: InkWell(
                                        onTap: () {
                                          showUserSettingModal(context);
                                        },
                                        splashColor: const Color(0xff000000)
                                            .withAlpha(30),
                                        child: Image.asset(
                                            'assets/images/UserSetting.png'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            SizedBox(height: 16.0),

                            ///
                            /// グループ選択部分
                            ///
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 16.0),
                                Text(
                                  'グループ選択',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: GoogleFonts.notoSansJp(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ).fontFamily,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24.0),

                            ...groupMap.entries.map((entry) {
                              String groupId = entry.key;
                              String groupName = entry.value;
                              List<String> userIds =
                                  groupUsersMap[groupId] ?? [];

                              return GestureDetector(
                                onTap: () async {
                                  if (groupId != selectedGroupID) {
                                    var notifier = ref.read(
                                        selectedGroupNotifierProvider.notifier);
                                    notifier.setSelectedGroup(groupId);
                                    await UserDataService
                                        .updateUserPrimaryGroupID(uid, groupId);
                                    // Scaffold.of(context).closeDrawer();
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          child: groupId ==
                                                  selectedGroupID.value
                                              ? Image.asset(
                                                  'assets/images/SelectMark.png')
                                              : Container(), // 画像のサイズの空白
                                        ),
                                      ),
                                      Expanded(
                                        child: ResponsiveText(
                                          text: groupName,
                                          maxFontSize: 16,
                                          minFontSize: 16,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Stack(children: [
                                        Container(
                                          width: 80,
                                          height: 32,
                                        ),
                                        ...userIds.map((userId) {
                                          int index = userIds.indexOf(userId);
                                          if (index > 0) {
                                            return Positioned(
                                              top: 0,
                                              right: 24,
                                              child: Container(
                                                height: 32,
                                                child: FutureBuilder<String>(
                                                  future: getUserIconPath(
                                                      userId), // ユーザーのアイコンのローカルファイルパスを取得する非同期関数
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Center(
                                                        child: Text(
                                                            'Error: ${snapshot.error}'),
                                                      );
                                                    } else {
                                                      String? iconPath =
                                                          snapshot.data;

                                                      if (iconPath != null) {
                                                        // ローカルにファイルが存在する場合はその画像を表示
                                                        return Image.file(
                                                          File(iconPath),
                                                          width: 32,
                                                          height: 32,
                                                        );
                                                      } else {
                                                        print(
                                                            'Firestore Storageから直接表示してます');
                                                        // ファイルが存在しない場合はFirestoreからアイコンのURLを取得して表示
                                                        return FutureBuilder<
                                                            String>(
                                                          future:
                                                              _getUserIconUrl(
                                                                  userId),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              );
                                                            } else if (snapshot
                                                                .hasError) {
                                                              return Center(
                                                                child: Text(
                                                                    'Failed to load image'),
                                                              );
                                                            } else {
                                                              String iconUrl =
                                                                  snapshot.data ??
                                                                      '';

                                                              return Image
                                                                  .network(
                                                                iconUrl,
                                                                width: 32,
                                                                height: 32,
                                                                loadingBuilder: (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
                                                                    ImageChunkEvent?
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null)
                                                                    return child;
                                                                  return Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      value: loadingProgress.expectedTotalBytes !=
                                                                              null
                                                                          ? loadingProgress.cumulativeBytesLoaded /
                                                                              loadingProgress.expectedTotalBytes!
                                                                          : null,
                                                                    ),
                                                                  );
                                                                },
                                                                errorBuilder: (BuildContext
                                                                        context,
                                                                    Object
                                                                        exception,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                                  // エラー時の処理
                                                                  return Center(
                                                                    child: Text(
                                                                        'Failed to load image'),
                                                                  );
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
                                            );
                                          } else {
                                            return Container(
                                              height: 32,
                                              child: FutureBuilder<String>(
                                                future: getUserIconPath(
                                                    userId), // ユーザーのアイコンのローカルファイルパスを取得する非同期関数
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Center(
                                                      child: Text(
                                                          'Error: ${snapshot.error}'),
                                                    );
                                                  } else {
                                                    String? iconPath =
                                                        snapshot.data;

                                                    if (iconPath != null) {
                                                      // ローカルにファイルが存在する場合はその画像を表示
                                                      return Image.file(
                                                        File(iconPath),
                                                        width: 32,
                                                        height: 32,
                                                      );
                                                    } else {
                                                      print(
                                                          'Firestore Storageから直接表示してます');
                                                      // ファイルが存在しない場合はFirestoreからアイコンのURLを取得して表示
                                                      return FutureBuilder<
                                                          String>(
                                                        future: _getUserIconUrl(
                                                            userId),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            );
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return Center(
                                                              child: Text(
                                                                  'Failed to load image'),
                                                            );
                                                          } else {
                                                            String iconUrl =
                                                                snapshot.data ??
                                                                    '';

                                                            return Image
                                                                .network(
                                                              iconUrl,
                                                              width: 32,
                                                              height: 32,
                                                              loadingBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent?
                                                                          loadingProgress) {
                                                                if (loadingProgress ==
                                                                    null)
                                                                  return child;
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    value: loadingProgress.expectedTotalBytes !=
                                                                            null
                                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                                            loadingProgress.expectedTotalBytes!
                                                                        : null,
                                                                  ),
                                                                );
                                                              },
                                                              errorBuilder: (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                                // エラー時の処理
                                                                return Center(
                                                                  child: Text(
                                                                      'Failed to load image'),
                                                                );
                                                              },
                                                            );
                                                          }
                                                        },
                                                      );
                                                    }
                                                  }
                                                },
                                              ),
                                            );
                                          }
                                        }).toList(),
                                      ]),
                                      SizedBox(width: 8.0),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),

                            SizedBox(height: 16.0),
                            Expanded(child: Container()),

                            ///
                            /// サイドメニュー下
                            ///
                            SizedBox(height: 16.0),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const GroupJoinDialog();
                                  },
                                );
                              },
                              child: Container(
                                height: 32.0,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        child: Image.asset(
                                            'assets/images/CreateGroup.png'),
                                      ),
                                    ),
                                    Text(
                                      'グループに参加する',
                                      style: TextStyle(
                                        fontSize: 18,
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
                            SizedBox(height: 24.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return CreateGroupPage();
                                    },
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      // 右から左
                                      final Offset begin = Offset(1.0, 0.0);
                                      // 左から右
                                      // final Offset begin = Offset(-1.0, 0.0);
                                      final Offset end = Offset.zero;
                                      final Animatable<Offset> tween =
                                          Tween(begin: begin, end: end).chain(
                                              CurveTween(
                                                  curve: Curves.easeInOut));
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
                              child: Container(
                                height: 32.0,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        child: Image.asset(
                                            'assets/images/CreateGroup.png'),
                                      ),
                                    ),
                                    Text(
                                      'グループを新しく作る',
                                      style: TextStyle(
                                        fontSize: 18,
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
                            SizedBox(height: 24.0),
                            Container(
                              height: 32.0,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      child: Image.asset(
                                          'assets/images/Settings.png'),
                                    ),
                                  ),
                                  Text(
                                    'その他（設定など）',
                                    style: TextStyle(
                                      fontSize: 18,
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
                            ElevatedButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                              },
                              child: Text('ログアウト'),
                            ),
                            SizedBox(height: 48.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
