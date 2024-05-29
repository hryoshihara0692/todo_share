import 'package:flutter/material.dart';
import 'package:todo_share/widgets/add_todo_modal.dart';
import 'package:todo_share/widgets/group_setting_modal.dart';

void showAddTodoModal(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return AddTodoModal();
    },
  );
}

void showGroupSettingModal(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return GroupSettingModal();
    },
  );
}
