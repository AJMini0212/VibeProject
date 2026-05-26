import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class LoginUseCase {
  final UserRepository _userRepository;

  LoginUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<User> call(String email, String password) async {
    return await _userRepository.login(email, password);
  }
}
