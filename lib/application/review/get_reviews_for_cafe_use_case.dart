import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';

class GetReviewsForCafeUseCase {
  final ReviewRepository _reviewRepository;

  GetReviewsForCafeUseCase(this._reviewRepository);

  Future<List<Review>> call(String cafeId) {
    return _reviewRepository.getReviewsForCafe(cafeId);
  }
}
