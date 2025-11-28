// Generated file placeholder for Firebase configuration.
// Replace the empty strings below with the values from your Firebase project
// (Project settings -> Your apps -> Add app -> Web app). If you run
// `flutterfire configure` the real file will be generated automatically.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      default:
        return web; // fallback
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCDAFcAOg7xwl1iklDby7X9XAlGAYgo1OQ',
    appId: '1:614512660493:web:fa56668d6951b9531e8544',
    messagingSenderId: '614512660493',
    projectId: 'examen01-9c603',
    authDomain: 'examen01-9c603.firebaseapp.com',
    storageBucket: 'examen01-9c603.firebasestorage.app',
    measurementId: 'G-W47KL2TJWN',
  );

  // TODO: Replace these empty values with your project's web config

  // Android values are not strictly required (the native google-services.json is used),
  // but you can fill them if you prefer explicit initialization.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    storageBucket: '',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    storageBucket: '',
    iosBundleId: '',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    storageBucket: '',
  );
}