enum ActivityType {
  follow,
  review_posted,
  review_liked,
  comment_added,
}

class Activity {
  final String id;
  final String userId;
  final ActivityType type;
  final String targetId;
  final DateTime createdAt;

  const Activity({
    required this.id,
    required this.userId,
    required this.type,
    required this.targetId,
    required this.createdAt,
  });

  Activity copyWith({
    String? id,
    String? userId,
    ActivityType? type,
    String? targetId,
    DateTime? createdAt,
  }) {
    return Activity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      targetId: targetId ?? this.targetId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
