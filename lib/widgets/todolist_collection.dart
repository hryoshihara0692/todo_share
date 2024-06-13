import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/database/todolist_data_service.dart';
import 'package:todo_share/riverpod/selected_group.dart';
import 'package:todo_share/riverpod/selected_todolist.dart';
import 'package:todo_share/widgets/todolist_setting_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoListCollection extends ConsumerWidget {
  const TodoListCollection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedTodoListID = ref.watch(selectedTodoListNotifierProvider);
    var selectedGroupID = ref.watch(selectedGroupNotifierProvider);

    return selectedGroupID.when(
      data: (groupId) {
        if (groupId.isEmpty) {
          return Center(child: Text('No Group Selected'));
        }

        return StreamBuilder<QuerySnapshot>(
          stream: TodoListDataService.getTodoListCollection(groupId),
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('エラーが発生しました'));
            }

            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return SizedBox(
                height: 48,
                child: TextButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) {
                        return TodoListSettingDialog();
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    foregroundColor: Color.fromARGB(255, 15, 9, 64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    '＋TODOリスト作成',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: GoogleFonts.notoSansJp(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ).fontFamily,
                    ),
                  ),
                ),
              );
            }
            var todoListData = snapshot.data!.docs;
            return SizedBox(
              height: 48,
              child: ListView.builder(
                // key: ValueKey(selectedTodoList),  // Add key to maintain state
                scrollDirection: Axis.horizontal,
                itemCount: todoListData.length + 1,
                itemBuilder: (context, index) {
                  if (index == todoListData.length) {
                    return TextButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (_) {
                            return TodoListSettingDialog();
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        foregroundColor: Color.fromARGB(255, 15, 9, 64),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        '＋TODOリスト作成',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: GoogleFonts.notoSansJp(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ).fontFamily,
                        ),
                      ),
                    );
                  } else {
                    final todoList = todoListData[index]['TODOLIST_NAME'];
                    final todoListID = todoListData[index].id;
                    final isSelected = todoListID == selectedTodoListID.value;

                    // todoListCollectionのTODOリストを順番に表示する
                    return Container(
                      // 左右のTODOリストと2x2で4開けて、上下は4開ける
                      margin: EdgeInsets.fromLTRB(2.0, 4.0, 2.0, 4.0),
                      child: isSelected
                          ? ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                foregroundColor: Colors.white,
                                backgroundColor: Color.fromARGB(255, 15, 9, 64),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                todoList,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: GoogleFonts.notoSansJp(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ).fontFamily,
                                ),
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                var notifier = ref.read(
                                    selectedTodoListNotifierProvider.notifier);
                                notifier.setSelectedTodoList(todoListID);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                foregroundColor: Color.fromARGB(255, 15, 9, 64),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                todoList,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: GoogleFonts.notoSansJp(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ).fontFamily,
                                ),
                              ),
                            ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('エラーが発生しました: $error')),
    );
  }
}
