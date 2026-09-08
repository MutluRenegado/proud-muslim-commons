import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
/// Configured for project `finalapp-e9ffc`.
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
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCuBD3a-f5ltCS5lro9Ah_YJTFn9Xkg40U',
    appId: '1:709206903658:web:a522089b5dcaaa7f5e3313',
    messagingSenderId: '709206903658',
    projectId: 'finalapp-e9ffc',
    authDomain: 'finalapp-e9ffc.firebaseapp.com',
    storageBucket: 'finalapp-e9ffc.firebasestorage.app',
    measurementId: 'G-90NFY4ZBC0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCuBD3a-f5ltCS5lro9Ah_YJTFn9Xkg40U',
    appId: '1:709206903658:android:c989b5dcaaa7f5e3313',
    messagingSenderId: '709206903658',
    projectId: 'finalapp-e9ffc',
    storageBucket: 'finalapp-e9ffc.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCuBD3a-f5ltCS5lro9Ah_YJTFn9Xkg40U',
    appId: '1:709206903658:ios:c989b5dcaaa7f5e3313',
    messagingSenderId: '709206903658',
    projectId: 'finalapp-e9ffc',
    storageBucket: 'finalapp-e9ffc.firebasestorage.app',
    iosBundleId: 'online.anmdigital.proudmuslim',
  );
}
