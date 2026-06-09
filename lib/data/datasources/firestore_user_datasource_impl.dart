import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'firestore_user_datasource.dart';

class FirestoreUserDatasourceImpl implements FirestoreUserDatasource {
  final FirebaseFirestore _firestore;

  FirestoreUserDatasourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        return null;
      }
      return UserModel.fromJson(doc.data() ?? {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      if (query.isEmpty) {
        return [];
      }

      final lowerQuery = query.toLowerCase();
      final snapshot = await _firestore
          .collection('users')
          .get();

      final results = snapshot.docs
          .where((doc) {
            final displayName =
                (doc.data()['displayName'] as String?)?.toLowerCase() ?? '';
            final email = (doc.data()['email'] as String?)?.toLowerCase() ?? '';
            return displayName.contains(lowerQuery) ||
                email.contains(lowerQuery);
          })
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();

      return results;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addFavorite(String uid, String cafeId) async {
    try {
      await _firestore.collection('users').doc(uid).update(
        {
          'favoriteIds': FieldValue.arrayUnion([cafeId]),
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFavorite(String uid, String cafeId) async {
    try {
      await _firestore.collection('users').doc(uid).update(
        {
          'favoriteIds': FieldValue.arrayRemove([cafeId]),
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getFavorites(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        return [];
      }
      final favoriteIds = doc.get('favoriteIds') as List<dynamic>?;
      return (favoriteIds ?? []).map((id) => id as String).toList();
    } catch (e) {
      rethrow;
    }
  }
}
