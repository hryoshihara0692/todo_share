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

class TodoListSettingDialog extends ConsumerWidget {
  const TodoListSettingDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var selectedTodoList = ref.read(selectedTodoListNotifierProvider);
    var selectedGroupID = ref.read(selectedGroupNotifierProvider);

    final TextEditingController _todoListNameController =
        TextEditingController();
    // final TextEditingController _passController = TextEditingController();
    final FocusNode _todoListNameFocusNode = FocusNode();

    // Post-frame callback to request focus after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _todoListNameFocusNode.requestFocus();
    });

    final String? uid = UID().uid;

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
                'TODOリスト作成',
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
                  padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
                  child: TextField(
                    controller: _todoListNameController,
                    focusNode: _todoListNameFocusNode,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '\u{2709}  sample@todolist.com',
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
                        var uuid = Uuid();
                        var todoListID = uuid.v4();

                        ///
                        /// TODOLISTコレクションに追加
                        ///
                        Map<String, dynamic> todolistData = {
                          "TODOLIST_NAME": _todoListNameController.text,
                          "CREATE_DATE": Timestamp.fromDate(DateTime.now()),
                          "UPDATE_DATE": Timestamp.fromDate(DateTime.now()),
                        };
                        // TODOLISTコレクションにドキュメント追加
                        // await TodoListDataService.createTodoListData(
                        //     selectedGroupID.value!, todolistData);
                        await FirebaseFirestore.instance
                            .collection('GROUP')
                            .doc(selectedGroupID.value)
                            .collection('TODOLIST')
                            .doc(todoListID)
                            .set(todolistData);

                        ///
                        /// USERコレクション配下の、GROUPサブコレクション上でTODOLIST_IDをPRIMARYに登録する
                        ///
                        await FirebaseFirestore.instance
                            .collection('USER')
                            .doc(uid)
                            .collection('GROUP')
                            .doc(selectedGroupID.value)
                            .update({
                          'PRIMARY_TODOLIST_ID': todoListID,
                          'UPDATE_DATE': Timestamp.fromDate(DateTime.now()),
                        }).then((_) {
                          // 更新が成功した場合の処理
                          print('Field updated successfully.');
                        }).catchError((error) {
                          // 更新が失敗した場合のエラーハンドリング
                          print('Failed to update field todolist_test: $error');
                        });

                        ///
                        /// USER-GROUPコレクション配下に、TODOLIST一覧用サブコレクションを追加
                        ///
                        await FirebaseFirestore.instance
                            .collection('USER')
                            .doc(uid)
                            .collection('GROUP')
                            .doc(selectedGroupID.value)
                            .collection('TODOLIST')
                            .doc(todoListID)
                            .set({
                          'ORDER_NO': 0,
                          'CREATE_DATE': Timestamp.now(),
                          'UPDATE_DATE': Timestamp.now(),
                        });

                        Navigator.pop(context);
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
