import '../entities/comment.dart';

abstract class CommentRepository {
  Future<void> addComment(String reviewId, String text);
  Future<List<Comment>> getCommentsForReview(String reviewId, {int limit = 20});
  Future<void> deleteComment(String reviewId, String commentId);
  Future<void> updateComment(String reviewId, String commentId, String newText);
}
