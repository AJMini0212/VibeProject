import '../models/review_model.dart';

abstract class FirestoreReviewDatasource {
  Future<void> saveReview(ReviewModel review);
  Future<List<ReviewModel>> getReviewsForCafe(String cafeId);
  Future<void> deleteReview(String reviewId);
  Future<void> updateReview(String reviewId, int rating, String text);
}
