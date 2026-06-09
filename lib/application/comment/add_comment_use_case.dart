import '../../domain/repositories/comment_repository.dart';

class AddCommentUseCase {
  final CommentRepository _commentRepository;

  AddCommentUseCase({required CommentRepository commentRepository})
      : _commentRepository = commentRepository;

  Future<void> call(String reviewId, String text) async {
    return await _commentRepository.addComment(reviewId, text);
  }
}
