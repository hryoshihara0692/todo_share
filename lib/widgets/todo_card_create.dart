import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/utils/modal_utils.dart';
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
      height: 80,
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
          InkWell(
            onTap: () {
              print('Tapおっけー');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                'assets/images/check_button.png',
                width: 48,
                height: 48,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0),
                ),
                onPressed: () {
                  // showAddTodoModal(context);
                },
                onLongPress: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) {
                      return DeleteDialog();
                    },
                  );
                },
                child: TextField(
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
              ),
            ),
          ),
          Container(
            width: 80.0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 32.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 32.0,
                          height: 32.0,
                          child:
                              Image.asset('assets/images/add_user_button.png'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Container(
                    height: 24.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 24.0,
                          height: 24.0,
                          child: Image.asset('assets/images/Deadline.jpeg'),
                        ),
                        Container(
                          width: 24.0,
                          height: 24.0,
                          child: Image.asset('assets/images/Memo.png'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
