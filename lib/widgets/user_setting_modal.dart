import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/riverpod/selected_todolist.dart';
import 'package:todo_share/widgets/member_invite_dialog.dart';
import 'package:todo_share/widgets/todo_card.dart';
import 'package:todo_share/widgets/todolist_setting_dialog.dart';

class UserSettingModal extends ConsumerWidget {
  const UserSettingModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedTodoList = ref.read(selectedTodoListNotifierProvider);

    return Container(
      height: 840,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 235, 235, 235),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ユーザー設定',
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
            SizedBox(
              height: 16.0,
            ),

            ///
            /// ユーザー画像
            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    // color: Colors.blue,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        'assets/images/Icon_Men.jpeg',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),

            ///
            /// なまえ
            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'なまえ',
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
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 0,
                    offset: Offset(2.5, 2.5),
                  )
                ],
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Text(
                      'あおやぎ',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: GoogleFonts.notoSansJp(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ).fontFamily,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image.asset(
                      'assets/images/SaveButton.jpg',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ],
              ),
            ),

            ///
            /// グループ一覧
            ///
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'グループ一覧',
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
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 0,
                    offset: Offset(2.5, 2.5),
                  )
                ],
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: ListView(
                children: [
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        '吉原家',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: GoogleFonts.notoSansJp(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ).fontFamily,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 32,
                          height: 32,
                          child: Image.asset('assets/images/Exit.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 24,
                          height: 24,
                          child: Image.asset('assets/images/humburger.png'),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        '宮川探検隊',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: GoogleFonts.notoSansJp(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ).fontFamily,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 32,
                          height: 32,
                          child: Image.asset('assets/images/Exit.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 24,
                          height: 24,
                          child: Image.asset('assets/images/humburger.png'),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        '浦安三社祭（当代島班）',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: GoogleFonts.notoSansJp(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ).fontFamily,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 32,
                          height: 32,
                          child: Image.asset('assets/images/Exit.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 24,
                          height: 24,
                          child: Image.asset('assets/images/humburger.png'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12.0,
            ),

            ///
            /// グループ作成ボタン
            ///
            Container(
              width: 240,
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
                  showDialog<void>(
                    context: context,
                    builder: (_) {
                      return TodoListSettingDialog();
                    },
                  );
                },
                // ボタンの色と枠線を設定する
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 122, 195, 220),
                  side: BorderSide(color: Colors.black, width: 2),
                ),
                child: Padding(
                  // 指マーク用として右にスペースを開ける＋テキスト下がるので4上げる
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                  child: Text(
                    'グループ作成',
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
      ),
    );
  }
}
