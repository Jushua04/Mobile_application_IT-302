import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB3ptHluBaffBFxZ7lpcFr9LaaY3Bxm3fY',
    appId: '1:438299934607:web:5a977090d98d0b563655fa',
    messagingSenderId: '438299934607',
    projectId: 'kalimot-ka',
    authDomain: 'kalimot-ka.firebaseapp.com',
    storageBucket: 'kalimot-ka.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3ptHluBaffBFxZ7IpcFr9LaaY3Bxm3fY',
    appId: '1:438299934607:android:abcdef123456',
    messagingSenderId: '438299934607',
    projectId: 'kalimot-ka',
    storageBucket: 'kalimot-ka.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB3ptHluBaffBFxZ7IpcFr9LaaY3Bxm3fY',
    appId: '1:438299934607:ios:abcdef123456',
    messagingSenderId: '438299934607',
    projectId: 'kalimot-ka',
    storageBucket: 'kalimot-ka.firebasestorage.app',
    iosBundleId: 'com.example.kalimotKa',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB3ptHluBaffBFxZ7IpcFr9LaaY3Bxm3fY',
    appId: '1:438299934607:ios:abcdef123456',
    messagingSenderId: '438299934607',
    projectId: 'kalimot-ka',
    storageBucket: 'kalimot-ka.firebasestorage.app',
    iosBundleId: 'com.example.kalimotKa',
  );
}