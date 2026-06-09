import '../../domain/repositories/follow_repository.dart';

class FollowUserUseCase {
  final FollowRepository _followRepository;

  FollowUserUseCase({required FollowRepository followRepository})
      : _followRepository = followRepository;

  Future<void> call(String targetUserId) async {
    return await _followRepository.followUser(targetUserId);
  }
}
