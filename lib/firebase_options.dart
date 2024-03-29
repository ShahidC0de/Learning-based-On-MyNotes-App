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
        return macos;
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
    apiKey: 'AIzaSyAEg--hyu45SaLLa8G2EF-UfAXhA5YMYfY',
    appId: '1:1026650994328:web:1ef26ef82ed75807a882ed',
    messagingSenderId: '1026650994328',
    projectId: 'my-firstregistration-project',
    authDomain: 'my-firstregistration-project.firebaseapp.com',
    storageBucket: 'my-firstregistration-project.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVqEjuvw2vHL857RoBDBsypgMMEyThKew',
    appId: '1:1026650994328:android:a8bd2ebe93194cd1a882ed',
    messagingSenderId: '1026650994328',
    projectId: 'my-firstregistration-project',
    storageBucket: 'my-firstregistration-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD6kaVQRQJf-FSDQz4rk0ogHjX7n7vxKv0',
    appId: '1:1026650994328:ios:f9cc303f16cee8e5a882ed',
    messagingSenderId: '1026650994328',
    projectId: 'my-firstregistration-project',
    storageBucket: 'my-firstregistration-project.appspot.com',
    iosBundleId: 'com.example.registrationAppLearning',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD6kaVQRQJf-FSDQz4rk0ogHjX7n7vxKv0',
    appId: '1:1026650994328:ios:6d4403a8f924424da882ed',
    messagingSenderId: '1026650994328',
    projectId: 'my-firstregistration-project',
    storageBucket: 'my-firstregistration-project.appspot.com',
    iosBundleId: 'com.example.registrationAppLearning.RunnerTests',
  );
}
