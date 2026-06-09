import '../models/comment_model.dart';

abstract class FirestoreCommentDatasource {
  Future<void> addComment(CommentModel comment);
  Future<List<CommentModel>> getCommentsForReview(
    String reviewId, {
    int limit = 20,
  });
  Future<void> deleteComment(String commentId);
  Future<void> updateComment(String commentId, String newText);
}
