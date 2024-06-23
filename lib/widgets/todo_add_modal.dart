import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/database/class/todo_fields.dart';
import 'package:todo_share/database/todo_data_service.dart';
import 'package:todo_share/riverpod/selected_group.dart';
import 'package:todo_share/riverpod/selected_todolist.dart';
import 'package:todo_share/widgets/todo_card_create.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoAddModal extends ConsumerStatefulWidget {
  const TodoAddModal({
    super.key,
  });

  @override
  _AddTodoModalState createState() => _AddTodoModalState();
}

class _AddTodoModalState extends ConsumerState<TodoAddModal> {
  String content = '';

  @override
  Widget build(BuildContext context) {
    var selectedTodoListID = ref.read(selectedTodoListNotifierProvider);
    var selectedGroupID = ref.read(selectedGroupNotifierProvider);

    return Container(
      height: 508,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 249, 245, 236),
        borderRadius: const BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TodoCardCreate(
              onChanged: (newValue) {
                setState(() {
                  content = newValue;
                });
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  // padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    // borderRadius: BorderRadius.circular(5),
                    onTap: () {
                      print('aaaaaaa');
                    },
                    // splashColor: const Color(0xff000000).withAlpha(30),
                    child: Image.asset('assets/images/SelectMark.png'),
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  // selectedTodoListID,
                  '買い物リスト',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: GoogleFonts.notoSansJp(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ).fontFamily,
                  ),
                ),
                Expanded(
                  child: Container(),
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
                      // print('Tapおっけー');
                      // Map<String, dynamic> todoData = {
                      //   // "CONTENT": _todoContentController.text,
                      //   "CONTENT": 'test',
                      //   "CHECK_FLG": false,
                      //   "CREATE_DATE": Timestamp.fromDate(DateTime.now()),
                      //   "UPDATE_DATE": Timestamp.fromDate(DateTime.now()),
                      // };

                      TodoFields todoFields = TodoFields(
                        content: content.isNotEmpty
                            ? content
                            : 'だめっぽい', // テスト用のデフォルト値
                        checkFlg: false,
                        createDate: Timestamp.fromDate(DateTime.now()),
                        updateDate: Timestamp.fromDate(DateTime.now()),
                      );

                      // TODOLISTコレクションにドキュメント追加
                      await TodoDataService.createTodoData(
                          selectedGroupID.value!,
                          selectedTodoListID.value!,
                          todoFields.toMap());
                      Navigator.pop(context);
                    },
                    // ボタンの色と枠線を設定する
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 15, 217, 15),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
