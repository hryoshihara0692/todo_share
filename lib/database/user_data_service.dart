import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataService {
  static Future<Map<String, dynamic>> getUserData(String uid) async {
    try {
      // Firestoreのコレクション参照
      CollectionReference users = FirebaseFirestore.instance.collection('USER');

      // ユーザーIDを指定してドキュメントを取得
      DocumentSnapshot userDoc = await users.doc(uid).get();

      // ドキュメントが存在するか確認
      if (userDoc.exists) {
        // ドキュメント内のデータを取得
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>;

        //空の場合、チェックしてもしなくても空を返すならチェック不要では…
        if (userData.isNotEmpty) {
          return userData;
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
  /// FirestoreのTodoの内容更新
  ///
  static Future<void> updateUserPrimaryGroupID(
      String uid, String primaryGroupID) async {
    try {
      // DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      //     .instance
      //     .collection('USER')
      //     .doc(uid)
      //     .get();
      // if (snapshot.exists) {
      //   var user = snapshot.data()!;
      //   List<String> userIDs =
      //       List<String>.from(todoList['UserIDs'].cast<String>() ?? []);
      //   if (!userIDs.contains(uid)) {
      //     userIDs.add(uid);
      await FirebaseFirestore.instance.collection('USER').doc(uid).update({
        'PRIMARY_GROUP_ID': primaryGroupID,
        'UPDATE_DATE': Timestamp.fromDate(DateTime.now()),
      });
      // }
      // todoListName = todoList['TodoListName'];
      // } else {
      //   throw Exception('Document does not exist'); // エラーをスローする
      //   // ドキュメントが存在しない場合の処理
      //   // 例: エラーメッセージの表示など
      // }
    } catch (e) {
      throw e; // エラーを再スローして呼び出し元に伝える
      // エラーが発生した場合の処理
      // 例: エラーメッセージの表示など
    }
  }

  static Future<Map<String, dynamic>> getGroupData(
      String uid, String groupID) async {
    try {
      // Firestoreからグループデータを取得
      final doc = await FirebaseFirestore.instance
          .collection('USER')
          .doc(uid)
          .collection('GROUP')
          .doc(groupID)
          .get();

      // ドキュメントが存在するか確認
      if (doc.exists) {
        // ドキュメント内のデータを取得
        Map<String, dynamic>? groupData = doc.data() as Map<String, dynamic>;

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

  static Future<Map<String, dynamic>> getUserDataSelectedByTodoListID(
      String todoListID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('USER')
          .where(todoListID, arrayContains: true)
          .get();

      return {};
    } catch (e) {
      print('データ取得中にエラーが発生しました: $e');
      return {};
    }
  }

  ///
  /// FirestoreへUSERの登録
  ///
  static Future<void> createUserData(
      String documentId, Map<String, dynamic> userData) async {
    await FirebaseFirestore.instance
        .collection('USER')
        .doc(documentId)
        .set(userData);
  }

  ///
  /// FirestoreへUSERの登録
  ///
  static Future<void> addTodoListForUserData(
      String uid, String todoListId, String todoListName) async {
    // Firestoreのコレクション参照
    CollectionReference users = FirebaseFirestore.instance.collection('USER');

    DocumentReference docRef = users.doc(uid);

    // ドキュメントを更新（既存のデータとマージ）
    await docRef.update({
      'TodoLists.$todoListId': todoListName,
    }).catchError((error) {
      print("ドキュメントの更新中にエラーが発生しました： $error");
    });
  }

  ///
  /// FirestoreのTodoの内容更新
  ///
  static Future<void> updateUserTodoLists(String uid, String todoListID) async {
    // int editingPermissionNumber = editingPermission ? 1 : 0;
    String todoListName = '';
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('TODOLIST')
          .doc(todoListID)
          .get();
      if (snapshot.exists) {
        // setState(() {
        //   todoList = snapshot.data()!;
        //   isChecked = todoList['EditingPermission'] == 1 ? true : false;
        // });
        var todoList = snapshot.data()!;
        List<String> userIDs =
            List<String>.from(todoList['UserIDs'].cast<String>() ?? []);
        if (!userIDs.contains(uid)) {
          userIDs.add(uid);
          await FirebaseFirestore.instance
              .collection('TODOLIST')
              .doc(todoListID)
              .update({'UserIDs': userIDs});
        }
        todoListName = todoList['TodoListName'];
      } else {
        throw Exception('Document does not exist'); // エラーをスローする
        // ドキュメントが存在しない場合の処理
        // 例: エラーメッセージの表示など
      }
    } catch (e) {
      throw e; // エラーを再スローして呼び出し元に伝える
      // エラーが発生した場合の処理
      // 例: エラーメッセージの表示など
    }

    if (todoListName != '') {
      // await FirebaseFirestore.instance.collection('USER').doc(uid).update({
      //   // 'EditingPermission': editingPermissionNumber,
      //   'TodoLists': {todoListID: todoListName},
      //   'UpdatedAt': Timestamp.fromDate(DateTime.now()),
      // }).then((_) {
      //   // 更新が成功した場合の処理
      //   print('Field updated successfully.');
      // }).catchError((error) {
      //   // 更新が失敗した場合のエラーハンドリング
      //   print('Failed to update field : $error');
      // });
      // ドキュメントの参照を取得
      final userDocRef = FirebaseFirestore.instance.collection('USER').doc(uid);

// ドキュメントのデータを取得して更新
      userDocRef.get().then((doc) {
        if (doc.exists) {
          // 既存のデータを取得
          final userData = doc.data() as Map<String, dynamic>;

          // 新しいデータをマージ
          final newTodoLists =
              Map<String, dynamic>.from(userData['TodoLists'] ?? {});
          newTodoLists[todoListID] = todoListName;

          // 更新するデータを準備
          final updatedData = {
            'TodoLists': newTodoLists,
            'UpdatedAt': Timestamp.fromDate(DateTime.now()),
          };

          // 更新を実行
          userDocRef.update(updatedData).then((_) {
            // 更新が成功した場合の処理
            print('Field updated successfully.');
          }).catchError((error) {
            // 更新が失敗した場合のエラーハンドリング
            print('Failed to update field : $error');
          });
        } else {
          print('Document does not exist');
        }
      }).catchError((error) {
        print('Failed to get document: $error');
      });
    }
  }

  static Future<void> removeTodoListFromUser(
      String uid, String todoListID) async {
    final userDocRef = FirebaseFirestore.instance.collection('USER').doc(uid);

    // ドキュメントのデータを取得して更新
    userDocRef.get().then((doc) {
      if (doc.exists) {
        // 既存のデータを取得
        final userData = doc.data() as Map<String, dynamic>;

        // 既存のTodoListsを取得
        final todoLists =
            Map<String, dynamic>.from(userData['TodoLists'] ?? {});

        // 指定されたtodoListIDをキーとするエントリを削除
        if (todoLists.containsKey(todoListID)) {
          todoLists.remove(todoListID);

          // 更新するデータを準備
          final updatedData = {
            'TodoLists': todoLists,
            'UpdatedAt': Timestamp.fromDate(DateTime.now()),
          };

          // 更新を実行
          userDocRef.update(updatedData).then((_) {
            // 更新が成功した場合の処理
            print('TodoList removed successfully.');
          }).catchError((error) {
            // 更新が失敗した場合のエラーハンドリング
            print('Failed to update field: $error');
          });
        } else {
          print('TodoList with ID $todoListID does not exist.');
        }
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Failed to get document: $error');
    });
  }

  ///
  /// FirestoreのTodoの内容更新
  ///
  static Future<void> updateUserTodoListsEasy(
      String uid, String todoListID, String todoListName) async {
    // int editingPermissionNumber = editingPermission ? 1 : 0;
    // String todoListName = '';
    // try {
    //   DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
    //       .instance
    //       .collection('TODOLIST')
    //       .doc(todoListID)
    //       .get();
    //   if (snapshot.exists) {
    //     // setState(() {
    //     //   todoList = snapshot.data()!;
    //     //   isChecked = todoList['EditingPermission'] == 1 ? true : false;
    //     // });
    //     var todoList = snapshot.data()!;
    //     todoListName = todoList['TodoListName'];
    //   } else {
    //     throw Exception('Document does not exist'); // エラーをスローする
    //     // ドキュメントが存在しない場合の処理
    //     // 例: エラーメッセージの表示など
    //   }
    // } catch (e) {
    //   throw e; // エラーを再スローして呼び出し元に伝える
    //   // エラーが発生した場合の処理
    //   // 例: エラーメッセージの表示など
    // }

    // if (todoListName != '') {
    await FirebaseFirestore.instance.collection('USER').doc(uid).update({
      // 'EditingPermission': editingPermissionNumber,
      'TodoLists': {todoListID: todoListName},
      'UpdatedAt': Timestamp.fromDate(DateTime.now()),
    }).then((_) {
      // 更新が成功した場合の処理
      print('Field updated successfully.');
    }).catchError((error) {
      // 更新が失敗した場合のエラーハンドリング
      print('Failed to update field : $error');
    });
    // }
  }
}
