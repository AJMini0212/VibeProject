class ReviewModel {
  final String id;
  final String cafeId;
  final String userId;
  final int rating;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewModel({
    required this.id,
    required this.cafeId,
    required this.userId,
    required this.rating,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
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
    };
  }
}
