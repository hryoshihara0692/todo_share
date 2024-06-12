import 'package:cloud_firestore/cloud_firestore.dart';

class TodoFields {
  final String content;
  final bool checkFlg;
  final Timestamp createDate;
  final Timestamp updateDate;

  TodoFields({
    required this.content,
    required this.checkFlg,
    required this.createDate,
    required this.updateDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'CONTENT': content,
      'CHECK_FLG': checkFlg,
      'CREATE_DATE': createDate,
      'UPDATE_DATE': updateDate,
    };
  }
}
