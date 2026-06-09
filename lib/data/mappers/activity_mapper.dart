import '../../domain/entities/activity.dart';
import '../models/activity_model.dart';

class ActivityMapper {
  static Activity toDomain(ActivityModel model) {
    return Activity(
      id: model.id,
      userId: model.userId,
      type: _stringToActivityType(model.type),
      targetId: model.targetId,
      createdAt: model.createdAt,
    );
  }

  static ActivityModel toModel(Activity entity) {
    return ActivityModel(
      id: entity.id,
      userId: entity.userId,
      type: _activityTypeToString(entity.type),
      targetId: entity.targetId,
      createdAt: entity.createdAt,
    );
  }

  static List<Activity> toDomainList(List<ActivityModel> models) {
    return models.map(toDomain).toList();
  }

  static List<ActivityModel> toModelList(List<Activity> entities) {
    return entities.map(toModel).toList();
  }

  static ActivityType _stringToActivityType(String value) {
    switch (value) {
      case 'follow':
        return ActivityType.follow;
      case 'review_posted':
        return ActivityType.review_posted;
      case 'review_liked':
        return ActivityType.review_liked;
      case 'comment_added':
        return ActivityType.comment_added;
      default:
        return ActivityType.follow;
    }
  }

  static String _activityTypeToString(ActivityType type) {
    switch (type) {
      case ActivityType.follow:
        return 'follow';
      case ActivityType.review_posted:
        return 'review_posted';
      case ActivityType.review_liked:
        return 'review_liked';
      case ActivityType.comment_added:
        return 'comment_added';
    }
  }
}
