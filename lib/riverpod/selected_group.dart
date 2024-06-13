import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_share/database/user_data_service.dart';

part 'selected_group.g.dart';

@riverpod
class SelectedGroupNotifier extends AutoDisposeAsyncNotifier<String> {
  @override
  Future<String> build() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception('User not authenticated');
    }
    final userData = await UserDataService.getUserData(uid);
    return userData['PRIMARY_GROUP_ID'] ?? '';
  }

  // データを変更する関数
  void setSelectedGroup(String selectedGroup) {
    state = AsyncValue.data(selectedGroup);
  }
}
