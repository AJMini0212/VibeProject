class FollowModel {
  final String followerId;
  final String followingId;
  final DateTime followedAt;

  FollowModel({
    required this.followerId,
    required this.followingId,
    required this.followedAt,
  });

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    return FollowModel(
      followerId: json['followerId'] as String,
      followingId: json['followingId'] as String,
      followedAt: json['followedAt'] is DateTime
          ? json['followedAt'] as DateTime
          : DateTime.parse(json['followedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'followerId': followerId,
      'followingId': followingId,
      'followedAt': followedAt.toIso8601String(),
    };
  }
}
