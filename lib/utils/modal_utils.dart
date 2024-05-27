import 'package:flutter/material.dart';
import 'package:todo_share/widgets/add_todo_modal.dart';

void showModal(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return AddTodoModal();
    },
  );
}