import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/utils/modal_utils.dart';
import 'package:todo_share/widgets/deadline_setting_dialog.dart';
import 'package:todo_share/widgets/manager_setting_dialog.dart';
import 'package:todo_share/widgets/memo_setting_dialog.dart';
import 'package:todo_share/widgets/todo_delete_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoCardEdit extends StatefulWidget {
  final String groupId;
  final String todoListId;
  final String todoId;
  final ValueChanged<String> onContentChanged;
  final ValueChanged<bool> onCheckChanged;
  final ValueChanged<DateTime> onDeadlineChanged;
  final ValueChanged<String> onMemoChanged;
  final ValueChanged<List<String>> onManagerListChanged;
  final FocusNode todoContentFocusNode;

  const TodoCardEdit({
    Key? key,
    required this.groupId,
    required this.todoListId,
    required this.todoId,
    required this.onContentChanged,
    required this.onCheckChanged,
    required this.onDeadlineChanged,
    required this.onMemoChanged,
    required this.onManagerListChanged,
    required this.todoContentFocusNode,
  }) : super(key: key);

  @override
  _TodoCardEditState createState() => _TodoCardEditState();
}

class _TodoCardEditState extends State<TodoCardEdit> {
  late TextEditingController _todoContentController;
  // final FocusNode _todoContentFocusNode = FocusNode();

  bool isChecked = false;
  DateTime deadline = DateTime(2000, 1, 1, 00, 00, 00, 000);
  String memoText = '';
  List<String> _managerList = [];

  @override
  void initState() {
    super.initState();
    _todoContentController = TextEditingController();

    // Firestoreからデータを取得して初期値を設定
    _fetchTodoData();
  }

  Future<void> _fetchTodoData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('GROUP')
          .doc(widget.groupId)
          .collection('TODOLIST')
          .doc(widget.todoListId)
          .collection('TODO')
          .doc(widget.todoId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _todoContentController.text = data['CONTENT'] ?? '';
          isChecked = data['CHECK_FLG'] ?? false;
          deadline = (data['DEADLINE'] as Timestamp?)?.toDate() ?? deadline;
          memoText = data['MEMO'] ?? '';
          _managerList = List<String>.from(data['MANAGER_ID_LIST'] ?? []);
        });
      } else {
        print('指定したTODOは存在しません');
      }
    } catch (e) {
      print('Firestoreデータ取得エラー: $e');
    }
  }

  @override
  void dispose() {
    _todoContentController.dispose();
    // _todoContentFocusNode.dispose(); // フォーカスノードの破棄
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Post-frame callback to request focus after build
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _todoContentFocusNode.requestFocus();
    // });

    return Container(
      width: double.infinity,
      height: 104,
      // TODOの形と影を設定する
      decoration: BoxDecoration(
        color: Colors.white,
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
            onTap: () {
              setState(() {
                isChecked = !isChecked;
                widget.onCheckChanged(isChecked);
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                isChecked
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
                /// 1段目のテキストフィールド
                ///
                TextField(
                  controller: _todoContentController,
                  focusNode: widget.todoContentFocusNode,
                  onChanged: (newValue) {
                    widget.onContentChanged(newValue);
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '\u{1F4DD} TODOを入力してください',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    ///
                    /// 2段目のメモボタン
                    ///
                    GestureDetector(
                      onTap: () async {
                        final memo = await showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return MemoSettingDialog(initialMemo: memoText);
                          },
                        );

                        if (memo != null) {
                          // 選択された日時を受け取る処理
                          print('選択された日時: $memo');
                          setState(() {
                            memoText = memo;
                          });
                          widget.onMemoChanged(memoText);
                        }
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
                      onTap: () async {
                        final selectedDateTime = await showDialog<DateTime>(
                          context: context,
                          builder: (BuildContext context) {
                            return DeadlineSettingDialog(initialDeadline: deadline);
                          },
                        );

                        if (selectedDateTime != null) {
                          // 選択された日時を受け取る処理
                          print('選択された日時: $selectedDateTime');
                          setState(() {
                            deadline = selectedDateTime;
                          });
                          widget.onDeadlineChanged(deadline);
                        }
                      },
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        child: Image.asset('assets/images/Deadline.png'),
                      ),
                    ),

                    SizedBox(
                      width: 8.0,
                    ),

                    ///
                    /// 期限テキスト表示
                    ///
                    if (deadline.year != 2000 &&
                        deadline.month != 1 &&
                        deadline.day != 1)
                      Text(
                        deadline.toString().substring(0, 16),
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

                    ///
                    /// 2段目の担当者ボタン
                    ///
                    GestureDetector(
                      onTap: () async {
                        final managerList = await showDialog<List<String>>(
                          context: context,
                          builder: (BuildContext context) {
                            return ManagerSettingDialog(initialManagerList: _managerList);
                          },
                        );

                        if (managerList != null) {
                          // 選択された日時を受け取る処理
                          print('選択された担当者リスト: $managerList');
                          setState(() {
                            _managerList = managerList;
                          });
                          widget.onManagerListChanged(_managerList);
                        }
                      },
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        child: Image.asset('assets/images/add_user_button.png'),
                      ),
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