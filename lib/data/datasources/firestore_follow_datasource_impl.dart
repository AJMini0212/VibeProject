import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_follow_datasource.dart';

class FirestoreFollowDatasourceImpl implements FirestoreFollowDatasource {
  final FirebaseFirestore _firestore;

  FirestoreFollowDatasourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<void> followUser(String currentUserId, String targetUserId) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // Add targetUserId to currentUser's followingIds
        transaction.update(
          _firestore.collection('users').doc(currentUserId),
          {
            'followingIds': FieldValue.arrayUnion([targetUserId]),
          },
        );

        // Add currentUserId to targetUser's followerIds
        transaction.update(
          _firestore.collection('users').doc(targetUserId),
          {
            'followerIds': FieldValue.arrayUnion([currentUserId]),
          },
        );

        // Create Follow document
        final followDocId = '$currentUserId-$targetUserId';
        transaction.set(
          _firestore.collection('follows').doc(followDocId),
          {
            'followerId': currentUserId,
            'followingId': targetUserId,
            'followedAt': DateTime.now().toIso8601String(),
          },
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // Remove targetUserId from currentUser's followingIds
        transaction.update(
          _firestore.collection('users').doc(currentUserId),
          {
            'followingIds': FieldValue.arrayRemove([targetUserId]),
          },
        );

        // Remove currentUserId from targetUser's followerIds
        transaction.update(
          _firestore.collection('users').doc(targetUserId),
          {
            'followerIds': FieldValue.arrayRemove([currentUserId]),
          },
        );

        // Delete Follow document
        final followDocId = '$currentUserId-$targetUserId';
        transaction.delete(
          _firestore.collection('follows').doc(followDocId),
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getFollowers(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        return [];
      }
      final followerIds = doc.get('followerIds') as List<dynamic>?;
      return (followerIds ?? []).map((id) => id as String).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getFollowing(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        return [];
      }
      final followingIds = doc.get('followingIds') as List<dynamic>?;
      return (followingIds ?? []).map((id) => id as String).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    try {
      final doc = await _firestore.collection('users').doc(currentUserId).get();
      if (!doc.exists) {
        return false;
      }
      final followingIds = doc.get('followingIds') as List<dynamic>?;
      return (followingIds ?? []).contains(targetUserId);
    } catch (e) {
      rethrow;
    }
  }
}
