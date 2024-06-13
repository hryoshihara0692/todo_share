import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/components/admob/ad_mob.dart';
import 'package:todo_share/components/admob/ad_mob_provider.dart';
import 'package:todo_share/database/group_data_service.dart';
import 'package:todo_share/database/user_data_service.dart';
import 'package:todo_share/riverpod/selected_todolist.dart';
import 'package:todo_share/widgets/responsive_text.dart';
import 'package:todo_share/widgets/todo_add_modal.dart';
import 'package:todo_share/widgets/admob_banner.dart';
import 'package:todo_share/widgets/side_menu.dart';
import 'package:todo_share/widgets/todo_collection.dart';
import 'package:todo_share/widgets/todolist_collection.dart';
import 'package:todo_share/utils/modal_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends ConsumerStatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  var uid;
  var userData;
  var groupID;
  var groupName = 'Loading...';
  List<Map<String, dynamic>> todoList = [];

  @override
  void initState() {
    super.initState();
    // userData = UserDataService.getUserData(uid!);
    fetchUserData();
  }

  void fetchUserData() async {
    uid = FirebaseAuth.instance.currentUser?.uid.toString();
    if (uid != null) {
      userData = await UserDataService.getUserData(uid);
      fetchGroupName();
      fetchTodoList();
    }
  }

  void fetchGroupName() async {
    if (userData != null && userData['PRIMARY_GROUP_ID'] != null) {
      setState(() {
        groupID = userData['PRIMARY_GROUP_ID'];
      });
      // var groupData = await FirebaseFirestore.instance
      //     .collection('GROUP')
      //     .doc(groupId)
      //     .get();
      var groupData = await GroupDataService.getGroupData(groupID);
      setState(() {
        groupName = groupData['GROUP_NAME'];
      });
    }
  }

  void fetchTodoList() async {
    if (groupID != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('GROUP')
          .doc(groupID)
          .collection('TODOLIST')
          .get();
      setState(() {
        todoList = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    }
  }

  @override
  // Widget build(BuildContext context, WidgetRef ref) {
  Widget build(BuildContext context) {
    // final adMobNotifier = ref.watch(adMobProvider);

    var selectedTodoListID = ref.read(selectedTodoListNotifierProvider);
    final _scaffoldKey = GlobalKey<ScaffoldState>();

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
                // print('aaaaaaa');
                _scaffoldKey.currentState?.openDrawer();
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
        title: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: TextButton(
                onPressed: () {
                  showGroupSettingModal(context);
                },
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: ResponsiveText(
                  text: groupName,
                  maxFontSize: 40,
                  minFontSize: 16,
                  maxLines: 1,
                ),
              ),
            );
          },
        ),
        // centerTitle: true,
        // title: Padding(
        //   padding: const EdgeInsets.only(bottom: 4.0),
        //   child: TextButton(
        //     onPressed: () {
        //       showGroupSettingModal(context);
        //     },
        //     style: ButtonStyle(
        //       foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        //     ),
        //     child: ResponsiveText(
        //       text: groupName,
        //       maxFontSize: 40,
        //       minFontSize: 20,
        //       maxLines: 2,
        //     ),
        //     // child: Text(
        //     //   // '吉原家',
        //     //   groupName,
        //     //   style: TextStyle(
        //     //     fontSize: 40,
        //     //     fontFamily: GoogleFonts.notoSansJp(
        //     //       textStyle: TextStyle(
        //     //         fontWeight: FontWeight.w700,
        //     //       ),
        //     //     ).fontFamily,
        //     //     shadows: [
        //     //       Shadow(
        //     //         color: Color.fromARGB(255, 195, 195, 195),
        //     //         blurRadius: 0,
        //     //         offset: Offset(0, 2.5),
        //     //       ),
        //     //     ],
        //     //   ),
        //     // ),
        //   ),
        // ),

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
      drawer: SideMenu(),

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
              child: groupID != null
                  ? TodoListCollection()
                  // : Center(child: Text('Loading...')),
                  : Container(),
            ),

            ///
            /// TODOの一覧
            ///
            if (selectedTodoListID.isNotEmpty) ...[
              Expanded(child: TodoCollection()),
              // TodoCollection(),
              // Expanded(
              //   child: Padding(
              //     padding: EdgeInsets.fromLTRB(24, 8, 20, 8),
              //     child: ListView.builder(
              //       itemCount: todoList.length,
              //       itemBuilder: (context, index) {
              //         return Padding(
              //           padding: const EdgeInsets.fromLTRB(0,0,4,12.0),
              //           // child: TodoCard(todo: todoList[index]),
              //           child: TodoCard(),
              //         );
              //       },
              //     ),
              //   ),
              // ),

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
                          showAddTodoModal(context, groupID);
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
                          showAddTodoModal(context, groupID);
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
            ] else ...[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '↑',
                      style: TextStyle(
                        fontSize: 48,
                        fontFamily: GoogleFonts.notoSansJp(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ).fontFamily,
                      ),
                    ),
                    Text(
                      '↑',
                      style: TextStyle(
                        fontSize: 48,
                        fontFamily: GoogleFonts.notoSansJp(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ).fontFamily,
                      ),
                    ),
                    Text(
                      '↑',
                      style: TextStyle(
                        fontSize: 48,
                        fontFamily: GoogleFonts.notoSansJp(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ).fontFamily,
                      ),
                    ),
                    Text(
                      '↑',
                      style: TextStyle(
                        fontSize: 48,
                        fontFamily: GoogleFonts.notoSansJp(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ).fontFamily,
                      ),
                    ),
                    Text(
                      'TODOリストを作成してください\u{1F4C4}',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: GoogleFonts.notoSansJp(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ).fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // adMobNotifier.getAdBanner(),
            AdMobBanner(),
          ],
        ),
      ),
    );
  }
}
