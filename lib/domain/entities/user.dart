class User {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? bio;
  final DateTime createdAt;
  final List<String> favoriteIds;
  final List<String> followerIds;
  final List<String> followingIds;

  User({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.bio,
    required this.createdAt,
    required this.favoriteIds,
    required this.followerIds,
    required this.followingIds,
  });

  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? bio,
    DateTime? createdAt,
    List<String>? favoriteIds,
    List<String>? followerIds,
    List<String>? followingIds,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      followerIds: followerIds ?? this.followerIds,
      followingIds: followingIds ?? this.followingIds,
    );
  }
}
