import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBuWX9hnY0HVj3lVm4h66zIYKg8j8DRxOU',
    appId: '1:550927069501:android:25dc984fd195b4185c9554',
    messagingSenderId: '550927069501',
    projectId: 'interview-f81af',
    storageBucket: 'interview-f81af.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDERUz_e_u7HU1SlX3Mi1RnQ1CePMvxy5g',
    appId: '1:550927069501:ios:e363b0d988239dfe5c9554',
    messagingSenderId: '550927069501',
    projectId: 'interview-f81af',
    storageBucket: 'interview-f81af.firebasestorage.app',
    iosBundleId: 'com.example.interviewSimulator',
  );

}