import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/database/class/todo_fields.dart';
import 'package:todo_share/database/todo_data_service.dart';
import 'package:todo_share/riverpod/selected_group.dart';
import 'package:todo_share/riverpod/selected_todolist.dart';
import 'package:todo_share/utils/modal_utils.dart';
import 'package:todo_share/widgets/todo_card_display.dart';
import 'package:todo_share/widgets/todolist_setting_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoCollection extends ConsumerWidget {
  const TodoCollection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedTodoListID = ref.watch(selectedTodoListNotifierProvider);
    var selectedGroupID = ref.watch(selectedGroupNotifierProvider);

    return selectedGroupID.when(
      data: (groupId) {
        if (groupId.isEmpty) {
          return Center(child: Text('No Group Selected'));
        }
        return selectedTodoListID.when(
          data: (todoListId) {
            if (todoListId.isEmpty) {
              return Center(child: Text('No TodoList Selected'));
            }
            return StreamBuilder<QuerySnapshot>(
              stream: TodoDataService.getTodoCollection(groupId, todoListId),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // return Center(child: CircularProgressIndicator());
                  return Center(child: Image.asset('assets/images/tmp.gif'),);
                }
                if (snapshot.hasError) {
                  return Center(child: Text('エラーが発生しました'));
                }

                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Container();
                } else {
                  var todoData = snapshot.data!.docs;
                  return Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24, 8, 20, 8),
                      child: ListView.builder(
                        itemCount: todoData.length,
                        itemBuilder: (context, index) {
                          TodoFields todoFields = TodoFields(
                            checkFlg: todoData[index]['CHECK_FLG'],
                            content: todoData[index]['CONTENT'],
                            memo: todoData[index]['MEMO'],
                            deadline: todoData[index]['DEADLINE'],
                            managerIdList: List<String>.from(todoData[index]['MANAGER_ID_LIST']),
                            createDate: todoData[index]['CREATE_DATE'],
                            updateDate: todoData[index]['UPDATE_DATE'],
                          );

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4.0, 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   'Document ID: ${todoData[index].id}',
                                //   style: TextStyle(fontSize: 12, color: Colors.grey),
                                // ),
                                TodoCardDisplay(
                                  groupId: groupId,
                                  todoListId: todoListId,
                                  todoId: todoData[index].id,
                                  todoFields: todoFields,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            );
          },
          // loading: () => Center(child: CircularProgressIndicator()),
          loading: () => Center(child: Image.asset('assets/images/tmp.gif'),),
          error: (error, stack) => Center(child: Text('エラーが発生しました: $error')),
        );
      },
      // loading: () => Center(child: CircularProgressIndicator()),
      loading: () => Center(child: Image.asset('assets/images/tmp.gif'),),
      error: (error, stack) => Center(child: Text('エラーが発生しました: $error')),
    );
  }
}
