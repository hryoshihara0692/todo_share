import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_share/database/user_data_service.dart';
import 'package:todo_share/riverpod/selected_group.dart';
part 'selected_todolist.g.dart';

@riverpod
class SelectedTodoListNotifier extends AutoDisposeAsyncNotifier<String> {
  @override
  Future<String> build() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception('User not authenticated');
    }

    // PRIMARY_GROUP_IDを取得
    final groupId = await ref.watch(selectedGroupNotifierProvider.future);
    if (groupId.isEmpty) {
      throw Exception('Group ID not found');
    }

    // PRIMARY_TODOLIST_IDを取得
    final groupData = await UserDataService.getGroupData(uid, groupId);
    return groupData['PRIMARY_TODOLIST_ID'] ?? '';
  }

  // データを変更する関数
  void setSelectedTodoList(String selectedTodoListID) {
    state = AsyncValue.data(selectedTodoListID);
  }
}
