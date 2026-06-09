import '../models/user_model.dart';

abstract class FirestoreUserDatasource {
  Future<UserModel?> getUserById(String userId);
  Future<List<UserModel>> searchUsers(String query);
  Future<void> addFavorite(String uid, String cafeId);
  Future<void> removeFavorite(String uid, String cafeId);
  Future<List<String>> getFavorites(String uid);
}
