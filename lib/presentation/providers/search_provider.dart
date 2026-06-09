import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class SearchProvider extends ChangeNotifier {
  final UserRepository _userRepository;

  List<User> _searchResults = [];
  bool _isLoading = false;
  String? _error;
  String _lastQuery = '';

  SearchProvider({required UserRepository userRepository})
      : _userRepository = userRepository;

  List<User> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasSearched => _lastQuery.isNotEmpty;

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      _lastQuery = '';
      _error = null;
      notifyListeners();
      return;
    }

    if (query == _lastQuery) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _searchResults = await _userRepository.searchUsers(query);
      _lastQuery = query;
      _error = null;
    } catch (e) {
      _error = '사용자 검색에 실패했습니다';
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    _lastQuery = '';
    _error = null;
    notifyListeners();
  }
}
