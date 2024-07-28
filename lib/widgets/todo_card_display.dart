import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/database/class/todo_fields.dart';
import 'package:todo_share/utils/modal_utils.dart';
import 'package:todo_share/widgets/deadline_edit_dialog.dart';
import 'package:todo_share/widgets/deadline_setting_dialog.dart';
import 'package:todo_share/widgets/manager_edit_dialog.dart';
import 'package:todo_share/widgets/memo_edit_dialog.dart';
import 'package:todo_share/widgets/todo_delete_dialog.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TodoCardDisplay extends StatelessWidget {
  final TodoFields todoFields;
  final String groupId;
  final String todoListId;
  final String todoId;

  const TodoCardDisplay({
    super.key,
    required this.todoFields,
    required this.groupId,
    required this.todoListId,
    required this.todoId,
  });

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

  @override
  Widget build(BuildContext context) {
    List<String> userIds = todoFields.managerIdList;

    return Container(
      width: double.infinity,
      height: 104,
      // TODOの形と影を設定する
      decoration: BoxDecoration(
        color: todoFields.checkFlg ? Colors.grey : Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 0,
            offset: Offset(4, 4),
          )
        ],
        border: Border.all(color: Colors.black, width: 2.0),
      ),
      child: Row(
        children: [
          ///
          /// チェックボタン
          ///
          InkWell(
            onTap: () async {
              // print('Tapおっけー');
              try {
                await FirebaseFirestore.instance
                    .collection('GROUP')
                    .doc(groupId)
                    .collection('TODOLIST')
                    .doc(todoListId)
                    .collection('TODO')
                    .doc(todoId)
                    .update({
                  'CHECK_FLG': !todoFields.checkFlg,
                });
                print('チェックフラグを更新しました');
              } catch (e) {
                print('エラーが発生しました: $e');
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                todoFields.checkFlg
                    ? 'assets/images/check_button_checked.png'
                    : 'assets/images/check_button.png',
                width: 32,
                height: 32,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 8.0,
                ),

                ///
                /// 1段目のテキスト（内容部分）
                ///
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48.0,
                        alignment: Alignment.centerLeft, // コンテナ内のテキストを中央左寄せにする
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // 余分なパディングを除去
                            alignment: Alignment.centerLeft, // テキストを中央左寄せにする
                          ),
                          onPressed: () {
                            // TodoAddModalの編集版を表示
                          },
                          onLongPress: () {
                            showDialog<void>(
                              context: context,
                              builder: (_) {
                                return DeleteDialog();
                              },
                            );
                          },
                          child: Container(
                            alignment:
                                Alignment.centerLeft, // 内側のコンテナ内のテキストを中央左寄せにする
                            constraints:
                                BoxConstraints.expand(), // コンテナのサイズにテキストを広げる
                            child: Text(
                              todoFields.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: GoogleFonts.notoSansJp().fontFamily,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    /// 2段目のメモボタン
                    GestureDetector(
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (_) {
                            return MemoEditDialog(
                              groupId: groupId,
                              todoListId: todoListId,
                              todoId: todoId,
                              memo: todoFields.memo,
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        child: Image.asset('assets/images/Memo.png'),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),

                    ///
                    /// 期限ボタン
                    ///
                    GestureDetector(
                      onTap: () {
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return DeadlineSettingDialog();
                        //   },
                        // );
                        showDialog<void>(
                          context: context,
                          builder: (_) {
                            return DeadlineEditDialog(
                              initialDeadline: todoFields.deadline.toDate(),
                              groupId: groupId,
                              todoListId: todoListId,
                              todoId: todoId,
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        child: Image.asset('assets/images/Deadline.jpeg'),
                      ),
                    ),

                    ///
                    /// 期限テキスト表示
                    ///
                    if (todoFields.deadline.toDate().year != 2000 &&
                        todoFields.deadline.toDate().month != 1 &&
                        todoFields.deadline.toDate().day != 1)
                      Text(
                        todoFields.deadline
                            .toDate()
                            .toString()
                            .substring(0, 16),
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: GoogleFonts.notoSansJp(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ).fontFamily,
                        ),
                      ),

                    Expanded(
                      child: Container(),
                    ),
                    // Container(
                    //   height: 32.0,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       Container(
                    //         width: 32.0,
                    //         height: 32.0,
                    //         child: Image.asset(
                    //             'assets/images/add_user_button.png'),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (_) {
                            return ManagerEditDialog(
                              managerList: todoFields.managerIdList,
                              groupId: groupId,
                              todoListId: todoListId,
                              todoId: todoId,
                            );
                          },
                        );
                      },
                      child: Stack(children: [
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
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Error: ${snapshot.error}'),
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
                                        print('Firestore Storageから直接表示してます');
                                        // ファイルが存在しない場合はFirestoreからアイコンのURLを取得して表示
                                        return FutureBuilder<String>(
                                          future: _getUserIconUrl(userId),
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
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
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
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
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
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
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
                                      print('Firestore Storageから直接表示してます');
                                      // ファイルが存在しない場合はFirestoreからアイコンのURLを取得して表示
                                      return FutureBuilder<String>(
                                        future: _getUserIconUrl(userId),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child:
                                                  Text('Failed to load image'),
                                            );
                                          } else {
                                            String iconUrl =
                                                snapshot.data ?? '';

                                            return Image.network(
                                              iconUrl,
                                              width: 32,
                                              height: 32,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
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
                                                      StackTrace? stackTrace) {
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
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
