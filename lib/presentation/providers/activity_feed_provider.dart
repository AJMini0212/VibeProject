import 'package:flutter/material.dart';
import '../../application/activity/get_activity_feed_use_case.dart';
import '../../domain/entities/activity.dart';

class ActivityFeedProvider extends ChangeNotifier {
  // State
  List<Activity> _activities = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DateTime? _lastTimestamp;
  String? _error;

  // Dependencies
  final GetActivityFeedUseCase _getActivityFeedUseCase;
  static const int _pageSize = 20;

  // Getters
  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  ActivityFeedProvider({
    required GetActivityFeedUseCase getActivityFeedUseCase,
  }) : _getActivityFeedUseCase = getActivityFeedUseCase;

  Future<void> loadActivityFeed() async {
    _isLoading = true;
    _error = null;
    _activities = [];
    _lastTimestamp = null;
    _hasMore = true;
    notifyListeners();

    try {
      final activities = await _getActivityFeedUseCase(_pageSize);
      _activities = activities;
      _hasMore = activities.length == _pageSize;
      if (_activities.isNotEmpty) {
        _lastTimestamp = _activities.last.createdAt;
      }
      _error = null;
    } catch (e) {
      _error = '활동 피드 로드에 실패했습니다';
      _activities = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreActivities() async {
    if (_isLoading || !_hasMore || _lastTimestamp == null) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final activities = await _getActivityFeedUseCase(
        _pageSize,
        cursor: _lastTimestamp,
      );
      _activities.addAll(activities);
      _hasMore = activities.length == _pageSize;
      if (activities.isNotEmpty) {
        _lastTimestamp = activities.last.createdAt;
      }
      _error = null;
    } catch (e) {
      _error = '추가 활동 로드에 실패했습니다';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshFeed() async {
    await loadActivityFeed();
  }
}
