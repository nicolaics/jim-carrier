// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  static FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_WEB_API_KEY'] ?? 'default_key',
    appId: dotenv.env['FIREBASE_WEB_APP_ID'] ?? 'default_key',
    messagingSenderId: dotenv.env['FIREBASE_WEB_MESSAGING_SENDER_ID'] ?? 'default_key',
    projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'default_key',
    authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? 'default_key',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'default_key',
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_ANDROID_API_KEY'] ?? 'default_key',
    appId: dotenv.env['FIREBASE_ANDROID_APP_ID'] ?? 'default_key',
    messagingSenderId: dotenv.env['FIREBASE_ANDROID_MESSAGING_SENDER_ID'] ?? 'default_key',
    projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'default_key',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'default_key',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_IOS_API_KEY'] ?? 'default_key',
    appId: dotenv.env['FIREBASE_IOS_APP_ID'] ?? 'default_key',
    messagingSenderId: dotenv.env['FIREBASE_IOS_MESSAGING_SENDER_ID'] ?? 'default_key',
    projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'default_key',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'default_key',
    iosClientId: dotenv.env['FIREBASE_IOS_CLIENT_ID'] ?? 'default_key',
    iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID'] ?? 'default_key',
  );

  static FirebaseOptions macos = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_MAC_OS_API_KEY'] ?? 'default_key',
    appId: dotenv.env['FIREBASE_MAC_OS_APP_ID'] ?? 'default_key',
    messagingSenderId: dotenv.env['FIREBASE_MAC_OS_MESSAGING_SENDER_ID'] ?? 'default_key',
    projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'default_key',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'default_key',
    iosClientId: dotenv.env['FIREBASE_MAC_OS_CLIENT_ID'] ?? 'default_key',
    iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID'] ?? 'default_key',
  );

  static FirebaseOptions windows = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_WINDOWS_API_KEY'] ?? 'default_key',
    appId: dotenv.env['FIREBASE_WINDOWS_APP_ID'] ?? 'default_key',
    messagingSenderId: dotenv.env['FIREBASE_WINDOWS_MESSAGING_SENDER_ID'] ?? 'default_key',
    projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'default_key',
    authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? 'default_key',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? 'default_key',
  );
}
