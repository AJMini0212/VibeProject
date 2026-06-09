import 'package:flutter/material.dart';
import '../../application/comment/add_comment_use_case.dart';
import '../../application/comment/get_comments_use_case.dart';
import '../../application/comment/delete_comment_use_case.dart';
import '../../domain/entities/comment.dart';

class CommentProvider extends ChangeNotifier {
  // State
  final Map<String, List<Comment>> _commentsByReview = {};
  bool _isLoading = false;
  String? _error;

  // Dependencies
  final AddCommentUseCase _addCommentUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;

  // Getters
  Map<String, List<Comment>> get commentsByReview => _commentsByReview;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CommentProvider({
    required AddCommentUseCase addCommentUseCase,
    required GetCommentsUseCase getCommentsUseCase,
    required DeleteCommentUseCase deleteCommentUseCase,
  })  : _addCommentUseCase = addCommentUseCase,
        _getCommentsUseCase = getCommentsUseCase,
        _deleteCommentUseCase = deleteCommentUseCase;

  Future<void> loadComments(String reviewId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final comments = await _getCommentsUseCase(reviewId);
      _commentsByReview[reviewId] = comments;
      _error = null;
    } catch (e) {
      _error = '댓글 로드에 실패했습니다';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addComment(String reviewId, String text) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _addCommentUseCase(reviewId, text);
      // Reload comments for this review
      await loadComments(reviewId);
      _error = null;
    } catch (e) {
      _error = '댓글 작성에 실패했습니다';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteComment(String reviewId, String commentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _deleteCommentUseCase(reviewId, commentId);
      // Remove from local state
      _commentsByReview[reviewId]?.removeWhere((c) => c.id == commentId);
      _error = null;
    } catch (e) {
      _error = '댓글 삭제에 실패했습니다';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Comment> getCommentsForReview(String reviewId) {
    return _commentsByReview[reviewId] ?? [];
  }
}
