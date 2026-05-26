import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class GetCurrentUserUseCase {
  final UserRepository _userRepository;

  GetCurrentUserUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<User?> call() async {
    return await _userRepository.getCurrentUser();
  }
}
