import '../../domain/entities/comment.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../datasources/firestore_comment_datasource.dart';
import '../mappers/comment_mapper.dart';
import '../models/comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentRepositoryImpl implements CommentRepository {
  final FirebaseAuthDatasource _authDatasource;
  final FirestoreCommentDatasource _commentDatasource;
  final FirebaseFirestore _firestore;

  CommentRepositoryImpl({
    required FirebaseAuthDatasource authDatasource,
    required FirestoreCommentDatasource commentDatasource,
    required FirebaseFirestore firestore,
  })  : _authDatasource = authDatasource,
        _commentDatasource = commentDatasource,
        _firestore = firestore;

  @override
  Future<void> addComment(String reviewId, String text) async {
    try {
      final currentUser = await _authDatasource.getCurrentUser();
      if (currentUser == null) {
        throw Exception('사용자가 로그인되지 않았습니다');
      }

      final commentId = _firestore.collection('comments').doc().id;
      final now = DateTime.now();
      final commentModel = CommentModel(
        id: commentId,
        reviewId: reviewId,
        userId: currentUser.uid,
        text: text,
        createdAt: now,
        updatedAt: now,
      );

      await _commentDatasource.addComment(commentModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Comment>> getCommentsForReview(
    String reviewId, {
    int limit = 20,
  }) async {
    try {
      final models =
          await _commentDatasource.getCommentsForReview(reviewId, limit: limit);
      return CommentMapper.toDomainList(models);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteComment(String reviewId, String commentId) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // Delete comment
        transaction.delete(
          _firestore
              .collection('reviews')
              .doc(reviewId)
              .collection('comments')
              .doc(commentId),
        );

        // Decrement commentCount in review
        transaction.update(
          _firestore.collection('reviews').doc(reviewId),
          {
            'commentCount': FieldValue.increment(-1),
          },
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateComment(
    String reviewId,
    String commentId,
    String newText,
  ) async {
    try {
      await _firestore
          .collection('reviews')
          .doc(reviewId)
          .collection('comments')
          .doc(commentId)
          .update({
        'text': newText,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }
}
