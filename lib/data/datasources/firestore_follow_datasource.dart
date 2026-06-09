abstract class FirestoreFollowDatasource {
  Future<void> followUser(String currentUserId, String targetUserId);
  Future<void> unfollowUser(String currentUserId, String targetUserId);
  Future<List<String>> getFollowers(String userId);
  Future<List<String>> getFollowing(String userId);
  Future<bool> isFollowing(String currentUserId, String targetUserId);
}
