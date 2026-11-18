
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

      default:
        throw UnsupportedError(
          'Firebase não suporta esta plataforma.',
        );
    }
  }

  // Configuração Firebase WEB

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCrnoJSCtp_h7t3fWXf4Olre1RH4x8Mgj0',
    appId: '1:632613605028:web:46868bf6fd46d96b466031',
    messagingSenderId: '632613605028',
    projectId: 'natasha-ec058',
    authDomain: 'natasha-ec058.firebaseapp.com',
    databaseURL: 'https://natasha-ec058-default-rtdb.firebaseio.com',
    storageBucket: 'natasha-ec058.appspot.com',
    measurementId: 'G-RKG2LZNPDT',
  );
  // Configuração Firebase ANDROID original

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8UwW24fK-AHws6-L1V2T5lt-m1Oinpt4',
    appId: '1:632613605028:android:43f879799adb4af8466031',
    messagingSenderId: '632613605028',
    projectId: 'natasha-ec058',
    databaseURL: 'https://natasha-ec058-default-rtdb.firebaseio.com',
    storageBucket: 'natasha-ec058.appspot.com',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJWJ2N1_pwLWJpqGaZGT0xaHb2_lG7-Ug',
    appId: '1:632613605028:ios:9ae51f25f4b397d6466031',
    messagingSenderId: '632613605028',
    projectId: 'natasha-ec058',
    databaseURL: 'https://natasha-ec058-default-rtdb.firebaseio.com',
    storageBucket: 'natasha-ec058.appspot.com',
    iosBundleId: 'devdiego.julio.fisiodesk',
  );
}
