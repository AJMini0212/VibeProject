import '../../domain/repositories/follow_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../datasources/firestore_follow_datasource.dart';

class FollowRepositoryImpl implements FollowRepository {
  final FirebaseAuthDatasource _authDatasource;
  final FirestoreFollowDatasource _followDatasource;

  FollowRepositoryImpl({
    required FirebaseAuthDatasource authDatasource,
    required FirestoreFollowDatasource followDatasource,
  })  : _authDatasource = authDatasource,
        _followDatasource = followDatasource;

  @override
  Future<void> followUser(String targetUserId) async {
    try {
      final currentUser = await _authDatasource.getCurrentUser();
      if (currentUser == null) {
        throw Exception('사용자가 로그인되지 않았습니다');
      }
      await _followDatasource.followUser(currentUser.uid, targetUserId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unfollowUser(String targetUserId) async {
    try {
      final currentUser = await _authDatasource.getCurrentUser();
      if (currentUser == null) {
        throw Exception('사용자가 로그인되지 않았습니다');
      }
      await _followDatasource.unfollowUser(currentUser.uid, targetUserId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getFollowers(String userId) async {
    try {
      return await _followDatasource.getFollowers(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getFollowing(String userId) async {
    try {
      return await _followDatasource.getFollowing(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isFollowing(String targetUserId) async {
    try {
      final currentUser = await _authDatasource.getCurrentUser();
      if (currentUser == null) {
        return false;
      }
      return await _followDatasource.isFollowing(currentUser.uid, targetUserId);
    } catch (e) {
      rethrow;
    }
  }
}
