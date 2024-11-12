import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:todo/database/user_data_service.dart';
import 'package:uuid/uuid.dart';

class TodoListDataService {
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

  static Stream<QuerySnapshot> getTodoListCollection(String groupID) {
    final db = FirebaseFirestore.instance;
    final collectionRef = db
        .collection('GROUP')
        .doc(groupID)
        .collection('TODOLIST')
        // .where('TodoListID', isEqualTo: todoListId)
        // .orderBy(sortColumnTodo, descending: descendingTodo)
        .orderBy('CREATE_DATE', descending: false);
        // .orderBy(sortColumnTodo, descending: descendingTodo);
    return collectionRef.snapshots();
  }

  ///
  /// FirestoreへTodoListの登録
  ///
  // static Future<void> createTodoListData(
  //     String groupID, Map<String, dynamic> todolistData) async {
  //   var uuid = Uuid();
  //   var todoListID = uuid.v4();
  //   await FirebaseFirestore.instance
  //       .collection('GROUP')
  //       .doc(groupID)
  //       .collection('TODOLIST')
  //       .doc(todoListID)
  //       .set(todolistData);
  // }

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
      print('Failed to update field todolist1: $error');
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
      print('Failed to update field todolist2 : $error');
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
