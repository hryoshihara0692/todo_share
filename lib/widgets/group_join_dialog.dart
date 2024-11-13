import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/database/singleton/uid.dart';
import 'package:todo_share/database/todolist_data_service.dart';
import 'package:todo_share/riverpod/selected_group.dart';
import 'package:todo_share/riverpod/selected_todolist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class GroupJoinDialog extends ConsumerWidget {
  const GroupJoinDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var selectedTodoList = ref.read(selectedTodoListNotifierProvider);
    var selectedGroupID = ref.read(selectedGroupNotifierProvider);

    final TextEditingController _groupIdController = TextEditingController();
    // final TextEditingController _passController = TextEditingController();
    final FocusNode _groupIdFocusNode = FocusNode();

    // Post-frame callback to request focus after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _groupIdFocusNode.requestFocus();
    });

    // final String? uid = UID().uid;
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    Future<int> getGroupUserDocumentCount(String groupId) async {
      try {
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('GROUP')
            .doc(uid)
            .collection('USER')
            .get();

        return userSnapshot.size;
      } catch (e) {
        print('Error getting group document count: $e');
        return 0; // エラーが発生した場合は0を返す
      }
    }

    Future<int> getUserGroupDocumentCount(String uid) async {
      try {
        QuerySnapshot groupSnapshot = await FirebaseFirestore.instance
            .collection('USER')
            .doc(uid)
            .collection('GROUP')
            .get();

        return groupSnapshot.size;
      } catch (e) {
        print('Error getting group document count: $e');
        return 0; // エラーが発生した場合は0を返す
      }
    }

    return Dialog(
      insetPadding: EdgeInsets.all(0.0),
      child: Container(
        width: 392,
        height: 254,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 235, 235, 235),
          borderRadius: const BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(
                height: 24.0,
              ),
              Text(
                'グループに参加する',
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
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'グループID',
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
              // Container(
              //   width: double.infinity,
              //   height: 40,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black,
              //         blurRadius: 0,
              //         offset: Offset(2.5, 2.5),
              //       )
              //     ],
              //     border: Border.all(color: Colors.black, width: 1.0),
              //   ),
              //   child: Row(
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.symmetric(
              //           horizontal: 8.0,
              //         ),
              //         child: Text(
              //           '吉原家',
              //           style: TextStyle(
              //             fontSize: 20,
              //             fontFamily: GoogleFonts.notoSansJp(
              //               textStyle: TextStyle(
              //                 fontWeight: FontWeight.w700,
              //               ),
              //             ).fontFamily,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
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
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  // child: TextField(
                  //   controller: _groupIdController,
                  //   focusNode: _groupIdFocusNode,
                  //   decoration: const InputDecoration(
                  //     border: InputBorder.none,
                  //     hintText: '\u{2709}  sample@todolist.com',
                  //   ),
                  // ),
                  child: TextField(
                    controller: _groupIdController,
                    focusNode: _groupIdFocusNode,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '\u{2709}  sample@todolist.com',
                    ),
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),

              ///
              /// 戻る決定ボタン
              ///
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        // print('Tapおっけー');
                        // _showModal(context);
                        Navigator.of(context).pop();
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
                          '戻  る',
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
                    width: 24.0,
                  ),
                  ///
                  /// 決定ボタン
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
                      onPressed: () async {
                        String groupId = _groupIdController.text;
                        if (groupId.isNotEmpty) {
                          try {
                            // groupコレクションから参加するgroupIDのドキュメントを取得
                            DocumentSnapshot groupDoc = await FirebaseFirestore
                                .instance
                                .collection('GROUP')
                                .doc(groupId)
                                .get();

                            if (groupDoc.exists) {
                              // todolistサブコレクションのドキュメントIDのリストを取得
                              QuerySnapshot todoListSnapshot =
                                  await FirebaseFirestore.instance
                                      .collection('GROUP')
                                      .doc(groupId)
                                      .collection('TODOLIST')
                                      .get();
                              List<String> todoListIds = todoListSnapshot.docs
                                  .map((doc) => doc.id)
                                  .toList();

                              int userCount =
                                  await getGroupUserDocumentCount(groupId);
                              await FirebaseFirestore.instance
                                  .collection('GROUP')
                                  .doc(groupId)
                                  .collection('USER')
                                  .doc(uid)
                                  .set({
                                'ORDER_NO': userCount + 1,
                                'CREATE_DATE': Timestamp.now(),
                                'UPDATE_DATE': Timestamp.now(),
                              });
                              print('現在のuid：' + uid!);

                              // USERコレクションの配下のGROUPサブコレクションにgroupIDでドキュメントを作成
                              if (uid != null) {
                                DocumentReference userGroupRef =
                                    FirebaseFirestore.instance
                                        .collection('USER')
                                        .doc(uid)
                                        .collection('GROUP')
                                        .doc(groupId);
                                print('参加するgroupId：' + groupId);

                                // 参加するユーザの参加しているGROUPの数を取得→参加グループを一番最後にするため
                                int groupCount =
                                    await getUserGroupDocumentCount(uid);
                                // 参加するグループで、初期表示するTODOLISTのIDを取得
                                if (todoListIds.isNotEmpty) {
                                  String firstTodoListID = todoListIds.first;
                                  await userGroupRef.set({
                                    'ORDER_NO': groupCount + 1,
                                    'PRIMARY_TODOLIST_ID': firstTodoListID,
                                    'CREATE_DATE': Timestamp.now(),
                                    'UPDATE_DATE': Timestamp.now(),
                                  });

                                  ///
                                  ///
                                  ///いらなそう
                                  ///
                                  ///
                                  // GROUPサブコレクションの配下にTODOLISTコレクションを作成し、todoListIdsをドキュメントIDとして登録
                                  for (int i = 0; i < todoListIds.length; i++) {
                                    String todoListId = todoListIds[i];
                                    await userGroupRef
                                        .collection('TODOLIST')
                                        .doc(todoListId)
                                        .set({
                                      'ORDER_NO': i,
                                      'CREATE_DATE': Timestamp.now(),
                                      'UPDATE_DATE': Timestamp.now(),
                                    });
                                  }
                                } else {
                                  await userGroupRef.set({
                                    'ORDER_NO': groupCount + 1,
                                    'PRIMARY_TODOLIST_ID': '',
                                    'CREATE_DATE': Timestamp.now(),
                                    'UPDATE_DATE': Timestamp.now(),
                                  });
                                }
                              }
                            } else {
                              // グループが存在しない場合のエラーハンドリング
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('グループが見つかりません')),
                              );
                            }
                          } catch (e) {
                            // エラーハンドリング
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('エラーが発生しました: $e')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('グループIDを入力してください')),
                          );
                        }

                        Navigator.of(context).pop();
                      },
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
                          '決  定',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
