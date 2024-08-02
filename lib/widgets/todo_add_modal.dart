import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_share/database/class/notification_fields.dart';
import 'package:todo_share/database/class/todo_fields.dart';
import 'package:todo_share/database/todo_data_service.dart';
import 'package:todo_share/riverpod/selected_group.dart';
import 'package:todo_share/riverpod/selected_todolist.dart';
import 'package:todo_share/widgets/todo_card_create.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_share/widgets/todolist_choise_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoAddModal extends ConsumerStatefulWidget {
  const TodoAddModal({
    super.key,
  });

  @override
  _AddTodoModalState createState() => _AddTodoModalState();
}

class _AddTodoModalState extends ConsumerState<TodoAddModal> {
  String content = '';
  bool isChecked = false;
  DateTime deadline = DateTime(2000, 1, 1, 00, 00, 00, 000);
  String memo = '';
  List<String> managerList = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    var selectedGroupID = ref.watch(selectedGroupNotifierProvider);
    var selectedTodoListID = ref.watch(selectedTodoListNotifierProvider);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('GROUP')
          .doc(selectedGroupID.value)
          .snapshots(),
      builder: (context, groupSnapshot) {
        if (groupSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (groupSnapshot.hasError) {
          return Center(child: Text('Error: ${groupSnapshot.error}'));
        } else if (!groupSnapshot.hasData) {
          return Center(child: Text('No data available'));
        }

        var groupData = groupSnapshot.data!.data() as Map<String, dynamic>;

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('GROUP')
              .doc(selectedGroupID.value)
              .collection('TODOLIST')
              .doc(selectedTodoListID.value)
              .snapshots(),
          builder: (context, todoListSnapshot) {
            if (todoListSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (todoListSnapshot.hasError) {
              return Center(child: Text('Error: ${todoListSnapshot.error}'));
            } else if (!todoListSnapshot.hasData) {
              return Center(child: Text('No data available'));
            }

            var todoListData =
                todoListSnapshot.data!.data() as Map<String, dynamic>;

            return Container(
              height: 508,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 249, 245, 236),
                borderRadius: const BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TodoCardCreate(
                      onContentChanged: (newValue) {
                        setState(() {
                          content = newValue;
                        });
                      },
                      onCheckChanged: (newValue) {
                        setState(() {
                          isChecked = newValue;
                        });
                      },
                      onDeadlineChanged: (newValue) {
                        setState(() {
                          deadline = newValue;
                        });
                      },
                      onMemoChanged: (newValue) {
                        setState(() {
                          memo = newValue;
                        });
                      },
                      onManagerListChanged: (newValue) {
                        setState(() {
                          managerList = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          child: InkWell(
                            onTap: () {
                              print('aaaaaaa');
                            },
                            child: Image.asset('assets/images/SelectMark.png'),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        GestureDetector(
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              builder: (_) {
                                return TodoListChoiceDialog(
                                  groupId: selectedGroupID.value!,
                                  initialTodoListId: selectedTodoListID.value!,
                                );
                              },
                            );
                          },
                          child: Text(
                            todoListData['TODOLIST_NAME'],
                            style: GoogleFonts.notoSansJp(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                        Container(
                          width: 128,
                          height: 40,
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
                              TodoFields todoFields = TodoFields(
                                checkFlg: false,
                                content: content.isNotEmpty ? content : '',
                                memo: memo,
                                deadline: Timestamp.fromDate(deadline),
                                managerIdList: managerList,
                                createDate: Timestamp.fromDate(DateTime.now()),
                                updateDate: Timestamp.fromDate(DateTime.now()),
                              );

                              // TODOLISTコレクションにドキュメント追加
                              await TodoDataService.createTodoData(
                                  selectedGroupID.value!,
                                  selectedTodoListID.value!,
                                  todoFields.toMap());

                              // NotificationFields notificationFields =
                              //     NotificationFields(
                              //   userId: uid,
                              //   userName: 'userName',
                              //   groupId: 'test_group_id',
                              //   groupName: 'test_group_name',
                              //   todolistId: 'test_todolist_id',
                              //   todolistName: 'test_todolist_name',
                              //   todoId: 'test_todo_id',
                              //   content: 'test_content',
                              //   beforeContent: 'test_before_content',
                              //   notificationType: 'CREATE',
                              //   notificationDate:
                              //       Timestamp.fromDate(DateTime.now()),
                              //   createDate: Timestamp.fromDate(DateTime.now()),
                              //   updateDate: Timestamp.fromDate(DateTime.now()),
                              // );

                              // var uuid = Uuid();
                              // var notificationID = uuid.v4();
                              // await FirebaseFirestore.instance
                              //     .collection('USER')
                              //     .doc(uid)
                              //     .collection('NOTIFICATION')
                              //     .doc(notificationID)
                              //     .set(notificationFields.toMap());

                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromARGB(255, 15, 217, 15),
                              side: BorderSide(color: Colors.black, width: 2),
                            ),
                            child: Padding(
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
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:todo_share/database/class/todo_fields.dart';
// import 'package:todo_share/database/todo_data_service.dart';
// import 'package:todo_share/riverpod/selected_group.dart';
// import 'package:todo_share/riverpod/selected_todolist.dart';
// import 'package:todo_share/widgets/todo_card_create.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:todo_share/widgets/todolist_choise_dialog.dart';
// import 'package:rxdart/rxdart.dart'; // Add this import

// class TodoAddModal extends ConsumerStatefulWidget {
//   const TodoAddModal({
//     super.key,
//   });

//   @override
//   _AddTodoModalState createState() => _AddTodoModalState();
// }

// class _AddTodoModalState extends ConsumerState<TodoAddModal> {
//   String content = '';
//   bool isChecked = false;
//   DateTime deadline = DateTime(2000, 1, 1, 00, 00, 00, 000);
//   String memo = '';
//   List<String> managerList = [];

//   Stream<Map<String, dynamic>> _fetchFirestoreData() {
//     var selectedGroupID = ref.read(selectedGroupNotifierProvider);
//     var selectedTodoListID = ref.read(selectedTodoListNotifierProvider);

//     // Listen to the GROUP document
//     Stream<DocumentSnapshot> groupStream = FirebaseFirestore.instance
//         .collection('GROUP')
//         .doc(selectedGroupID.value)
//         .snapshots();

//     // Listen to the TODOLIST document
//     Stream<DocumentSnapshot> todoListStream = FirebaseFirestore.instance
//         .collection('GROUP')
//         .doc(selectedGroupID.value)
//         .collection('TODOLIST')
//         .doc(selectedTodoListID.value)
//         .snapshots();

//     return groupStream.combineLatest(todoListStream, (groupSnap, todoListSnap) {
//       return {
//         'groupData': groupSnap.data(),
//         'todoListData': todoListSnap.data(),
//       };
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<Map<String, dynamic>>(
//         stream: _fetchFirestoreData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData) {
//             return Center(child: Text('No data available'));
//           }

//           var groupData = snapshot.data!['groupData'];
//           var todoListData = snapshot.data!['todoListData'];
//           var selectedGroupID = ref.read(selectedGroupNotifierProvider);
//           var selectedTodoListID = ref.read(selectedTodoListNotifierProvider);

//           return Container(
//             height: 508,
//             decoration: BoxDecoration(
//               color: Color.fromARGB(255, 249, 245, 236),
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(25.0),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TodoCardCreate(
//                     onContentChanged: (newValue) {
//                       setState(
//                         () {
//                           content = newValue;
//                         },
//                       );
//                     },
//                     onCheckChanged: (newValue) {
//                       setState(
//                         () {
//                           isChecked = newValue;
//                         },
//                       );
//                     },
//                     onDeadlineChanged: (newValue) {
//                       setState(
//                         () {
//                           deadline = newValue;
//                         },
//                       );
//                     },
//                     onMemoChanged: (newValue) {
//                       setState(
//                         () {
//                           memo = newValue;
//                         },
//                       );
//                     },
//                     onManagerListChanged: (newValue) {
//                       setState(() {
//                         managerList = newValue;
//                       });
//                     },
//                   ),
//                   SizedBox(
//                     height: 16.0,
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         width: 32,
//                         height: 32,
//                         // padding: const EdgeInsets.all(8.0),
//                         child: InkWell(
//                           // borderRadius: BorderRadius.circular(5),
//                           onTap: () {
//                             print('aaaaaaa');
//                           },
//                           // splashColor: const Color(0xff000000).withAlpha(30),
//                           child: Image.asset('assets/images/SelectMark.png'),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 8.0,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           showDialog<void>(
//                           context: context,
//                           builder: (_) {
//                             return TodoListChoiceDialog(
//                               groupId: selectedGroupID.value!,
//                               initialTodoListId: selectedTodoListID.value!,
//                             );
//                           },
//                         );
//                         },
//                         child: Text(
//                           // selectedTodoListID,
//                           // '買い物リスト',
//                           todoListData['TODOLIST_NAME'],
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontFamily: GoogleFonts.notoSansJp(
//                               textStyle: TextStyle(
//                                 fontWeight: FontWeight.normal,
//                               ),
//                             ).fontFamily,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(),
//                       ),
//                       Container(
//                         width: 128,
//                         height: 40,
//                         // ボタンの形と影を設定する
//                         decoration: BoxDecoration(
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(25.0),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black,
//                               blurRadius: 0,
//                               offset: Offset(0, 3),
//                             )
//                           ],
//                         ),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             // print('Tapおっけー');
//                             TodoFields todoFields = TodoFields(
//                               checkFlg: false,
//                               content: content.isNotEmpty ? content : '',
//                               memo: memo,
//                               deadline: Timestamp.fromDate(deadline),
//                               managerIdList: managerList,
//                               createDate: Timestamp.fromDate(DateTime.now()),
//                               updateDate: Timestamp.fromDate(DateTime.now()),
//                             );

//                             // TODOLISTコレクションにドキュメント追加
//                             await TodoDataService.createTodoData(
//                                 selectedGroupID.value!,
//                                 selectedTodoListID.value!,
//                                 todoFields.toMap());
//                             // print('content: $content');
//                             // print('isChecked: $isChecked');
//                             // print('deadline: $deadline');
//                             // print('managerList: $managerList');

//                             Navigator.pop(context);
//                           },
//                           // ボタンの色と枠線を設定する
//                           style: ElevatedButton.styleFrom(
//                             padding: EdgeInsets.symmetric(horizontal: 12),
//                             foregroundColor: Colors.white,
//                             backgroundColor: Color.fromARGB(255, 15, 217, 15),
//                             side: BorderSide(color: Colors.black, width: 2),
//                           ),
//                           child: Padding(
//                             // 指マーク用として右にスペースを開ける＋テキスト下がるので4上げる
//                             padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
//                             child: Text(
//                               '決  定',
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 fontFamily: GoogleFonts.notoSansJp(
//                                   textStyle: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ).fontFamily,
//                                 shadows: [
//                                   Shadow(
//                                     color: Color.fromARGB(255, 128, 128, 128),
//                                     blurRadius: 0,
//                                     offset: Offset(0, 2.5),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }
