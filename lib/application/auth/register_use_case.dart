import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class RegisterUseCase {
  final UserRepository _userRepository;

  RegisterUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<User> call(String email, String password, String displayName) async {
    return await _userRepository.register(email, password, displayName);
  }
}
