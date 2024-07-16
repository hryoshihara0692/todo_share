import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MemoSettingDialog extends StatefulWidget {
  @override
  _MemoSettingDialogState createState() => _MemoSettingDialogState();
}

class _MemoSettingDialogState extends State<MemoSettingDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(0.0),
      child: Container(
        width: 392,
        height: 608,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 249, 245, 236),
          borderRadius: const BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'メモ',
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
                ],
              ),
            ),
            SizedBox(
              height: 8.0,
            ),

            ///
            /// メモ用テキストフィールド
            ///
            Container(
              width: 360,
              height: 408,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 0,
                    offset: Offset(6, 6),
                  )
                ],
                border: Border.all(color: Colors.black, width: 1.0),
                // borderRadius: const BorderRadius.all(
                //   Radius.circular(15.0),
                // ),
              ),
              child: TextField(
                controller: _controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Enter your note here...',
                  // border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),

            SizedBox(
              height: 24.0,
            ),

            ///
            /// 戻る決定ボタン
            ///
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
                      Navigator.of(context).pop();
                    },
                    // ボタンの色と枠線を設定する
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 255, 102, 112),
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
                      Navigator.of(context).pop(_controller.text);
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
          ],
        ),
      ),
    );
  }
}