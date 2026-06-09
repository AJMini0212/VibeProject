import 'package:flutter/material.dart';
import '../../application/follow/follow_user_use_case.dart';
import '../../application/follow/unfollow_user_use_case.dart';
import '../../application/follow/get_followers_use_case.dart';
import '../../application/follow/get_following_use_case.dart';

class FollowProvider extends ChangeNotifier {
  // State
  Set<String> _followingIds = {};
  Set<String> _followerIds = {};
  bool _isLoading = false;
  String? _error;

  // Dependencies
  final FollowUserUseCase _followUserUseCase;
  final UnfollowUserUseCase _unfollowUserUseCase;
  final GetFollowersUseCase _getFollowersUseCase;
  final GetFollowingUseCase _getFollowingUseCase;

  // Getters
  Set<String> get followingIds => _followingIds;
  Set<String> get followerIds => _followerIds;
  bool get isLoading => _isLoading;
  String? get error => _error;

  FollowProvider({
    required FollowUserUseCase followUserUseCase,
    required UnfollowUserUseCase unfollowUserUseCase,
    required GetFollowersUseCase getFollowersUseCase,
    required GetFollowingUseCase getFollowingUseCase,
  })  : _followUserUseCase = followUserUseCase,
        _unfollowUserUseCase = unfollowUserUseCase,
        _getFollowersUseCase = getFollowersUseCase,
        _getFollowingUseCase = getFollowingUseCase;

  Future<void> followUser(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _followUserUseCase(userId);
      _followingIds.add(userId);
      _error = null;
    } catch (e) {
      _error = '사용자 팔로우에 실패했습니다';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> unfollowUser(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _unfollowUserUseCase(userId);
      _followingIds.remove(userId);
      _error = null;
    } catch (e) {
      _error = '사용자 언팔로우에 실패했습니다';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFollowers(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final followers = await _getFollowersUseCase(userId);
      _followerIds = followers.toSet();
      _error = null;
    } catch (e) {
      _error = '팔로워 목록 로드에 실패했습니다';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFollowing(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final following = await _getFollowingUseCase(userId);
      _followingIds = following.toSet();
      _error = null;
    } catch (e) {
      _error = '팔로잉 목록 로드에 실패했습니다';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFollowing(String userId) {
    return _followingIds.contains(userId);
  }
}
