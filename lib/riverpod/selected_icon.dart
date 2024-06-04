import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'selected_icon.g.dart';

@riverpod
class selectedIconNotifier extends _$selectedIconNotifier {
  @override
  String build() {
    // 最初のデータ
    return '';
  }

  // データを変更する関数
  void update(String selectedIcon) {
    // 変更前のデータ
    state = selectedIcon;
  }
}