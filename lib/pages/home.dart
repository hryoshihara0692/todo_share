import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/widgets/admob_banner.dart';

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

  var todoListCollection = [
    '買い物リスト',
    'やることリスト',
    '引っ越し',
    'TODOリスト',
    'お返しリスト',
    '電話帳',
    'おいしかったご飯'
  ];
  var selectedTodoList = '買い物リスト';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 64.0,
        backgroundColor: Color.fromARGB(255, 249, 245, 236),
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
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
      body: Container(
        color: Color.fromARGB(255, 249, 245, 236),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: todoListCollection.length,
                  itemBuilder: (context, index) {
                    final todo = todoListCollection[index];
                    final isSelected = todo == selectedTodoList;

                    return Container(
                      margin: EdgeInsets.fromLTRB(2.0, 4, 2, 4),
                      child: isSelected
                          ? ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                foregroundColor: Colors.white,
                                backgroundColor: Color.fromARGB(255, 15, 9, 64),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                todo,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedTodoList = todo;
                                });
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                foregroundColor: Color.fromARGB(255, 15, 9, 64),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                todo,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 143, 158, 1),
                            Color.fromRGBO(255, 188, 143, 1),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 0,
                            offset: Offset(0, 5),
                          )
                        ]),
                    child: ElevatedButton(
                      onPressed: () {
                        print('Tapおっけー');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 69, 206, 237),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        side: BorderSide(color: Colors.black, width: 2),
                        elevation: 100,
                        shadowColor: Colors.black,
                      ),
                      child: Padding(
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
                  Positioned(
                    right: -30,
                    top: 2,
                    child: InkWell(
                      onTap: () {
                        print('Tapおっけー');
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
