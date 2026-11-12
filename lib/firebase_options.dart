import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

/// Default [FirebaseOptions] for use with Firebase.initializeApp.
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
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'AIzaSyDemoWebApiKeyPlaceholder12345'),
    appId: String.fromEnvironment('FIREBASE_APP_ID', defaultValue: '1:1234567890:web:1234567890abcdef'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '1234567890'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'attendance-management-demo'),
    authDomain: 'attendance-management-demo.firebaseapp.com',
    storageBucket: 'attendance-management-demo.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'AIzaSyDemoAndroidApiKeyPlaceholder1234'),
    appId: String.fromEnvironment('FIREBASE_APP_ID', defaultValue: '1:1234567890:android:1234567890abcdef'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '1234567890'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'attendance-management-demo'),
    storageBucket: 'attendance-management-demo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDemoIosApiKeyPlaceholder12345',
    appId: '1:1234567890:ios:1234567890abcdef',
    messagingSenderId: '1234567890',
    projectId: 'attendance-management-demo',
    storageBucket: 'attendance-management-demo.appspot.com',
    iosBundleId: 'com.example.attendanceManagement',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDemoMacosApiKeyPlaceholder1234',
    appId: '1:1234567890:ios:1234567890abcdef',
    messagingSenderId: '1234567890',
    projectId: 'attendance-management-demo',
    storageBucket: 'attendance-management-demo.appspot.com',
    iosBundleId: 'com.example.attendanceManagement',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDemoWindowsApiKeyPlaceholder12',
    appId: '1:1234567890:web:1234567890abcdef',
    messagingSenderId: '1234567890',
    projectId: 'attendance-management-demo',
    authDomain: 'attendance-management-demo.firebaseapp.com',
    storageBucket: 'attendance-management-demo.appspot.com',
  );
}
