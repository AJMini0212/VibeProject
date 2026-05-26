import '../../domain/entities/cafe.dart';
import '../../domain/repositories/cafe_repository.dart';
import '../mappers/cafe_mapper.dart';
import '../models/cafe_model.dart';

class CafeRepositoryImpl implements CafeRepository {
  @override
  Future<List<Cafe>> searchCafes(
    double latitude,
    double longitude,
    String query,
  ) async {
    // TODO: Phase 1.3에서 Naver API 호출로 구현
    // 현재는 mock 데이터 반환
    final mockData = [
      CafeModel(
        id: '1',
        name: '카페 명불허전',
        address: '서울시 강남구 테헤란로',
        latitude: 37.4979,
        longitude: 127.0276,
        rating: 4.5,
        reviewCount: 42,
      ),
      CafeModel(
        id: '2',
        name: '라떼 라이프',
        address: '서울시 강남구 논현로',
        latitude: 37.4968,
        longitude: 127.0371,
        rating: 4.3,
        reviewCount: 28,
      ),
    ];
    return CafeMapper.toDomainList(mockData);
  }

  @override
  Future<Cafe?> getCafeById(String id) async {
    // TODO: Phase 1.3에서 구현
    return null;
  }
}
