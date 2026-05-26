import '../entities/review.dart';

abstract class ReviewRepository {
  Future<void> createReview(String cafeId, int rating, String text);
  Future<List<Review>> getReviewsForCafe(String cafeId);
  Future<void> deleteReview(String reviewId);
  Future<void> updateReview(String reviewId, int rating, String text);
}
