class Review {
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

  Review({
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

  Review copyWith({
    String? id,
    String? cafeId,
    String? userId,
    int? rating,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? likedByUserIds,
    int? likeCount,
    int? commentCount,
  }) {
    return Review(
      id: id ?? this.id,
      cafeId: cafeId ?? this.cafeId,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likedByUserIds: likedByUserIds ?? this.likedByUserIds,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
    );
  }
}
