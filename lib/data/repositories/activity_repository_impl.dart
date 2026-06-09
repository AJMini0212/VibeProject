import '../../domain/entities/activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../datasources/firestore_activity_datasource.dart';
import '../mappers/activity_mapper.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final FirebaseAuthDatasource _authDatasource;
  final FirestoreActivityDatasource _activityDatasource;

  ActivityRepositoryImpl({
    required FirebaseAuthDatasource authDatasource,
    required FirestoreActivityDatasource activityDatasource,
  })  : _authDatasource = authDatasource,
        _activityDatasource = activityDatasource;

  @override
  Future<void> createActivity(Activity activity) async {
    try {
      final model = ActivityMapper.toModel(activity);
      await _activityDatasource.createActivity(model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Activity>> getActivityFeed(int limit, {DateTime? cursor}) async {
    try {
      final currentUser = await _authDatasource.getCurrentUser();
      if (currentUser == null) {
        return [];
      }
      final models = await _activityDatasource.getActivityFeed(
        currentUser.uid,
        limit,
        cursor: cursor,
      );
      return ActivityMapper.toDomainList(models);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteActivity(String activityId) async {
    try {
      await _activityDatasource.deleteActivity(activityId);
    } catch (e) {
      rethrow;
    }
  }
}
