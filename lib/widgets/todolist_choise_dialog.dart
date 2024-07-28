import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_share/riverpod/selected_group.dart';
import 'package:todo_share/riverpod/selected_todolist.dart'; // Import your Riverpod provider

class TodoListChoiceDialog extends ConsumerStatefulWidget {
  final String groupId;
  final String initialTodoListId;

  TodoListChoiceDialog({
    super.key,
    required this.groupId,
    required this.initialTodoListId,
  });

  @override
  _TodoListChoiceDialogState createState() => _TodoListChoiceDialogState();
}

class _TodoListChoiceDialogState extends ConsumerState<TodoListChoiceDialog> {
  List<String> todoListIds = [];
  List<String> todoListNames = [];
  String? selectedTodoListId;

  @override
  void initState() {
    super.initState();
    _fetchTodoListIds(widget.groupId).then((ids) {
      setState(() {
        todoListIds = ids.keys.toList();
        todoListNames = ids.values.toList();
        selectedTodoListId = widget.initialTodoListId;
      });
    });
  }

  Future<Map<String, String>> _fetchTodoListIds(String groupId) async {
    Map<String, String> todoListIds = {};
    try {
      var todoListCollection = await FirebaseFirestore.instance
          .collection('GROUP')
          .doc(groupId)
          .collection('TODOLIST')
          .get();
      for (var doc in todoListCollection.docs) {
        todoListIds[doc.id] = doc.data()['TODOLIST_NAME'] ?? 'Unknown';
      }
    } catch (e) {
      print("Error fetching TODO list IDs: $e");
    }
    return todoListIds;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(0.0),
      child: Container(
        width: 392,
        height: 608,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 249, 245, 236),
          borderRadius: const BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TODOリストを選択',
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
            ),
            SizedBox(
              height: 8.0,
            ),

            ///
            /// リストビュー
            ///
            Container(
              width: 360,
              height: 408,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 0,
                    offset: Offset(6, 6),
                  )
                ],
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: todoListIds.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: todoListIds.length,
                      itemBuilder: (context, index) {
                        return RadioListTile(
                          value: todoListIds[index],
                          groupValue: selectedTodoListId,
                          onChanged: (String? value) {
                            setState(() {
                              selectedTodoListId = value;
                            });
                          },
                          title: Text(todoListNames[index]),
                        );
                      },
                    ),
            ),

            SizedBox(
              height: 24.0,
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
                      ref
                          .read(selectedTodoListNotifierProvider.notifier)
                          .update((state) => selectedTodoListId!);
                      Navigator.of(context).pop(selectedTodoListId);
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
            ),
          ],
        ),
      ),
    );
  }
}
