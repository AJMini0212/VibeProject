class Comment {
  final String id;
  final String reviewId;
  final String userId;
  final String text;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Comment({
    required this.id,
    required this.reviewId,
    required this.userId,
    required this.text,
    required this.createdAt,
    this.updatedAt,
  });

  Comment copyWith({
    String? id,
    String? reviewId,
    String? userId,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Comment(
      id: id ?? this.id,
      reviewId: reviewId ?? this.reviewId,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
