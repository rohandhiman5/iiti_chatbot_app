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
    apiKey: 'AIzaSyAfhlDSRTqbz0sSYwkeNSwQ31p34ERtHOI',
    appId: '1:23282027373:web:d427a20b1a26ab909f2864',
    messagingSenderId: '23282027373',
    projectId: 'flutterbot-b5090',
    authDomain: 'flutterbot-b5090.firebaseapp.com',
    storageBucket: 'flutterbot-b5090.firebasestorage.app',
    measurementId: 'G-GD47CD07GN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9OGE1UdHXHD0injg-Vup9jWJ3aDCbKHg',
    appId: '1:23282027373:android:ef98ea5b72bc30579f2864',
    messagingSenderId: '23282027373',
    projectId: 'flutterbot-b5090',
    storageBucket: 'flutterbot-b5090.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBUdhjQ7RBbuNfQWxg12LS9A7jcG113tv0',
    appId: '1:23282027373:ios:556d860197756c299f2864',
    messagingSenderId: '23282027373',
    projectId: 'flutterbot-b5090',
    storageBucket: 'flutterbot-b5090.firebasestorage.app',
    iosBundleId: 'com.example.frontend',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBUdhjQ7RBbuNfQWxg12LS9A7jcG113tv0',
    appId: '1:23282027373:ios:556d860197756c299f2864',
    messagingSenderId: '23282027373',
    projectId: 'flutterbot-b5090',
    storageBucket: 'flutterbot-b5090.firebasestorage.app',
    iosBundleId: 'com.example.frontend',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAfhlDSRTqbz0sSYwkeNSwQ31p34ERtHOI',
    appId: '1:23282027373:web:63ddec25fa3d49989f2864',
    messagingSenderId: '23282027373',
    projectId: 'flutterbot-b5090',
    authDomain: 'flutterbot-b5090.firebaseapp.com',
    storageBucket: 'flutterbot-b5090.firebasestorage.app',
    measurementId: 'G-C56X3L7H0N',
  );

}