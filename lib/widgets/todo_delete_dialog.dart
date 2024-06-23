import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/riverpod/selected_todolist.dart';
import 'package:todo_share/widgets/todo_card_display.dart';

class DeleteDialog extends ConsumerWidget {
  const DeleteDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var selectedTodoList = ref.read(selectedTodoListNotifierProvider);

    return Dialog(
      insetPadding: EdgeInsets.all(0.0),
      child: Container(
        width: 392,
        height: 254,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 249, 245, 236),
          borderRadius: const BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 24.0,
            ),
            Text(
              '削除してよいですか？',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 24.0, 12.0, 16.0),
              ///
              /// 削除するデータの取得〜表示処理の追加
              ///
              // child: TodoCardDisplay(todoData: todoData,),
            ),
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
                      backgroundColor: Color.fromARGB(255, 255, 71, 46),
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
                      // print('Tapおっけー');
                      // _showModal(context);
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
            )
          ],
        ),
      ),
    );
  }
}
