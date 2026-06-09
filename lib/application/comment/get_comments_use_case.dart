import '../../domain/entities/comment.dart';
import '../../domain/repositories/comment_repository.dart';

class GetCommentsUseCase {
  final CommentRepository _commentRepository;

  GetCommentsUseCase({required CommentRepository commentRepository})
      : _commentRepository = commentRepository;

  Future<List<Comment>> call(String reviewId, {int limit = 20}) async {
    return await _commentRepository.getCommentsForReview(reviewId, limit: limit);
  }
}
