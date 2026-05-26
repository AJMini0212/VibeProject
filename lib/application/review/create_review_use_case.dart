import '../../domain/repositories/review_repository.dart';

class CreateReviewUseCase {
  final ReviewRepository _reviewRepository;

  CreateReviewUseCase(this._reviewRepository);

  Future<void> call(String cafeId, int rating, String text) {
    return _reviewRepository.createReview(cafeId, rating, text);
  }
}
