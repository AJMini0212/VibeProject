class ActivityModel {
  final String id;
  final String userId;
  final String type;
  final String targetId;
  final DateTime createdAt;

  ActivityModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.targetId,
    required this.createdAt,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      targetId: json['targetId'] as String,
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt'] as DateTime
          : DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'targetId': targetId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
