import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:todo/database/user_data_service.dart';
import 'package:uuid/uuid.dart';

class AllDataService {
  static Future<void> updateGroupListAndDateInFirestore(
      String uid, String groupName) async {
    try {
      ///
      /// USERコレクションに作成したGROUPを追加（PRIMARY_GROUP_ID）
      ///
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('USER').doc(uid);

      DocumentSnapshot userDoc = await userDocRef.get();
      if (!userDoc.exists) {
        throw Exception("User document does not exist!");
      }

      var uuid = Uuid();
      var groupIdFromUuid = uuid.v4();

      // 更新するフィールドと値のマップを作成します
      Map<String, dynamic> updateData = {
        'PRIMARY_GROUP_ID': groupIdFromUuid,
        'UPDATE_DATE': Timestamp.now(),
      };

      // ドキュメントを更新します
      await userDocRef.update(updateData);

      ///
      /// USERコレクション配下に、GROUP一覧用サブコレクションを追加
      ///
      await FirebaseFirestore.instance
          .collection('USER')
          .doc(uid)
          .collection('GROUP')
          .doc(groupIdFromUuid)
          .set({
        'ORDER_NO': 0,
        'PRIMARY_TODOLIST_ID': '',
        'CREATE_DATE': Timestamp.now(),
        'UPDATE_DATE': Timestamp.now(),
      });

      ///
      /// GROUPコレクション
      ///
      await FirebaseFirestore.instance
          .collection('GROUP')
          .doc(groupIdFromUuid)
          .set({
        'GROUP_NAME': groupName,
        'ADMIN_USER_ID': uid,
        'CREATE_DATE': Timestamp.now(),
        'UPDATE_DATE': Timestamp.now(),
      });

      ///
      /// GROUPコレクション配下に、USER
      ///
      await FirebaseFirestore.instance
          .collection('GROUP')
          .doc(groupIdFromUuid)
          .collection('USER')
          .doc(uid)
          .set({
        'ORDER_NO': 0,
        'CREATE_DATE': Timestamp.now(),
        'UPDATE_DATE': Timestamp.now(),
      });
    } catch (e) {
      print('Error updating group list and update date in Firestore: $e');
      throw e;
    }
  }

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
      print('Failed to update field : $error');
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
      print('Failed to update field : $error');
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
