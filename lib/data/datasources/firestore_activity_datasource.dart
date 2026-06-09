import '../models/activity_model.dart';

abstract class FirestoreActivityDatasource {
  Future<void> createActivity(ActivityModel activity);
  Future<List<ActivityModel>> getActivityFeed(
    String userId,
    int limit, {
    DateTime? cursor,
  });
  Future<void> deleteActivity(String activityId);
}
