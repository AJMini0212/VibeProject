import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'firebase_auth_datasource.dart';

class FirebaseAuthDatasourceImpl implements FirebaseAuthDatasource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDatasourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  @override
  Future<UserModel> signUp(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('사용자 생성 실패');
      }

      await user.updateDisplayName(displayName);

      final userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: displayName,
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
        favoriteIds: [],
      );

      await _firestore.collection('users').doc(user.uid).set(
            userModel.toJson(),
          );

      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('로그인 실패');
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        throw Exception('사용자 데이터를 찾을 수 없습니다');
      }

      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return null;
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        return null;
      }

      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      rethrow;
    }
  }
}
