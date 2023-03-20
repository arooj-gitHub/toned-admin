// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDpl4v0Z6xq8yb0EV9UYCZ_yQyJiRaKCxI',
    appId: '1:1055849239346:web:5e2354453dca0fcce33d2b',
    messagingSenderId: '1055849239346',
    projectId: 'toned-australia',
    authDomain: 'toned-australia.firebaseapp.com',
    storageBucket: 'toned-australia.appspot.com',
    measurementId: 'G-N4LRK7WN6M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAByQvBkoLMGnezDC4qF7lHitjMwcldx10',
    appId: '1:1055849239346:android:cca10073ceb4bfe7e33d2b',
    messagingSenderId: '1055849239346',
    projectId: 'toned-australia',
    storageBucket: 'toned-australia.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDa8X0lL6yxnIn91AZKH0h9_6LWUTD6PW8',
    appId: '1:1055849239346:ios:2315ed6f900e63e8e33d2b',
    messagingSenderId: '1055849239346',
    projectId: 'toned-australia',
    storageBucket: 'toned-australia.appspot.com',
    iosClientId: '1055849239346-tnicqdh8cjeikcsd1b12tivflpgfuur9.apps.googleusercontent.com',
    iosBundleId: 'com.example.admin',
  );
}
