import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/riverpod/selected_icon.dart';

class IconSettingDialog extends ConsumerWidget {
  const IconSettingDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedIcon = ref.watch(selectedIconNotifierProvider);

    List<String> images = [
      'assets/images/Exit.png',
      'assets/images/mail.png',
      'assets/images/Memo.png'
    ];

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
                    'アイコン設定',
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
              DefaultTabController(
                length: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            '画像アップロード',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: GoogleFonts.notoSansJp(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ).fontFamily,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'アイコンを選ぶ',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: GoogleFonts.notoSansJp(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ).fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 290,
                      child: TabBarView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Container(
                                  width: 96,
                                  height: 96,
                                  child:
                                      Image.asset('assets/images/Upload.png'),
                                ),
                              ),
                              Center(
                                child: Text(
                                  '画像を選択する',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: GoogleFonts.notoSansJp(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ).fontFamily,
                                    // ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 8.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 224,
                                    child: GridView.builder(
                                      padding:
                                          EdgeInsets.all(8.0), // 画像間に隙間を開ける
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3, // 3列にする
                                        childAspectRatio: 1.0,
                                        crossAxisSpacing: 8.0, // 横方向の間隔
                                        mainAxisSpacing: 8.0, // 縦方向の間隔
                                      ),
                                      itemCount: images.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            var notifier = ref.read(
                                                selectedIconNotifierProvider
                                                    .notifier);
                                            notifier.update(images[index]);
                                          },
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              ClipOval(
                                                child: Image.asset(
                                                  images[index],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              if (selectedIcon == images[index])
                                                Container(
                                                  color: Colors.black38,
                                                  child: Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 40.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
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
                                        Navigator.of(context).pop('confirmed');
                                      },
                                      // ボタンの色と枠線を設定する
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            Color.fromARGB(255, 116, 199, 156),
                                        side: BorderSide(
                                            color: Colors.black, width: 2),
                                      ),
                                      child: Padding(
                                        // 指マーク用として右にスペースを開ける＋テキスト下がるので4上げる
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 4),
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
                                                color: Color.fromARGB(
                                                    255, 118, 168, 141),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
