import '../../domain/repositories/follow_repository.dart';

class UnfollowUserUseCase {
  final FollowRepository _followRepository;

  UnfollowUserUseCase({required FollowRepository followRepository})
      : _followRepository = followRepository;

  Future<void> call(String targetUserId) async {
    return await _followRepository.unfollowUser(targetUserId);
  }
}
