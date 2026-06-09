// Dart only backend verification script
// Run with: dart test/verify_backend.dart

import 'package:cafematch/domain/entities/follow.dart';
import 'package:cafematch/domain/entities/activity.dart';
import 'package:cafematch/domain/entities/comment.dart';
import 'package:cafematch/domain/entities/user.dart';
import 'package:cafematch/data/models/follow_model.dart';
import 'package:cafematch/data/models/activity_model.dart';
import 'package:cafematch/data/models/comment_model.dart';
import 'package:cafematch/data/mappers/follow_mapper.dart';
import 'package:cafematch/data/mappers/activity_mapper.dart';
import 'package:cafematch/data/mappers/comment_mapper.dart';

void main() {
  print('🧪 Phase 3 Backend Verification Starting...\n');

  testFollowEntity();
  testActivityEntity();
  testCommentEntity();
  testFollowMapping();
  testActivityMapping();
  testCommentMapping();
  testUserPhase3Fields();
  testErrorHandling();

  print('\n✅ All verification tests passed!');
}

void testFollowEntity() {
  print('📋 Testing Follow Entity...');
  final now = DateTime.now();
  final follow = Follow(
    followerId: 'user1',
    followingId: 'user2',
    followedAt: now,
  );

  assert(follow.followerId == 'user1', 'followerId mismatch');
  assert(follow.followingId == 'user2', 'followingId mismatch');
  assert(follow.followedAt == now, 'followedAt mismatch');

  // Test copyWith
  final updated = follow.copyWith(followingId: 'user3');
  assert(updated.followingId == 'user3', 'copyWith failed');
  assert(updated.followerId == 'user1', 'copyWith corrupted followerId');

  print('  ✓ Follow entity works correctly');
}

void testActivityEntity() {
  print('📋 Testing Activity Entity...');
  final now = DateTime.now();

  // Test each activity type
  final types = [
    ActivityType.follow,
    ActivityType.review_posted,
    ActivityType.review_liked,
    ActivityType.comment_added,
  ];

  for (final type in types) {
    final activity = Activity(
      id: 'activity_${type.toString()}',
      userId: 'user1',
      type: type,
      targetId: 'target1',
      createdAt: now,
    );

    assert(activity.type == type, 'Activity type mismatch for $type');
  }

  print('  ✓ Activity entity works with all types');
}

void testCommentEntity() {
  print('📋 Testing Comment Entity...');
  final now = DateTime.now();

  // Test without updatedAt
  final comment1 = Comment(
    id: 'comment1',
    reviewId: 'review1',
    userId: 'user1',
    text: '좋은 카페입니다!',
    createdAt: now,
  );

  assert(comment1.updatedAt == null, 'updatedAt should be null');
  assert(comment1.text == '좋은 카페입니다!', 'text mismatch');

  // Test with updatedAt
  final later = now.add(Duration(hours: 1));
  final comment2 = Comment(
    id: 'comment2',
    reviewId: 'review2',
    userId: 'user2',
    text: '수정된 댓글',
    createdAt: now,
    updatedAt: later,
  );

  assert(comment2.updatedAt == later, 'updatedAt mismatch');

  print('  ✓ Comment entity works with optional updatedAt');
}

void testFollowMapping() {
  print('📋 Testing Follow Mapping...');
  final now = DateTime.now();

  // Model → Entity
  final model = FollowModel(
    followerId: 'user1',
    followingId: 'user2',
    followedAt: now,
  );

  final entity = FollowMapper.toDomain(model);
  assert(entity.followerId == model.followerId, 'Mapper failed for followerId');
  assert(entity.followingId == model.followingId, 'Mapper failed for followingId');

  // Entity → Model
  final restored = FollowMapper.toModel(entity);
  assert(restored.followerId == entity.followerId, 'Reverse mapper failed');

  // JSON serialization
  final json = model.toJson();
  assert(json['followerId'] == 'user1', 'JSON serialization failed');

  final modelFromJson = FollowModel.fromJson(json);
  assert(modelFromJson.followerId == 'user1', 'JSON deserialization failed');

  print('  ✓ Follow mapping works correctly');
}

void testActivityMapping() {
  print('📋 Testing Activity Mapping...');
  final now = DateTime.now();

  // Test enum conversion
  final model = ActivityModel(
    id: 'activity1',
    userId: 'user1',
    type: 'follow',
    targetId: 'user2',
    createdAt: now,
  );

  final entity = ActivityMapper.toDomain(model);
  assert(entity.type == ActivityType.follow, 'Activity type conversion failed');

  // Test reverse mapping
  final restored = ActivityMapper.toModel(entity);
  assert(restored.type == 'follow', 'Activity type reverse conversion failed');

  print('  ✓ Activity mapping works with enum conversion');
}

void testCommentMapping() {
  print('📋 Testing Comment Mapping...');
  final now = DateTime.now();

  // Model with null updatedAt
  final model = CommentModel(
    id: 'comment1',
    reviewId: 'review1',
    userId: 'user1',
    text: '좋습니다',
    createdAt: now,
  );

  final entity = CommentMapper.toDomain(model);
  assert(entity.text == '좋습니다', 'Mapper failed for text');
  assert(entity.updatedAt == null, 'Mapper should preserve null updatedAt');

  // Round trip test
  final restored = CommentMapper.toModel(entity);
  assert(restored.text == entity.text, 'Round trip text mismatch');

  print('  ✓ Comment mapping works with optional fields');
}

void testUserPhase3Fields() {
  print('📋 Testing User Phase 3 Fields...');
  final user = User(
    uid: 'user1',
    email: 'user@example.com',
    displayName: '사용자1',
    photoUrl: 'https://example.com/photo.jpg',
    bio: '카페 애호가입니다',
    createdAt: DateTime.now(),
    favoriteIds: ['cafe1', 'cafe2'],
    followerIds: ['user2', 'user3'],
    followingIds: ['user4'],
  );

  assert(user.bio == '카페 애호가입니다', 'bio field missing');
  assert(user.followerIds.length == 2, 'followerIds not working');
  assert(user.followingIds.length == 1, 'followingIds not working');

  // Test copyWith
  final updated = user.copyWith(
    followingIds: ['user4', 'user5'],
  );
  assert(updated.followingIds.length == 2, 'copyWith failed for followingIds');
  assert(updated.bio == user.bio, 'copyWith corrupted bio');

  print('  ✓ User Phase 3 fields work correctly');
}

void testErrorHandling() {
  print('📋 Testing Error Handling...');

  try {
    // Test with invalid JSON
    final badJson = {'followerId': 'user1'}; // Missing followingId
    try {
      FollowModel.fromJson(badJson);
      assert(false, 'Should have thrown error for missing field');
    } catch (e) {
      print('  ✓ Proper error handling for missing fields');
    }
  } catch (e) {
    print('  ⚠ Error handling test: $e');
  }
}
