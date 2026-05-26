import '../../domain/repositories/user_repository.dart';

class LogoutUseCase {
  final UserRepository _userRepository;

  LogoutUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<void> call() async {
    return await _userRepository.logout();
  }
}
