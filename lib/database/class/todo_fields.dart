import 'package:cloud_firestore/cloud_firestore.dart';

class TodoFields {
  final bool checkFlg;
  final String content;
  final String memo;
  final Timestamp deadline;
  final List<String> managerIdList;
  final Timestamp? createDate;
  final Timestamp updateDate;

  TodoFields({
    required this.checkFlg,
    required this.content,
    required this.memo,
    required this.deadline,
    required this.managerIdList,
    this.createDate,
    required this.updateDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'CHECK_FLG': checkFlg,
      'CONTENT': content,
      'MEMO': memo,
      'DEADLINE': deadline,
      'MANAGER_ID_LIST': managerIdList,
      'CREATE_DATE': createDate,
      'UPDATE_DATE': updateDate,
    };
  }
}
