import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/database/class/notification_fields.dart';
import 'package:todo_share/database/class/todo_fields.dart';
import 'package:todo_share/database/todo_data_service.dart';
import 'package:todo_share/riverpod/selected_group.dart';
import 'package:todo_share/riverpod/selected_todolist.dart';
import 'package:todo_share/widgets/todo_card_create.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_share/widgets/todo_card_edit.dart';
import 'package:todo_share/widgets/todolist_choise_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoEditModal extends ConsumerStatefulWidget {
  final String groupId;
  final String todoListId;
  final String todoId;

  const TodoEditModal({
    super.key,
    required this.groupId,
    required this.todoListId,
    required this.todoId,
  });

  @override
  _EditTodoModalState createState() => _EditTodoModalState();
}

class _EditTodoModalState extends ConsumerState<TodoEditModal> {
  String content = '';
  bool isChecked = false;
  DateTime deadline = DateTime(2000, 1, 1, 00, 00, 00, 000);
  String memo = '';
  List<String> managerList = [];
  Map<String, dynamic>? groupData;
  Map<String, dynamic>? todoListData;
  bool isLoading = true;
  String? errorMessage;
  String? selectedTodoListName;

  final String uid = FirebaseAuth.instance.currentUser!.uid.toString();

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // モーダルが表示された後にフォーカスをリクエスト
      _focusNode.requestFocus();
    });
    _fetchFirestoreData();
  }

  @override
  void dispose() {
    // FocusNode を破棄してメモリリークを防ぐ
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchFirestoreData() async {
    try {
      var selectedGroupID = ref.read(selectedGroupNotifierProvider);
      var selectedTodoListID = ref.read(selectedTodoListNotifierProvider);

      // GROUPドキュメントの取得
      DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
          .collection('GROUP')
          .doc(selectedGroupID.value)
          .get();

      // TODOLISTドキュメントの取得
      DocumentSnapshot todoListSnapshot = await FirebaseFirestore.instance
          .collection('GROUP')
          .doc(selectedGroupID.value)
          .collection('TODOLIST')
          .doc(selectedTodoListID.value)
          .get();

      setState(() {
        groupData = groupSnapshot.data() as Map<String, dynamic>?;
        todoListData = todoListSnapshot.data() as Map<String, dynamic>?;
        selectedTodoListName = todoListData?['TODOLIST_NAME'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      return Center(child: Text('Error: $errorMessage'));
    } else if (groupData == null || todoListData == null) {
      return const Center(child: Text('No data available'));
    }

    var selectedGroupID = ref.read(selectedGroupNotifierProvider);
    var selectedTodoListID = ref.read(selectedTodoListNotifierProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        return Container(
          height: 216 + keyboardHeight,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 249, 245, 236),
            borderRadius: BorderRadius.all(
              Radius.circular(25.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TodoCardEdit(
                  onContentChanged: (newValue) {
                    setState(() {
                      content = newValue;
                    });
                  },
                  onCheckChanged: (newValue) {
                    setState(() {
                      isChecked = newValue;
                    });
                  },
                  onDeadlineChanged: (newValue) {
                    setState(() {
                      deadline = newValue;
                    });
                  },
                  onMemoChanged: (newValue) {
                    setState(() {
                      memo = newValue;
                    });
                  },
                  onManagerListChanged: (newValue) {
                    setState(() {
                      managerList = newValue;
                    });
                  },
                  todoContentFocusNode: _focusNode,
                  groupId: widget.groupId,
                  todoListId: widget.todoListId,
                  todoId: widget.todoId,
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      child: InkWell(
                        onTap: () {
                          print('aaaaaaa');
                        },
                        child: Image.asset('assets/images/SelectMark.png'),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () async {
                        String? selectedTodoListId = await showDialog<String>(
                          context: context,
                          builder: (_) {
                            return TodoListChoiceDialog(
                              groupId: selectedGroupID.value!,
                              initialTodoListId: selectedTodoListID.value!,
                            );
                          },
                        );

                        if (selectedTodoListId != null) {
                          var selectedTodoListDoc = await FirebaseFirestore
                              .instance
                              .collection('GROUP')
                              .doc(selectedGroupID.value!)
                              .collection('TODOLIST')
                              .doc(selectedTodoListId)
                              .get();
                          setState(() {
                            selectedTodoListName =
                                selectedTodoListDoc.data()?['TODOLIST_NAME'];
                          });
                        }
                      },
                      child: Text(
                        selectedTodoListName ?? 'No TODO List Selected',
                        style: GoogleFonts.notoSansJp(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      width: 128,
                      height: 40,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
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
                          TodoFields todoFields = TodoFields(
                            checkFlg: false,
                            content: content.isNotEmpty ? content : '',
                            memo: memo,
                            deadline: Timestamp.fromDate(deadline),
                            managerIdList: managerList,
                            // createDate: Timestamp.fromDate(DateTime.now()),
                            updateDate: Timestamp.fromDate(DateTime.now()),
                          );

                          // TODOLISTコレクションにドキュメント追加
                          await TodoDataService.updateTodoData(
                            selectedGroupID.value!,
                            selectedTodoListID.value!,
                            widget.todoId,
                            todoFields.toMap(),
                          );

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 15, 217, 15),
                          side: const BorderSide(color: Colors.black, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                          child: Text(
                            '決  定',
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: GoogleFonts.notoSansJp(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ).fontFamily,
                              shadows: const [
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
      },
    );
  }
}
