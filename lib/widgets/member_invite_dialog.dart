import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/riverpod/selected_todolist.dart';
import 'package:todo_share/widgets/todo_card.dart';

class MemberInviteDialog extends ConsumerWidget {
  const MemberInviteDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var selectedTodoList = ref.read(selectedTodoListNotifierProvider);

    return Dialog(
      insetPadding: EdgeInsets.all(0.0),
      child: Container(
        width: 392,
        height: 432,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 235, 235, 235),
          borderRadius: const BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32.0,
                    height: 32.0,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    'メンバー招待',
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
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    width: 32.0,
                    height: 32.0,
                    child: Image.asset('assets/images/Close.png'),
                  ),
                ],
              ),
              SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'QRコードを読み込んでもらう',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: GoogleFonts.notoSansJp(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ).fontFamily,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                width: 160,
                height: 160,
                child: Image.asset('assets/images/QR.png'),
              ),
              SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '招待用URLを送信する',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: GoogleFonts.notoSansJp(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ).fontFamily,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
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
                    backgroundColor: Color.fromARGB(255, 116, 199, 156),
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                  child: Padding(
                    // 指マーク用として右にスペースを開ける＋テキスト下がるので4上げる
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                    child: Text(
                      '送  信',
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
        ),
      ),
    );
  }
}
