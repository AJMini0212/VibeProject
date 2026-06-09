abstract class FollowRepository {
  Future<void> followUser(String targetUserId);
  Future<void> unfollowUser(String targetUserId);
  Future<List<String>> getFollowers(String userId);
  Future<List<String>> getFollowing(String userId);
  Future<bool> isFollowing(String targetUserId);
}
