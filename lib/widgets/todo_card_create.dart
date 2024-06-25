import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/utils/modal_utils.dart';
import 'package:todo_share/widgets/deadline_setting_dialog.dart';
import 'package:todo_share/widgets/todo_delete_dialog.dart';

class TodoCardCreate extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const TodoCardCreate({
    super.key,
    required this.onChanged,
  });

  @override
  _TodoCardCreateState createState() => _TodoCardCreateState();
}

class _TodoCardCreateState extends State<TodoCardCreate> {
  final TextEditingController _todoContentController = TextEditingController();
  final FocusNode _todoContentFocusNode = FocusNode();

  @override
  void dispose() {
    _todoContentController.dispose();
    _todoContentFocusNode.dispose(); // Dispose the focus node
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Post-frame callback to request focus after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _todoContentFocusNode.requestFocus();
    });

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
              print('Tapおっけー');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                'assets/images/check_button.png',
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
                  focusNode: _todoContentFocusNode,
                  onChanged: (newValue) {
                    // Call setState to notify the parent widget about the change
                    setState(() {
                      widget.onChanged(newValue);
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '\u{2709}  sample@todolist.com',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    /// 2段目のメモボタン
                    Container(
                      width: 32.0,
                      height: 32.0,
                      child: Image.asset('assets/images/Memo.png'),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),

                    ///
                    /// 期限ボタン
                    ///
                    GestureDetector(
                      onTap: () {
                        // showDeadlineSettingModal(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeadlineSettingDialog();
                          },
                        );
                      },
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        child: Image.asset('assets/images/Deadline.jpeg'),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      height: 32.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 32.0,
                            height: 32.0,
                            child: Image.asset(
                                'assets/images/add_user_button.png'),
                          ),
                        ],
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
