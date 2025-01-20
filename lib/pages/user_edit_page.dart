import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_share/pages/home.dart';
import 'package:todo_share/widgets/group_leave_dialog.dart';

class UserEditPage extends StatefulWidget {
  const UserEditPage({super.key});

  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _nameController = TextEditingController();
  Map<String, String> groupList = {};

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userDoc = await firestore.collection('USER').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data();
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<List<String>> getUserGroupIds(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final groupSnapshot =
          await firestore.collection('USER').doc(uid).collection('GROUP').get();
      return groupSnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error getting user group IDs: $e');
      return [];
    }
  }

  Future<Map<String, String>> getGroupsByIds(List<String> groupIds) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final groupQuery = await firestore
          .collection('GROUP')
          .where(FieldPath.documentId, whereIn: groupIds)
          .get();
      return {
        for (var doc in groupQuery.docs) doc.id: doc['GROUP_NAME'] as String,
      };
    } catch (e) {
      print('Error getting groups by IDs: $e');
      return {};
    }
  }

  Future<void> _fetchUserData() async {
    final data = await getUserData(uid);
    setState(() {
      userData = data;
      if (userData != null) {
        _nameController.text = userData!['USER_NAME'] ?? '';
      }
      isLoading = false;
    });
  }

  Future<void> _fetchUserGroups() async {
    final groupIds = await getUserGroupIds(uid);
    final groups = await getGroupsByIds(groupIds);
    setState(() {
      groupList = groups;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchUserGroups();
  }

  Future<void> _updateUserName() async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('USER').doc(uid).update({
        'USER_NAME': _nameController.text,
      });
      // スナックバーを表示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("ユーザー名が更新されました！"),
          backgroundColor: Colors.blue, // エラーを強調する赤色
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('Error updating user name: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('名前の更新に失敗しました')),
      );
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final keys = groupList.keys.toList();
      final item = keys.removeAt(oldIndex);
      keys.insert(newIndex, item);
      groupList = {
        for (var key in keys) key: groupList[key]!,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // return Center(child: CircularProgressIndicator());
      return Center(
        child: Image.asset('assets/images/tmp.gif'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64.0,
        backgroundColor: Color.fromARGB(255, 235, 235, 235),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.of(context).pop();
            // showDialog<void>(
            //   context: context,
            //   builder: (_) {
            //     return CreateAccountCancelDialog();
            //   },
            // );
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return HomePage();
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  // 右から左
                  // final Offset begin = Offset(1.0, 0.0);
                  // 左から右
                  final Offset begin = Offset(-1.0, 0.0);
                  final Offset end = Offset.zero;
                  final Animatable<Offset> tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: Curves.easeInOut));
                  final Animation<Offset> offsetAnimation =
                      animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
        ),
        centerTitle: true,
        title: Text(
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
      ),
      body: Container(
        height: 840,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 235, 235, 235),
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(25.0),
          //   topRight: Radius.circular(25.0),
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/Icon_Men.jpeg'),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
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
              SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                height: 56,
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
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '名前を入力してください',
                          ),
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
                    ),
                    IconButton(
                      icon: Icon(Icons.save),
                      onPressed: _updateUserName,
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
                height: 240,
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
                child: ReorderableListView(
                  onReorder: _onReorder,
                  children: List.generate(groupList.length, (index) {
                    final groupId = groupList.keys.elementAt(index);
                    final groupName = groupList[groupId]!;
                    return ListTile(
                      key: ValueKey(groupId),
                      title: Row(
                        children: [
                          Text(
                            groupName,
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
                          GestureDetector(
                            onTap: () {
                              // print('groupId: $groupId');
                              showDialog<void>(
                                context: context,
                                builder: (_) {
                                  return GroupLeaveDialog(
                                    groupId: groupId,
                                    groupName: groupName,
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                width: 32,
                                height: 32,
                                child: Image.asset('assets/images/Exit.png'),
                              ),
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
                    );
                  }),
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
                    // showDialog<void>(
                    //   context: context,
                    //   builder: (_) {
                    //     return TodoListSettingDialog();
                    //   },
                    // );
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'グループを作成する',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: GoogleFonts.notoSansJp(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ).fontFamily,
                          ),
                        ),
                        // Expanded(
                        //   child: Container(),
                        // ),
                        // Container(
                        //   width: 32,
                        //   height: 32,
                        //   child: Image.asset('assets/images/Tap.png'),
                        // ),
                      ],
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
