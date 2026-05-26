import '../../domain/entities/cafe.dart';
import '../../domain/repositories/cafe_repository.dart';
import '../datasources/cafe_local_datasource.dart';
import '../datasources/naver_api_client.dart';
import '../datasources/naver_place_converter.dart';
import '../mappers/cafe_mapper.dart';

class CafeRepositoryImpl implements CafeRepository {
  final NaverApiClient naverApiClient;
  final CafeLocalDatasource localDatasource;

  CafeRepositoryImpl({
    required this.naverApiClient,
    required this.localDatasource,
  });

  @override
  Future<List<Cafe>> searchCafes(
    double latitude,
    double longitude,
    String query,
  ) async {
    try {
      final normalizedQuery = query.isEmpty ? '카페' : query;

      // 1. 캐시 확인 (TTL 유효한 경우)
      final cached = await localDatasource.getCafes(
        normalizedQuery,
        latitude,
        longitude,
      );
      if (cached != null) {
        return CafeMapper.toDomainList(cached);
      }

      // 2. Naver API 호출
      final navItems = await naverApiClient.searchPlaces(
        query: normalizedQuery,
        latitude: latitude,
        longitude: longitude,
      );

      // 3. 응답을 모델로 변환
      final models = NaverPlaceConverter.convertNaverListToModels(navItems);

      // 4. 캐시에 저장
      await localDatasource.saveCafes(normalizedQuery, latitude, longitude, models);

      // 5. 엔티티로 변환 후 반환
      return CafeMapper.toDomainList(models);
    } catch (e) {
      // 네트워크 오류 시 만료된 캐시라도 반환 (오프라인 지원)
      final fallback = await localDatasource.getCafesWithoutExpiry(
        query.isEmpty ? '카페' : query,
        latitude,
        longitude,
      );
      if (fallback != null) {
        return CafeMapper.toDomainList(fallback);
      }
      rethrow;
    }
  }

  @override
  Future<Cafe?> getCafeById(String id) async {
    // TODO: Phase 1.4에서 구현
    return null;
  }
}
