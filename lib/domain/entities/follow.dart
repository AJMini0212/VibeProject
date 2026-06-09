class Follow {
  final String followerId;
  final String followingId;
  final DateTime followedAt;

  const Follow({
    required this.followerId,
    required this.followingId,
    required this.followedAt,
  });

  Follow copyWith({
    String? followerId,
    String? followingId,
    DateTime? followedAt,
  }) {
    return Follow(
      followerId: followerId ?? this.followerId,
      followingId: followingId ?? this.followingId,
      followedAt: followedAt ?? this.followedAt,
    );
  }
}
