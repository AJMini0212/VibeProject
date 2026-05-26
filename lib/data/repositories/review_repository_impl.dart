import 'package:uuid/uuid.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/firestore_review_datasource.dart';
import '../mappers/review_mapper.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final FirestoreReviewDatasource _reviewDatasource;

  ReviewRepositoryImpl({
    required FirestoreReviewDatasource reviewDatasource,
  }) : _reviewDatasource = reviewDatasource;

  @override
  Future<void> createReview(
    String cafeId,
    int rating,
    String text,
  ) async {
    try {
      final reviewId = const Uuid().v4();
      final now = DateTime.now();

      final reviewModel = ReviewModel(
        id: reviewId,
        cafeId: cafeId,
        userId: '', // Will be set by AuthProvider
        rating: rating,
        text: text,
        createdAt: now,
        updatedAt: now,
      );

      await _reviewDatasource.saveReview(reviewModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Review>> getReviewsForCafe(String cafeId) async {
    try {
      final reviewModels = await _reviewDatasource.getReviewsForCafe(cafeId);
      return ReviewMapper.toDomainList(reviewModels);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    try {
      await _reviewDatasource.deleteReview(reviewId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateReview(String reviewId, int rating, String text) async {
    try {
      await _reviewDatasource.updateReview(reviewId, rating, text);
    } catch (e) {
      rethrow;
    }
  }
}
