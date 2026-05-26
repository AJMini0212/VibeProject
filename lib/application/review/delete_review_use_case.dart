import '../../domain/repositories/review_repository.dart';

class DeleteReviewUseCase {
  final ReviewRepository _reviewRepository;

  DeleteReviewUseCase(this._reviewRepository);

  Future<void> call(String reviewId) {
    return _reviewRepository.deleteReview(reviewId);
  }
}
