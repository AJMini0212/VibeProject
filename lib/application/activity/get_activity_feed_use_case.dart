import '../../domain/entities/activity.dart';
import '../../domain/repositories/activity_repository.dart';

class GetActivityFeedUseCase {
  final ActivityRepository _activityRepository;

  GetActivityFeedUseCase({required ActivityRepository activityRepository})
      : _activityRepository = activityRepository;

  Future<List<Activity>> call(int limit, {DateTime? cursor}) async {
    return await _activityRepository.getActivityFeed(limit, cursor: cursor);
  }
}
