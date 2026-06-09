class ReviewModel {
  final String id;
  final String cafeId;
  final String userId;
  final int rating;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> likedByUserIds;
  final int likeCount;
  final int commentCount;

  ReviewModel({
    required this.id,
    required this.cafeId,
    required this.userId,
    required this.rating,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    this.likedByUserIds = const [],
    this.likeCount = 0,
    this.commentCount = 0,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      cafeId: json['cafeId'] as String,
      userId: json['userId'] as String,
      rating: json['rating'] as int,
      text: json['text'] as String,
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt'] as DateTime
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] is DateTime
          ? json['updatedAt'] as DateTime
          : DateTime.parse(json['updatedAt'] as String),
      likedByUserIds: List<String>.from(json['likedByUserIds'] as List? ?? []),
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cafeId': cafeId,
      'userId': userId,
      'rating': rating,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'likedByUserIds': likedByUserIds,
      'likeCount': likeCount,
      'commentCount': commentCount,
    };
  }
}
