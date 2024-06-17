import 'package:firebase_auth/firebase_auth.dart';

class UID {
  static final UID _instance = UID._internal();

  factory UID() {
    return _instance;
  }

  UID._internal();

  String? uid;

  Future<void> initialize() async {
    uid = FirebaseAuth.instance.currentUser?.uid;
  }
}
