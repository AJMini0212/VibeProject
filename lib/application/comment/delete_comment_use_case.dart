import '../../domain/repositories/comment_repository.dart';

class DeleteCommentUseCase {
  final CommentRepository _commentRepository;

  DeleteCommentUseCase({required CommentRepository commentRepository})
      : _commentRepository = commentRepository;

  Future<void> call(String reviewId, String commentId) async {
    return await _commentRepository.deleteComment(reviewId, commentId);
  }
}
