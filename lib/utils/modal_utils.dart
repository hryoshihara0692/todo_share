import 'package:flutter/material.dart';
import 'package:todo_share/widgets/todo_add_modal.dart';
import 'package:todo_share/widgets/group_setting_modal.dart';
import 'package:todo_share/widgets/user_setting_modal.dart';

void showTodoAddModal(BuildContext context, String groupID) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return TodoAddModal();
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

void showUserSettingModal(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return UserSettingModal();
    },
  );
}
