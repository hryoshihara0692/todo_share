import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:todo_share/riverpod/selected_todolist.dart';

class SideMenu extends ConsumerWidget {
  const SideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var selectedTodoList = ref.read(selectedTodoListNotifierProvider);

    return Drawer(
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
          child: Container(
            width: 272,
            color: Color.fromARGB(255, 249, 245, 236),

            ///
            /// ユーザー部分
            ///
            child: Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
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
                        SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          'あおやぎ',
                          style: TextStyle(
                            fontSize: 18,
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
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Container(
                            width: 32,
                            height: 32,
                            child: Image.asset('assets/images/UserSetting.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 16.0,
                  ),

                  ///
                  /// グループ選択部分
                  ///
                  Container(
                    height: 36.0,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: 32,
                            height: 32,
                            child: Image.asset('assets/images/SelectMark.png'),
                          ),
                        ),
                        Text(
                          '宮川探検隊',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: GoogleFonts.notoSansJp(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ).fontFamily,
                            // shadows: [
                            //   Shadow(
                            //     color: Color.fromARGB(255, 128, 128, 128),
                            //     blurRadius: 0,
                            //     offset: Offset(0, 2.5),
                            //   ),
                            // ],
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 32,
                            ),
                            Positioned(
                              top: 0,
                              left: 24,
                              child: Container(
                                width: 32,
                                height: 32,
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
                            ),
                            Positioned(
                              top: 0,
                              left: 48,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  // color: Colors.blue,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                      'assets/images/Icon_Women.jpeg',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    height: 36.0,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: 32,
                            height: 32,
                            // child: Image.asset('assets/images/SelectMark.png'),
                          ),
                        ),
                        Container(
                          width: 128,
                          height: 36,
                          child: Text(
                            '浦安三社祭（当代島班）',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: GoogleFonts.notoSansJp(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ).fontFamily,
                              height: 1.0,
                              // shadows: [
                              //   Shadow(
                              //     color: Color.fromARGB(255, 128, 128, 128),
                              //     blurRadius: 0,
                              //     offset: Offset(0, 2.5),
                              //   ),
                              // ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 32,
                            ),
                            Positioned(
                              top: 0,
                              left: 24,
                              child: Container(
                                width: 32,
                                height: 32,
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
                            ),
                            Positioned(
                              top: 0,
                              left: 48,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  // color: Colors.blue,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                      'assets/images/Icon_Women.jpeg',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    height: 36.0,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: 32,
                            height: 32,
                            // child: Image.asset('assets/images/SelectMark.png'),
                          ),
                        ),
                        Text(
                          '吉原家',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: GoogleFonts.notoSansJp(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ).fontFamily,
                            // shadows: [
                            //   Shadow(
                            //     color: Color.fromARGB(255, 128, 128, 128),
                            //     blurRadius: 0,
                            //     offset: Offset(0, 2.5),
                            //   ),
                            // ],
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 32,
                            ),
                            Positioned(
                              top: 0,
                              left: 24,
                              child: Container(
                                width: 32,
                                height: 32,
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
                            ),
                            Positioned(
                              top: 0,
                              left: 48,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  // color: Colors.blue,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                      'assets/images/Icon_Women.jpeg',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Container(),
                  ),

                  ///
                  /// サイドメニュー下
                  ///
                  SizedBox(height: 16.0,),
                  Container(
                    height: 32.0,
                    child: Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: 32,
                            height: 32,
                            child:
                                Image.asset('assets/images/CreateGroup.png'),
                          ),
                        ),
                        Text(
                          'グループを新しく作る',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: GoogleFonts.notoSansJp(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ).fontFamily,
                            // shadows: [
                            //   Shadow(
                            //     color: Color.fromARGB(255, 128, 128, 128),
                            //     blurRadius: 0,
                            //     offset: Offset(0, 2.5),
                            //   ),
                            // ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.0,),
                  Container(
                    height: 32.0,
                    child: Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: 32,
                            height: 32,
                            child:
                                Image.asset('assets/images/Settings.png'),
                          ),
                        ),
                        Text(
                          'その他（設定など）',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: GoogleFonts.notoSansJp(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ).fontFamily,
                            // shadows: [
                            //   Shadow(
                            //     color: Color.fromARGB(255, 128, 128, 128),
                            //     blurRadius: 0,
                            //     offset: Offset(0, 2.5),
                            //   ),
                            // ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 48.0,),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
