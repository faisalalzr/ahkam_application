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
    apiKey: 'AIzaSyBOJahCFc_LTLmtJVDyNE7r8N3P98a1RmM',
    appId: '1:109566467452:web:c7b120a4fe98b94488d8f9',
    messagingSenderId: '109566467452',
    projectId: 'ahkamapp',
    authDomain: 'ahkamapp.firebaseapp.com',
    storageBucket: 'ahkamapp.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBzyAeJZUvVdHZ2avKrMDOmtVY5g0mzMf8',
    appId: '1:109566467452:android:642149bcd02d03d488d8f9',
    messagingSenderId: '109566467452',
    projectId: 'ahkamapp',
    storageBucket: 'ahkamapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAIl-xN_hZWZt8fWDuDzS1haUEtSAd5XPU',
    appId: '1:109566467452:ios:e0947c08e6e45cc188d8f9',
    messagingSenderId: '109566467452',
    projectId: 'ahkamapp',
    storageBucket: 'ahkamapp.firebasestorage.app',
    iosBundleId: 'com.example.chat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAIl-xN_hZWZt8fWDuDzS1haUEtSAd5XPU',
    appId: '1:109566467452:ios:e0947c08e6e45cc188d8f9',
    messagingSenderId: '109566467452',
    projectId: 'ahkamapp',
    storageBucket: 'ahkamapp.firebasestorage.app',
    iosBundleId: 'com.example.chat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBOJahCFc_LTLmtJVDyNE7r8N3P98a1RmM',
    appId: '1:109566467452:web:b0fc9ea461d4d20388d8f9',
    messagingSenderId: '109566467452',
    projectId: 'ahkamapp',
    authDomain: 'ahkamapp.firebaseapp.com',
    storageBucket: 'ahkamapp.firebasestorage.app',
  );

}