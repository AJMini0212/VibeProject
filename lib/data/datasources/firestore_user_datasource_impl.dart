import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_user_datasource.dart';

class FirestoreUserDatasourceImpl implements FirestoreUserDatasource {
  final FirebaseFirestore _firestore;

  FirestoreUserDatasourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

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
