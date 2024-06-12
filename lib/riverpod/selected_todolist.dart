import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'selected_todolist.g.dart';

@riverpod
class selectedTodoListNotifier extends _$selectedTodoListNotifier {
  @override
  String build() {
    // 最初のデータ
    return '';
  }

  // データを変更する関数
  void update(String selectedTodoList) {
    // 変更前のデータ
    state = selectedTodoList;
  }
}