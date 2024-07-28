import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_share/riverpod/selected_group.dart';

class ManagerEditDialog extends ConsumerStatefulWidget {
  final List<String> managerList;
  final String groupId;
  final String todoListId;
  final String todoId;

  ManagerEditDialog({
    super.key,
    required this.managerList,
    required this.groupId,
    required this.todoListId,
    required this.todoId,
  });

  @override
  _ManagerSettingDialogState createState() => _ManagerSettingDialogState();
}

class _ManagerSettingDialogState extends ConsumerState<ManagerEditDialog> {
  List<String> userIds = [];
  List<bool> _checked = [];

  @override
  void initState() {
    super.initState();
    // 初期化時にユーザーIDを取得し、チェックボックスの状態を設定
    var selectedGroupId = ref.read(selectedGroupNotifierProvider);
    selectedGroupId.when(
      data: (groupId) {
        _fetchUserIds(groupId).then((ids) {
          setState(() {
            userIds = ids;
            _checked = List<bool>.filled(userIds.length, false);
            for (int i = 0; i < userIds.length; i++) {
              if (widget.managerList.contains(userIds[i])) {
                _checked[i] = true;
              }
            }
          });
        });
      },
      loading: () => print('Loading...'),
      error: (error, stack) => print('エラーが発生しました: $error'),
    );
  }

  Future<List<String>> _fetchUserIds(String groupId) async {
    List<String> userIds = [];
    try {
      var groupDoc = await FirebaseFirestore.instance
          .collection('GROUP')
          .doc(groupId)
          .get();
      if (groupDoc.exists) {
        var userSubCollection = await FirebaseFirestore.instance
            .collection('GROUP')
            .doc(groupId)
            .collection('USER')
            .get();
        for (var doc in userSubCollection.docs) {
          userIds.add(doc.id);
        }
      }
    } catch (e) {
      print("Error fetching user IDs: $e");
    }
    return userIds;
  }

  Future<Map<String, dynamic>> _fetchUserData(String userId) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('USER').doc(userId).get();
    return userDoc.data()!;
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
            /// リストビュー
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
              ),
              child: userIds.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: userIds.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<Map<String, dynamic>>(
                          future: _fetchUserData(userIds[index]),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return ListTile(
                                leading: Checkbox(
                                  value: _checked[index],
                                  onChanged: null,
                                ),
                                title: Text('Loading...'),
                              );
                            }
                            var userData = snapshot.data!;
                            return ListTile(
                              leading: Checkbox(
                                value: _checked[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _checked[index] = value!;
                                  });
                                },
                              ),
                              title: Text(userData['USER_NAME']),
                            );
                          },
                        );
                      },
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
                    onPressed: () async {
                      List<String> selectedUserIds = [];
                      for (int i = 0; i < userIds.length; i++) {
                        if (_checked[i]) {
                          selectedUserIds.add(userIds[i]);
                        }
                      }
                      await FirebaseFirestore.instance
                          .collection('GROUP')
                          .doc(widget.groupId)
                          .collection('TODOLIST')
                          .doc(widget.todoListId)
                          .collection('TODO')
                          .doc(widget.todoId)
                          .update({'MANAGER_ID_LIST': selectedUserIds});
                      Navigator.of(context).pop();
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
