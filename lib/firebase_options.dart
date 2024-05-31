// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyApKWFHUuwxqUqPyA8y6rFgrNhc3SAxq2Q',
    appId: '1:651396716124:web:099ef825f9e7096392b899',
    messagingSenderId: '651396716124',
    projectId: 'todo-share-bbb6a',
    authDomain: 'todo-share-bbb6a.firebaseapp.com',
    storageBucket: 'todo-share-bbb6a.appspot.com',
    measurementId: 'G-XJWNNTV5H5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC4MPIfiuKCHXq-frJgcDRlXb5oU8ZfdIc',
    appId: '1:651396716124:android:d0a0d1fbcaa6178e92b899',
    messagingSenderId: '651396716124',
    projectId: 'todo-share-bbb6a',
    storageBucket: 'todo-share-bbb6a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCyBtYKt3IuBKMtKlCdCYpCsUq691H47bE',
    appId: '1:651396716124:ios:b233a8c5388a39c292b899',
    messagingSenderId: '651396716124',
    projectId: 'todo-share-bbb6a',
    storageBucket: 'todo-share-bbb6a.appspot.com',
    iosBundleId: 'com.example.todoShare',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCyBtYKt3IuBKMtKlCdCYpCsUq691H47bE',
    appId: '1:651396716124:ios:b233a8c5388a39c292b899',
    messagingSenderId: '651396716124',
    projectId: 'todo-share-bbb6a',
    storageBucket: 'todo-share-bbb6a.appspot.com',
    iosBundleId: 'com.example.todoShare',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyApKWFHUuwxqUqPyA8y6rFgrNhc3SAxq2Q',
    appId: '1:651396716124:web:762ab23ed7c3f35d92b899',
    messagingSenderId: '651396716124',
    projectId: 'todo-share-bbb6a',
    authDomain: 'todo-share-bbb6a.firebaseapp.com',
    storageBucket: 'todo-share-bbb6a.appspot.com',
    measurementId: 'G-6RTYGEMVZM',
  );
}
