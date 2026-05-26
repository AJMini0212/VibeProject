import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../application/cafe/search_cafes_use_case.dart';
import '../../core/services/location_service.dart';
import '../../domain/entities/cafe.dart';

class HomeProvider extends ChangeNotifier {
  final SearchCafesUseCase _searchCafesUseCase;
  final LocationService _locationService;

  List<Cafe> _cafes = [];
  bool _isLoading = false;
  String? _error;

  LatLng? _currentLocation;
  bool _isLoadingLocation = false;
  String? _locationError;

  HomeProvider(this._searchCafesUseCase, this._locationService);

  List<Cafe> get cafes => _cafes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  LatLng? get currentLocation => _currentLocation;
  bool get isLoadingLocation => _isLoadingLocation;
  String? get locationError => _locationError;

  Future<void> getCurrentLocation() async {
    _isLoadingLocation = true;
    _locationError = null;
    notifyListeners();

    try {
      final location = await _locationService.getCurrentLocation();
      _currentLocation = location;
      if (location != null) {
        await searchCafes(
          latitude: location.latitude,
          longitude: location.longitude,
          query: '',
        );
      } else {
        _locationError = '위치 권한이 거부되었습니다';
      }
    } catch (e) {
      _locationError = e.toString();
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

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
