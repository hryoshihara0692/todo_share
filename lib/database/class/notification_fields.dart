import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationFields {
  final String userId;
  final String userName;
  final String groupId;
  final String groupName;
  final String todolistId;
  final String todolistName;
  final String todoId;
  final String content;
  final String beforeContent;
  final String notificationType;
  final Timestamp notificationDate;
  final Timestamp createDate;
  final Timestamp updateDate;

  NotificationFields({
    required this.userId,
    required this.userName,
    required this.groupId,
    required this.groupName,
    required this.todolistId,
    required this.todolistName,
    required this.todoId,
    required this.content,
    required this.beforeContent,
    required this.notificationType,
    required this.notificationDate,
    required this.createDate,
    required this.updateDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'USER_ID': userId,
      'USER_NAME': userName,
      'GROUP_ID': groupId,
      'GROUP_NAME': groupName,
      'TODOLIST_ID': todolistId,
      'TODOLIST_NAME': todolistName,
      'TODO_ID': todoId,
      'CONTENT': content,
      'BEFORE_CONTENT': beforeContent,
      'NOTIFICATION_TYPE': notificationType,
      'NOTIFICATION_DATE': notificationDate,
      'CREATE_DATE': createDate,
      'UPDATE_DATE': updateDate,
    };
  }
}
