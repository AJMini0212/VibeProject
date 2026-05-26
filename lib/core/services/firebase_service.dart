import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyDummy',
          appId: '1:123456789:web:abcdef1234567890',
          messagingSenderId: '123456789',
          projectId: 'cafematch-dev',
          authDomain: 'cafematch-dev.firebaseapp.com',
          databaseURL: 'https://cafematch-dev.firebaseio.com',
          storageBucket: 'cafematch-dev.appspot.com',
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
