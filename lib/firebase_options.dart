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
    apiKey: 'AIzaSyCUmBORxUNUBDsBI7Me7EpP8eKr8JmdoMg',
    appId: '1:849282950622:web:d31fd2fdcc4c098e80e94f',
    messagingSenderId: '849282950622',
    projectId: 'jetstream-2e90c',
    authDomain: 'jetstream-2e90c.firebaseapp.com',
    storageBucket: 'jetstream-2e90c.firebasestorage.app',
    measurementId: 'G-F7M1RGD8H8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCVEtrALBjPwEnXQ1ykwbhXsfxMoV_Sbf4',
    appId: '1:849282950622:android:7ce6d7beedf59f1c80e94f',
    messagingSenderId: '849282950622',
    projectId: 'jetstream-2e90c',
    storageBucket: 'jetstream-2e90c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC8wzr-s_9K9MYxEgXUlWxvxcyclgb4Lo8',
    appId: '1:849282950622:ios:9b1e2cc682bb4d8c80e94f',
    messagingSenderId: '849282950622',
    projectId: 'jetstream-2e90c',
    storageBucket: 'jetstream-2e90c.firebasestorage.app',
    iosClientId: '849282950622-c9hfdki4t162p46u3vs8rmj7ajlciu01.apps.googleusercontent.com',
    iosBundleId: 'com.example.jetstreamNew',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC8wzr-s_9K9MYxEgXUlWxvxcyclgb4Lo8',
    appId: '1:849282950622:ios:9b1e2cc682bb4d8c80e94f',
    messagingSenderId: '849282950622',
    projectId: 'jetstream-2e90c',
    storageBucket: 'jetstream-2e90c.firebasestorage.app',
    iosClientId: '849282950622-c9hfdki4t162p46u3vs8rmj7ajlciu01.apps.googleusercontent.com',
    iosBundleId: 'com.example.jetstreamNew',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCUmBORxUNUBDsBI7Me7EpP8eKr8JmdoMg',
    appId: '1:849282950622:web:8e967eb432f433b280e94f',
    messagingSenderId: '849282950622',
    projectId: 'jetstream-2e90c',
    authDomain: 'jetstream-2e90c.firebaseapp.com',
    storageBucket: 'jetstream-2e90c.firebasestorage.app',
    measurementId: 'G-XSWVKJ11VM',
  );

}