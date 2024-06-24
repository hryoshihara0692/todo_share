import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/components/admob/ad_mob.dart';
import 'package:todo_share/components/admob/ad_mob_provider.dart';
import 'package:todo_share/database/group_data_service.dart';
import 'package:todo_share/database/singleton/uid.dart';
import 'package:todo_share/database/user_data_service.dart';
import 'package:todo_share/riverpod/selected_group.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // グループIDとTODOリストIDをRiverpodのプロバイダから取得
    final groupIdAsyncValue = ref.watch(selectedGroupNotifierProvider);
    final todoListIdAsyncValue = ref.watch(selectedTodoListNotifierProvider);

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
        title: groupIdAsyncValue.when(
          data: (groupId) => FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('GROUP')
                .doc(groupId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              } else if (snapshot.hasError) {
                return Text('Error');
              } else if (!snapshot.hasData) {
                return Text('No Data');
              } else {
                var groupData = snapshot.data!.data() as Map<String, dynamic>;
                return LayoutBuilder(
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
                          text: groupData['GROUP_NAME'],
                          maxFontSize: 40,
                          minFontSize: 16,
                          maxLines: 1,
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
          loading: () => Text('Loading...'),
          error: (e, stack) => Text('Error'),
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
              child: TodoListCollection(),
            ),

            ///
            /// TODOの一覧
            ///
            Expanded(child: TodoCollection()),

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
                        showTodoAddModal(context, groupIdAsyncValue.value!);
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
                        showTodoAddModal(context, groupIdAsyncValue.value!);
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
