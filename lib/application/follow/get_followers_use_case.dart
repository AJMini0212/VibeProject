import '../../domain/repositories/follow_repository.dart';

class GetFollowersUseCase {
  final FollowRepository _followRepository;

  GetFollowersUseCase({required FollowRepository followRepository})
      : _followRepository = followRepository;

  Future<List<String>> call(String userId) async {
    return await _followRepository.getFollowers(userId);
  }
}
