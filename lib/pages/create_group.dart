import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
import 'package:todo_share/pages/home.dart';
import 'package:todo_share/components/screen_pod.dart';
import 'package:todo_share/components/ad_mob.dart';
import 'package:todo_share/riverpod/selected_icon.dart';
import 'package:todo_share/widgets/admob_banner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_share/widgets/icon_setting_dialog.dart';
import 'package:todo_share/widgets/todolist_setting_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart' show rootBundle;

class CreateGroupPage extends ConsumerWidget {
  const CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var selectedIcon = ref.watch(selectedIconNotifierProvider);

    final TextEditingController _groupNameController = TextEditingController();
    // final TextEditingController _passController = TextEditingController();
    final FocusNode _groupNameFocusNode = FocusNode();

    final AdMob _adMob = AdMob();

    final screen = ScreenRef(context).watch(screenProvider);
    final designW = screen.designW(200);
    final designH = screen.designH(50);

    final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'グループ設定',
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
              height: 40.0,
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
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
                child: TextField(
                  controller: _groupNameController,
                  focusNode: _groupNameFocusNode,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '\u{2709}  sample@todolist.com',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 48,
            ),

            ///
            /// 決定ボタン
            ///
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
                  updateGroupListAndDateInFirestore(
                      context, uid!, _groupNameController.text);
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
      ),
    );
  }
}

Future<void> updateGroupListAndDateInFirestore(
    BuildContext context, String uid, String groupName) async {
  try {
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('USER').doc(uid);

    DocumentSnapshot userDoc = await userDocRef.get();
    if (!userDoc.exists) {
      throw Exception("User document does not exist!");
    }

    var uuid = Uuid();
    var groupIdFromUuid = uuid.v4();

    // GROUP_LISTの既存の配列を取得し、新しい要素を追加します
    List<String> groupList = List<String>.from(userDoc['GROUP_LIST'] ?? []);
    groupList.add(groupIdFromUuid);

    // 更新するフィールドと値のマップを作成します
    Map<String, dynamic> updateData = {
      'GROUP_LIST': groupList,
      'UPDATE_DATE': Timestamp.now(),
    };

    // ドキュメントを更新します
    await userDocRef.update(updateData);

    print("Group list and update date updated successfully!");

    await FirebaseFirestore.instance
        .collection('GROUP')
        .doc(groupIdFromUuid)
        .set({
      'GROUP_NAME': groupName,
      'ADMINISTRATOR': uid,
      'MEMBER_LIST': [uid],
      'CREATE_DATE': Timestamp.now(),
      'UPDATE_DATE': Timestamp.now(),
    });

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return HomePage();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 右から左
          final Offset begin = Offset(1.0, 0.0);
          // 左から右
          // final Offset begin = Offset(-1.0, 0.0);
          final Offset end = Offset.zero;
          final Animatable<Offset> tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));
          final Animation<Offset> offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  } catch (e) {
    print('Error updating group list and update date in Firestore: $e');
    throw e;
  }
}
