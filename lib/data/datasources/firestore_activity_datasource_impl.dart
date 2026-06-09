import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity_model.dart';
import 'firestore_activity_datasource.dart';

class FirestoreActivityDatasourceImpl implements FirestoreActivityDatasource {
  final FirebaseFirestore _firestore;

  FirestoreActivityDatasourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<void> createActivity(ActivityModel activity) async {
    try {
      await _firestore.collection('activities').doc(activity.id).set(
            activity.toJson(),
          );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ActivityModel>> getActivityFeed(
    String userId,
    int limit, {
    DateTime? cursor,
  }) async {
    try {
      // Get the list of users that the current user is following
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        return [];
      }
      final followingIds =
          List<String>.from(userDoc.get('followingIds') as List? ?? []);

      if (followingIds.isEmpty) {
        return [];
      }

      // Query activities from following users
      var query = _firestore
          .collection('activities')
          .where('userId', whereIn: followingIds)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      // Apply cursor-based pagination
      if (cursor != null) {
        query = query.startAfter([cursor.toIso8601String()]);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => ActivityModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteActivity(String activityId) async {
    try {
      await _firestore.collection('activities').doc(activityId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
