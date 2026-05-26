import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../application/cafe/search_cafes_use_case.dart';
import '../../core/services/location_service.dart';
import '../../core/utils/distance_calculator.dart';
import '../../domain/entities/cafe.dart';

enum SortType { distance, rating, reviewCount }

class HomeProvider extends ChangeNotifier {
  final SearchCafesUseCase _searchCafesUseCase;
  final LocationService _locationService;

  // 기본 상태
  List<Cafe> _cafes = [];
  bool _isLoading = false;
  String? _error;

  // 위치 관련
  LatLng? _currentLocation;
  bool _isLoadingLocation = false;
  String? _locationError;

  // 검색/필터 상태
  String _searchQuery = '';
  double _minRating = 0.0;
  double _maxDistance = 100.0;
  int _minReviewCount = 0;
  SortType _sortType = SortType.distance;
  List<Cafe> _filteredCafes = [];

  HomeProvider(this._searchCafesUseCase, this._locationService);

  // 기본 getter
  List<Cafe> get cafes => _cafes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 위치 getter
  LatLng? get currentLocation => _currentLocation;
  bool get isLoadingLocation => _isLoadingLocation;
  String? get locationError => _locationError;

  // 검색/필터 getter
  String get searchQuery => _searchQuery;
  double get minRating => _minRating;
  double get maxDistance => _maxDistance;
  int get minReviewCount => _minReviewCount;
  SortType get sortType => _sortType;
  List<Cafe> get filteredCafes => _filteredCafes;
  int get resultCount => _filteredCafes.length;

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

  // 검색어 업데이트
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFiltersAndSort();
  }

  // 최소 평점 설정
  void setMinRating(double rating) {
    _minRating = rating;
    _applyFiltersAndSort();
  }

  // 최대 거리 설정
  void setMaxDistance(double km) {
    _maxDistance = km;
    _applyFiltersAndSort();
  }

  // 최소 리뷰 수 설정
  void setMinReviewCount(int count) {
    _minReviewCount = count;
    _applyFiltersAndSort();
  }

  // 정렬 방식 설정
  void setSortType(SortType type) {
    _sortType = type;
    _applyFiltersAndSort();
  }

  // 모든 필터 초기화
  void resetFilters() {
    _searchQuery = '';
    _minRating = 0.0;
    _maxDistance = 100.0;
    _minReviewCount = 0;
    _sortType = SortType.distance;
    _applyFiltersAndSort();
  }

  // 내부: 필터/정렬 적용
  void _applyFiltersAndSort() {
    // 1. 검색어 필터링 (카페명, 주소)
    var result = _cafes.where((cafe) {
      if (_searchQuery.isEmpty) return true;
      return cafe.name.toLowerCase().contains(_searchQuery) ||
          cafe.address.toLowerCase().contains(_searchQuery);
    }).toList();

    // 2. 평점 필터링
    result = result.where((cafe) => cafe.rating >= _minRating).toList();

    // 3. 리뷰 수 필터링
    result = result.where((cafe) => cafe.reviewCount >= _minReviewCount).toList();

    // 4. 거리 필터링 (GPS 위치가 있을 때만)
    if (_currentLocation != null) {
      result = result.where((cafe) {
        final distance = DistanceCalculator.getDistance(
          _currentLocation!.latitude,
          _currentLocation!.longitude,
          cafe.latitude,
          cafe.longitude,
        );
        return distance <= _maxDistance;
      }).toList();
    }

    // 5. 정렬
    switch (_sortType) {
      case SortType.distance:
        if (_currentLocation != null) {
          result.sort((a, b) {
            final distA = DistanceCalculator.getDistance(
              _currentLocation!.latitude,
              _currentLocation!.longitude,
              a.latitude,
              a.longitude,
            );
            final distB = DistanceCalculator.getDistance(
              _currentLocation!.latitude,
              _currentLocation!.longitude,
              b.latitude,
              b.longitude,
            );
            return distA.compareTo(distB);
          });
        }
        break;
      case SortType.rating:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortType.reviewCount:
        result.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }

    _filteredCafes = result;
    notifyListeners();
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
      // API에서 데이터를 받은 후 필터/정렬 적용
      _applyFiltersAndSort();
    } catch (e) {
      _error = e.toString();
      _filteredCafes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
