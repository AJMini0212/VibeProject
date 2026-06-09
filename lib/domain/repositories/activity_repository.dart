import '../entities/activity.dart';

abstract class ActivityRepository {
  Future<void> createActivity(Activity activity);
  Future<List<Activity>> getActivityFeed(int limit, {DateTime? cursor});
  Future<void> deleteActivity(String activityId);
}
