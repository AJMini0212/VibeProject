import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/review_repository.dart';
import '../../application/follow/get_followers_use_case.dart';
import '../../application/follow/get_following_use_case.dart';

class UserProfileProvider extends ChangeNotifier {
  // State
  User? _user;
  final List<Review> _userReviews = [];
  int _followerCount = 0;
  int _followingCount = 0;
  bool _isLoading = false;
  String? _error;

  // Dependencies
  final UserRepository _userRepository;
  final ReviewRepository _reviewRepository;
  final GetFollowersUseCase _getFollowersUseCase;
  final GetFollowingUseCase _getFollowingUseCase;

  // Getters
  User? get user => _user;
  List<Review> get userReviews => _userReviews;
  int get followerCount => _followerCount;
  int get followingCount => _followingCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  UserProfileProvider({
    required UserRepository userRepository,
    required ReviewRepository reviewRepository,
    required GetFollowersUseCase getFollowersUseCase,
    required GetFollowingUseCase getFollowingUseCase,
  })  : _userRepository = userRepository,
        _reviewRepository = reviewRepository,
        _getFollowersUseCase = getFollowersUseCase,
        _getFollowingUseCase = getFollowingUseCase;

  Future<void> loadUserProfile(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _userRepository.getUserById(userId);
      _error = null;
    } catch (e) {
      _error = '사용자 프로필 로드에 실패했습니다';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserReviews(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final reviews = await _reviewRepository.getReviewsByUserId(userId);
      _userReviews.clear();
      _userReviews.addAll(reviews);
      _error = null;
    } catch (e) {
      _error = '사용자 리뷰 로드에 실패했습니다';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFollowStats(String userId) async {
    try {
      final followers = await _getFollowersUseCase(userId);
      final following = await _getFollowingUseCase(userId);
      _followerCount = followers.length;
      _followingCount = following.length;
      notifyListeners();
    } catch (e) {
      _error = '팔로우 통계 로드에 실패했습니다';
      notifyListeners();
    }
  }
}
