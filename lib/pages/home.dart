import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/widgets/add_todo_modal.dart';
import 'package:todo_share/widgets/admob_banner.dart';
import 'package:todo_share/widgets/todo_card.dart';
import 'package:todo_share/widgets/todolist_collection.dart';
import 'package:todo_share/utils/modal_utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 64.0,
        backgroundColor: Color.fromARGB(255, 249, 245, 236),

        ///
        /// ハンバーガーメニュー
        ///
        leading: Transform.translate(
          offset: const Offset(20, 0),
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {
                print('aaaaaaa');
              },
              splashColor: const Color(0xff000000).withAlpha(30),
              child: Image.asset('assets/images/humburger.png'),
            ),
          ),
        ),

        ///
        /// グループ名
        ///
        centerTitle: true,
        title: Text(
          '吉原家',
          style: TextStyle(
            fontSize: 40,
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

        ///
        /// 通知ボタン
        ///
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                TextButton(
                  child: Text(
                    '\u{1F514}',
                    style: TextStyle(fontSize: 40),
                  ),
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(0),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 4,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '99',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),

      ///
      /// サイドメニュー
      ///
      drawer: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),

      ///
      /// ボディ
      ///
      body: Container(
        color: Color.fromARGB(255, 249, 245, 236),
        child: Column(
          children: [
            ///
            /// TODOリスト一覧
            ///
            Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: TodoListCollection(),
            ),

            ///
            /// TODOの一覧
            ///
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 8, 20, 8),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Column(
                        children: [
                          TodoCard(),
                          SizedBox(
                            height: 12.0,
                          ),
                          TodoCard(),
                          SizedBox(
                            height: 12.0,
                          ),
                          TodoCard(),
                          SizedBox(
                            height: 12.0,
                          ),
                          TodoCard(),
                          SizedBox(
                            height: 12.0,
                          ),
                          TodoCard(),
                          SizedBox(
                            height: 12.0,
                          ),
                          TodoCard(),
                          SizedBox(
                            height: 12.0,
                          ),
                          TodoCard(),
                          SizedBox(
                            height: 12.0,
                          ),
                          TodoCard(),
                          SizedBox(
                            height: 12.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ///
            /// TODO追加ボタン
            ///
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ///
                  /// ボタン本体
                  ///
                  Container(
                    width: 200,
                    height: 50,
                    // ボタンの形と影を設定する
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 0,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // print('Tapおっけー');
                        showModal(context);
                      },
                      // ボタンの色と枠線を設定する
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 69, 206, 237),
                        side: BorderSide(color: Colors.black, width: 2),
                      ),
                      child: Padding(
                        // 指マーク用として右にスペースを開ける＋テキスト下がるので4上げる
                        padding: EdgeInsets.fromLTRB(0, 0, 24, 4),
                        child: Text(
                          'TODOを追加',
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
                  // TODO追加ボタン用の指マーク
                  Positioned(
                    right: -30,
                    top: 2,
                    child: InkWell(
                      onTap: () {
                        // print('Tapおっけー');
                        showModal(context);
                      },
                      child: Image.asset(
                        'assets/images/add_todo_button.png',
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AdMobBanner(),
          ],
        ),
      ),
    );
  }
}