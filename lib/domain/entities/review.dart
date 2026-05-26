class Review {
  final String id;
  final String cafeId;
  final String userId;
  final int rating;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.cafeId,
    required this.userId,
    required this.rating,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  Review copyWith({
    String? id,
    String? cafeId,
    String? userId,
    int? rating,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Review(
      id: id ?? this.id,
      cafeId: cafeId ?? this.cafeId,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
