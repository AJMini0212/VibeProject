import '../../domain/repositories/follow_repository.dart';

class GetFollowingUseCase {
  final FollowRepository _followRepository;

  GetFollowingUseCase({required FollowRepository followRepository})
      : _followRepository = followRepository;

  Future<List<String>> call(String userId) async {
    return await _followRepository.getFollowing(userId);
  }
}
