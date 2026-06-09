import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';
import 'firestore_review_datasource.dart';

class FirestoreReviewDatasourceImpl implements FirestoreReviewDatasource {
  final FirebaseFirestore _firestore;

  FirestoreReviewDatasourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<void> saveReview(ReviewModel review) async {
    try {
      await _firestore.collection('reviews').doc(review.id).set(
            review.toJson(),
          );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ReviewModel>> getReviewsForCafe(String cafeId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('cafeId', isEqualTo: cafeId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ReviewModel>> getReviewsByUserId(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateReview(String reviewId, int rating, String text) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).update(
        {
          'rating': rating,
          'text': text,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
