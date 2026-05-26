import 'package:flutter/foundation.dart';
import '../../domain/entities/review.dart';
import '../../application/review/create_review_use_case.dart';
import '../../application/review/get_reviews_for_cafe_use_case.dart';
import '../../application/review/delete_review_use_case.dart';

class ReviewProvider extends ChangeNotifier {
  final CreateReviewUseCase _createReviewUseCase;
  final GetReviewsForCafeUseCase _getReviewsForCafeUseCase;
  final DeleteReviewUseCase _deleteReviewUseCase;

  List<Review> _reviews = [];
  bool _isLoading = false;
  String? _error;
  String? _currentCafeId;

  ReviewProvider(
    this._createReviewUseCase,
    this._getReviewsForCafeUseCase,
    this._deleteReviewUseCase,
  );

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadReviewsForCafe(String cafeId) async {
    _currentCafeId = cafeId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reviews = await _getReviewsForCafeUseCase(cafeId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = '리뷰를 불러올 수 없습니다: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createReview(String cafeId, int rating, String text) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _createReviewUseCase(cafeId, rating, text);
      await loadReviewsForCafe(cafeId);
    } catch (e) {
      _error = '리뷰 작성에 실패했습니다: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteReview(String reviewId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _deleteReviewUseCase(reviewId);
      if (_currentCafeId != null) {
        await loadReviewsForCafe(_currentCafeId!);
      }
    } catch (e) {
      _error = '리뷰 삭제에 실패했습니다: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
}
