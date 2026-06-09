import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../datasources/firestore_user_datasource.dart';
import '../mappers/user_mapper.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuthDatasource _authDatasource;
  final FirestoreUserDatasource _userDatasource;

  UserRepositoryImpl({
    required FirebaseAuthDatasource authDatasource,
    required FirestoreUserDatasource userDatasource,
  })  : _authDatasource = authDatasource,
        _userDatasource = userDatasource;

  @override
  Future<User> login(String email, String password) async {
    try {
      final userModel = await _authDatasource.signIn(email, password);
      return UserMapper.toDomain(userModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> register(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final userModel = await _authDatasource.signUp(email, password, displayName);
      return UserMapper.toDomain(userModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authDatasource.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userModel = await _authDatasource.getCurrentUser();
      if (userModel == null) {
        return null;
      }
      return UserMapper.toDomain(userModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> getUserById(String userId) async {
    try {
      final userModel = await _userDatasource.getUserById(userId);
      if (userModel == null) {
        return null;
      }
      return UserMapper.toDomain(userModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    try {
      final userModels = await _userDatasource.searchUsers(query);
      return userModels.map((model) => UserMapper.toDomain(model)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(String? displayName, String? photoUrl) async {
    // TODO: Implement profile update
    throw UnimplementedError();
  }

  @override
  Future<void> addFavorite(String cafeId) async {
    try {
      final currentUser = await _authDatasource.getCurrentUser();
      if (currentUser == null) {
        throw Exception('사용자가 로그인되지 않았습니다');
      }
      await _userDatasource.addFavorite(currentUser.uid, cafeId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFavorite(String cafeId) async {
    try {
      final currentUser = await _authDatasource.getCurrentUser();
      if (currentUser == null) {
        throw Exception('사용자가 로그인되지 않았습니다');
      }
      await _userDatasource.removeFavorite(currentUser.uid, cafeId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getFavorites() async {
    try {
      final currentUser = await _authDatasource.getCurrentUser();
      if (currentUser == null) {
        return [];
      }
      return await _userDatasource.getFavorites(currentUser.uid);
    } catch (e) {
      rethrow;
    }
  }
}
