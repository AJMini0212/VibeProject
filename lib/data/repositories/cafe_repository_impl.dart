import '../../domain/entities/cafe.dart';
import '../../domain/repositories/cafe_repository.dart';
import '../datasources/cafe_local_datasource.dart';
import '../datasources/naver_api_client.dart';
import '../datasources/naver_place_converter.dart';
import '../mappers/cafe_mapper.dart';
import '../models/cafe_model.dart';

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
    // Phase 1.4: 임시 Mock 데이터 사용 (필터링 UI 테스트용)
    // TODO: 백엔드 구축 후 Naver API 호출로 복구
    // 원본 코드는 아래 주석 처리됨

    try {
      final mockCafes = _getMockCafes();
      return CafeMapper.toDomainList(mockCafes);
    } catch (e) {
      rethrow;
    }

    /* [원본 Naver API 코드 - 백엔드 구축 후 복구]
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
    */
  }

  // Mock 데이터: Phase 1.4 필터링 UI 테스트용
  List<CafeModel> _getMockCafes() {
    return [
      CafeModel(
        id: '1',
        name: '라떼 라이프',
        address: '서울시 강남구 논현로 100',
        latitude: 37.4968,
        longitude: 127.0371,
        rating: 4.8,
        reviewCount: 128,
      ),
      CafeModel(
        id: '2',
        name: '명불허전 카페',
        address: '서울시 강남구 테헤란로 50',
        latitude: 37.4979,
        longitude: 127.0276,
        rating: 4.6,
        reviewCount: 95,
      ),
      CafeModel(
        id: '3',
        name: '느린 오후',
        address: '서울시 강남구 봉은사로 200',
        latitude: 37.4950,
        longitude: 127.0400,
        rating: 4.7,
        reviewCount: 156,
      ),
      CafeModel(
        id: '4',
        name: '콩블리',
        address: '서울시 강남구 강남대로 300',
        latitude: 37.4960,
        longitude: 127.0250,
        rating: 4.4,
        reviewCount: 87,
      ),
      CafeModel(
        id: '5',
        name: '카페모모',
        address: '서울시 강남구 논현로 85',
        latitude: 37.4975,
        longitude: 127.0365,
        rating: 4.5,
        reviewCount: 112,
      ),
      CafeModel(
        id: '6',
        name: '더카페',
        address: '서울시 강남구 테헤란로 150',
        latitude: 37.4985,
        longitude: 127.0300,
        rating: 4.3,
        reviewCount: 64,
      ),
      CafeModel(
        id: '7',
        name: '벙커카페',
        address: '서울시 강남구 봉은사로 150',
        latitude: 37.4940,
        longitude: 127.0420,
        rating: 4.9,
        reviewCount: 189,
      ),
      CafeModel(
        id: '8',
        name: '브로우파더',
        address: '서울시 강남구 강남대로 100',
        latitude: 37.4970,
        longitude: 127.0280,
        rating: 4.2,
        reviewCount: 71,
      ),
      CafeModel(
        id: '9',
        name: '카페독',
        address: '서울시 강남구 논현로 200',
        latitude: 37.4955,
        longitude: 127.0380,
        rating: 4.6,
        reviewCount: 143,
      ),
      CafeModel(
        id: '10',
        name: '스테디',
        address: '서울시 강남구 테헤란로 250',
        latitude: 37.4990,
        longitude: 127.0320,
        rating: 4.4,
        reviewCount: 98,
      ),
      CafeModel(
        id: '11',
        name: '옥토버',
        address: '서울시 강남구 봉은사로 100',
        latitude: 37.4945,
        longitude: 127.0390,
        rating: 4.7,
        reviewCount: 167,
      ),
      CafeModel(
        id: '12',
        name: '카페일루',
        address: '서울시 강남구 강남대로 200',
        latitude: 37.4965,
        longitude: 127.0240,
        rating: 4.1,
        reviewCount: 52,
      ),
      CafeModel(
        id: '13',
        name: '더블루카페',
        address: '서울시 강남구 논현로 150',
        latitude: 37.4980,
        longitude: 127.0360,
        rating: 4.8,
        reviewCount: 201,
      ),
      CafeModel(
        id: '14',
        name: '에스프레소',
        address: '서울시 강남구 테헤란로 200',
        latitude: 37.4988,
        longitude: 127.0310,
        rating: 3.9,
        reviewCount: 45,
      ),
      CafeModel(
        id: '15',
        name: '카페숲',
        address: '서울시 강남구 봉은사로 250',
        latitude: 37.4935,
        longitude: 127.0410,
        rating: 4.5,
        reviewCount: 134,
      ),
    ];
  }

  @override
  Future<Cafe?> getCafeById(String id) async {
    // TODO: Phase 1.4에서 구현
    return null;
  }
}
