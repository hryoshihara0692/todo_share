import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/database/class/todo_fields.dart';
import 'package:todo_share/utils/modal_utils.dart';
import 'package:todo_share/widgets/deadline_setting_dialog.dart';
import 'package:todo_share/widgets/todo_delete_dialog.dart';

class TodoCardDisplay extends StatelessWidget {
  final TodoFields todoFields;

  const TodoCardDisplay({
    super.key,
    required this.todoFields,
  });

  @override
  Widget build(BuildContext context) {
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
                /// 1段目のテキスト（内容部分）
                ///
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48.0,
                        alignment: Alignment.centerLeft, // コンテナ内のテキストを中央左寄せにする
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // 余分なパディングを除去
                            alignment: Alignment.centerLeft, // テキストを中央左寄せにする
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
                          child: Container(
                            alignment:
                                Alignment.centerLeft, // 内側のコンテナ内のテキストを中央左寄せにする
                            constraints:
                                BoxConstraints.expand(), // コンテナのサイズにテキストを広げる
                            child: Text(
                              todoFields.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: GoogleFonts.notoSansJp().fontFamily,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                  ],
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
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return DeadlineSettingDialog();
                        //   },
                        // );
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
