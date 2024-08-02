import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // 日付フォーマット用
import 'package:todo_share/riverpod/selected_group.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationDialog extends ConsumerStatefulWidget {
  NotificationDialog({super.key});

  @override
  _NotificationDialogState createState() => _NotificationDialogState();
}

class _NotificationDialogState extends ConsumerState<NotificationDialog> {
  List<Map<String, dynamic>> notifications = [];
  List<bool> isExpanded = [];
  int currentBatch = 0;
  bool isLoading = false;

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadMoreNotifications();
  }

  Future<void> _loadMoreNotifications() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var selectedGroupId = ref.read(selectedGroupNotifierProvider);
    selectedGroupId.when(
      data: (groupId) async {
        try {
          print('uid: $uid');
          var notificationSnapshot = await FirebaseFirestore.instance
              .collection('USER')
              .doc(uid)
              .collection('NOTIFICATION')
              .orderBy('NOTIFICATION_DATE', descending: true)
              .limit((currentBatch + 1) * 10)
              .get();

          setState(() {
            notifications = notificationSnapshot.docs
                .map((doc) => {...doc.data(), 'id': doc.id})
                .toList();
            isExpanded = List<bool>.filled(notifications.length, false);
            currentBatch++;
          });
        } catch (e) {
          print("Error fetching notifications: $e");
        }
        setState(() {
          isLoading = false;
        });
      },
      loading: () => print('Loading...'),
      error: (error, stack) => print('エラーが発生しました: $error'),
    );
  }

  void _deleteNotification(String notificationId) async {
    var selectedGroupId = ref.read(selectedGroupNotifierProvider);
    selectedGroupId.when(
      data: (groupId) async {
        try {
          await FirebaseFirestore.instance
              .collection('USER')
              .doc(uid)
              .collection('NOTIFICATION')
              .doc(notificationId)
              .delete();
          setState(() {
            notifications.removeWhere((notification) => notification['id'] == notificationId);
          });
        } catch (e) {
          print("Error deleting notification: $e");
        }
      },
      loading: () => print('Loading...'),
      error: (error, stack) => print('エラーが発生しました: $error'),
    );
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
                    '通知',
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
            SizedBox(height: 8.0),
            Expanded(
              child: notifications.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: notifications.length + 1,
                      itemBuilder: (context, index) {
                        if (index == notifications.length) {
                          return isLoading
                              ? Center(child: CircularProgressIndicator())
                              : TextButton(
                                  onPressed: _loadMoreNotifications,
                                  child: Text('もっと読む'),
                                );
                        }
                        var notification = notifications[index];
                        var date = (notification['NOTIFICATION_DATE'] as Timestamp).toDate();
                        var formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(date);

                        return Column(
                          children: [
                            ListTile(
                              leading: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteNotification(notification['id']),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: notification['GROUP_NAME'],
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: 'の'),
                                        TextSpan(
                                          text: notification['TODOLIST_NAME'],
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: 'に'),
                                        TextSpan(
                                          text: notification['USER_NAME'],
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: 'がTODOを追加しました。'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // trailing: IconButton(
                              //   icon: Icon(isExpanded[index] ? Icons.expand_less : Icons.expand_more),
                              //   onPressed: () {
                              //     setState(() {
                              //       isExpanded[index] = !isExpanded[index];
                              //     });
                              //   },
                              // ),
                            ),
                            if (isExpanded[index])
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(notification['CONTENT']),
                              ),
                          ],
                        );
                      },
                    ),
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 255, 102, 112),
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                    child: Padding(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
