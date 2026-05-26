import 'package:flutter/foundation.dart';
import '../../application/cafe/search_cafes_use_case.dart';
import '../../domain/entities/cafe.dart';

class HomeProvider extends ChangeNotifier {
  final SearchCafesUseCase _searchCafesUseCase;

  List<Cafe> _cafes = [];
  bool _isLoading = false;
  String? _error;

  HomeProvider(this._searchCafesUseCase);

  List<Cafe> get cafes => _cafes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> searchCafes({
    required double latitude,
    required double longitude,
    String query = '',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cafes = await _searchCafesUseCase(
        latitude: latitude,
        longitude: longitude,
        query: query,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
