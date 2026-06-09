class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? bio;
  final DateTime createdAt;
  final List<String> favoriteIds;
  final List<String> followerIds;
  final List<String> followingIds;

  UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt'] as DateTime
          : DateTime.parse(json['createdAt'] as String),
      favoriteIds: List<String>.from(json['favoriteIds'] as List? ?? []),
      followerIds: List<String>.from(json['followerIds'] as List? ?? []),
      followingIds: List<String>.from(json['followingIds'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
      'favoriteIds': favoriteIds,
      'followerIds': followerIds,
      'followingIds': followingIds,
    };
  }
}
