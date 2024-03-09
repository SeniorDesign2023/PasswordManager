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
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDPCWi7Xorvg9G5TA2ha5SEHTZKMSHmCx8',
    appId: '1:841985936375:web:455031f61436f9ded1fcf2',
    messagingSenderId: '523652369638',
    projectId: 'cosc-4995-ui-0',
    authDomain: 'cosc-4995-ui-0.firebaseapp.com',
    storageBucket: 'cosc-4995-ui-0.appspot.com'
//    measurementId: "G-MM7BNXL21D"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDPCWi7Xorvg9G5TA2ha5SEHTZKMSHmCx8',
    appId: '1:841985936375:web:455031f61436f9ded1fcf2',
    messagingSenderId: '523652369638',
    projectId: 'cosc-4995-ui-0',
    storageBucket: 'cosc-4995-ui-0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDPCWi7Xorvg9G5TA2ha5SEHTZKMSHmCx8',
    appId: '1:841985936375:web:455031f61436f9ded1fcf2',
    messagingSenderId: '523652369638',
    projectId: 'cosc-4995-ui-0',
    storageBucket: 'cosc-4995-ui-0.appspot.com',
    iosClientId: '523652369638-m64ff32h055cmhlln93h3dol6st3eqjc.apps.googleusercontent.com',
    iosBundleId: 'com.example.app'
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDPCWi7Xorvg9G5TA2ha5SEHTZKMSHmCx8',
    appId: '1:841985936375:web:455031f61436f9ded1fcf2',
    messagingSenderId: '523652369638',
    projectId: 'cosc-4995-ui-0',
    storageBucket: 'cosc-4995-ui-0.appspot.com',
    iosClientId: '523652369638-m64ff32h055cmhlln93h3dol6st3eqjc.apps.googleusercontent.com',
    iosBundleId: 'com.example.app'
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDPCWi7Xorvg9G5TA2ha5SEHTZKMSHmCx8',
    appId: '1:841985936375:web:455031f61436f9ded1fcf2',
    messagingSenderId: '523652369638',
    projectId: 'cosc-4995-ui-0',
    authDomain: 'cosc-4995-ui-0.firebaseapp.com',
    storageBucket: 'cosc-4995-ui-0.appspot.com'
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyDPCWi7Xorvg9G5TA2ha5SEHTZKMSHmCx8',
    appId: '1:841985936375:web:455031f61436f9ded1fcf2',
    messagingSenderId: '523652369638',
    projectId: 'cosc-4995-ui-0',
    authDomain: 'cosc-4995-ui-0.firebaseapp.com',
    storageBucket: 'cosc-4995-ui-0.appspot.com'
  );
}
