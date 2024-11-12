import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:todo/database/user_data_service.dart';

class GroupDataService {
  // static Future<List<Map<String, dynamic>>> getTodoListCollection(
  //     String groupID) async {
  //   try {
  //     // Firestoreのコレクション参照
  //     CollectionReference groupCollection =
  //         FirebaseFirestore.instance.collection('GROUP');

  //     // 指定されたGROUPドキュメントの参照
  //     DocumentReference groupDocRef = groupCollection.doc(groupID);

  //     // サブコレクションTODOLISTの参照
  //     CollectionReference todoListCollection =
  //         groupDocRef.collection('TODOLIST');

  //     // サブコレクションの全ドキュメントを取得
  //     QuerySnapshot todoListSnapshot = await todoListCollection.get();

  //     // 各ドキュメントのデータをリストとして取得
  //     List<Map<String, dynamic>> todoListData =
  //         todoListSnapshot.docs.map((doc) {
  //       return doc.data() as Map<String, dynamic>;
  //     }).toList();

  //     return todoListData;
  //   } catch (e) {
  //     print('データ取得中にエラーが発生しました: $e');
  //     return [];
  //   }
  // }

  static Future<Map<String, dynamic>> getGroupData(String groupID) async {
    try {
      // Firestoreのコレクション参照
      CollectionReference groups =
          FirebaseFirestore.instance.collection('GROUP');

      // ユーザーIDを指定してドキュメントを取得
      DocumentSnapshot groupDoc = await groups.doc(groupID).get();

      // ドキュメントが存在するか確認
      if (groupDoc.exists) {
        // ドキュメント内のデータを取得
        Map<String, dynamic>? groupData =
            groupDoc.data() as Map<String, dynamic>;

        //空の場合、チェックしてもしなくても空を返すならチェック不要では…
        if (groupData.isNotEmpty) {
          return groupData;
        } else {
          print('指定されたユーザーIDのドキュメントが存在しません');
          return {};
        }
      } else {
        print('指定されたユーザーIDのドキュメントが存在しません');
        return {};
      }
    } catch (e) {
      print('データ取得中にエラーが発生しました: $e');
      return {};
    }
  }

  ///
  /// FirestoreへTodoListの登録
  ///
  static Future<void> createTodoListData(
      String todolistId, Map<String, dynamic> todolistData) async {
    await FirebaseFirestore.instance
        .collection('TODOLIST')
        .doc(todolistId)
        .set(todolistData);
  }

  ///
  /// FirestoreのTodoの内容更新
  ///
  static Future<void> updateTodoListName(
      String todolistId, String todoListName, List<String> userIDs) async {
    await FirebaseFirestore.instance
        .collection('TODOLIST')
        .doc(todolistId)
        .update({
      'TodoListName': todoListName,
      'UpdatedAt': Timestamp.fromDate(DateTime.now()),
    }).then((_) {
      // 更新が成功した場合の処理
      print('Field updated successfully.');
    }).catchError((error) {
      // 更新が失敗した場合のエラーハンドリング
      print('Failed to update field group1: $error');
    });

    // userIDs.forEach((element) async {
    //   await UserDataService.updateUserTodoListsEasy(
    //       element, todolistId, todoListName);
    // });
  }

  ///
  /// FirestoreのTodoの内容更新
  ///
  static Future<void> updateTodoListEditingPermission(
      String todolistId, bool editingPermission) async {
    int editingPermissionNumber = editingPermission ? 1 : 0;
    await FirebaseFirestore.instance
        .collection('TODOLIST')
        .doc(todolistId)
        .update({
      'EditingPermission': editingPermissionNumber,
      'UpdatedAt': Timestamp.fromDate(DateTime.now()),
    }).then((_) {
      // 更新が成功した場合の処理
      print('Field updated successfully.');
    }).catchError((error) {
      // 更新が失敗した場合のエラーハンドリング
      print('Failed to update field group2: $error');
    });
  }

  static Future<void> deleteTodoListData(String todolistId) async {
    FirebaseFirestore.instance
        .collection('TODOLIST')
        .doc(todolistId)
        .delete()
        .then((value) {
      print('Document with ID $todolistId deleted successfully.');
    }).catchError((error) {
      print('Failed to delete document: $error');
    });
  }
}
