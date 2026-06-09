import '../entities/user.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String displayName);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<User?> getUserById(String userId);
  Future<void> updateProfile(String? displayName, String? photoUrl);
  Future<void> addFavorite(String cafeId);
  Future<void> removeFavorite(String cafeId);
  Future<List<String>> getFavorites();
}
