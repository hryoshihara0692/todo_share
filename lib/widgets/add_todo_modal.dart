import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/riverpod/selected_todolist.dart';
import 'package:todo_share/widgets/todo_card.dart';

class AddTodoModal extends ConsumerWidget {
  const AddTodoModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedTodoList = ref.read(selectedTodoListNotifierProvider);

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
            TodoCard(),
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
                  selectedTodoList,
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
            ),
          ],
        ),
      ),
    );
  }
}
