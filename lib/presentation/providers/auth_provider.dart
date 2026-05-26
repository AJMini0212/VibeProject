import 'package:flutter/material.dart';
import '../../application/auth/login_use_case.dart';
import '../../application/auth/register_use_case.dart';
import '../../application/auth/logout_use_case.dart';
import '../../application/auth/get_current_user_use_case.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class AuthProvider extends ChangeNotifier {
  // State
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  // Dependencies
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final UserRepository _userRepository;

  // Getters
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required UserRepository userRepository,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _userRepository = userRepository;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _loginUseCase(email, password);
      _currentUser = user;
      _isAuthenticated = true;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(
    String email,
    String password,
    String displayName,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _registerUseCase(email, password, displayName);
      _currentUser = user;
      _isAuthenticated = true;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _logoutUseCase();
      _currentUser = null;
      _isAuthenticated = false;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      final user = await _getCurrentUserUseCase();
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
      } else {
        _currentUser = null;
        _isAuthenticated = false;
      }
    } catch (e) {
      _currentUser = null;
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  Future<void> addFavorite(String cafeId) async {
    try {
      await _userRepository.addFavorite(cafeId);
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          favoriteIds: [..._currentUser!.favoriteIds, cafeId],
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String cafeId) async {
    try {
      await _userRepository.removeFavorite(cafeId);
      if (_currentUser != null) {
        final favorites = List<String>.from(_currentUser!.favoriteIds);
        favorites.remove(cafeId);
        _currentUser = _currentUser!.copyWith(favoriteIds: favorites);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  bool isFavorite(String cafeId) {
    return _currentUser?.favoriteIds.contains(cafeId) ?? false;
  }
}
