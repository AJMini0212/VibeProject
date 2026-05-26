import '../../domain/entities/cafe.dart';
import '../../domain/repositories/cafe_repository.dart';

class SearchCafesUseCase {
  final CafeRepository _cafeRepository;

  SearchCafesUseCase(this._cafeRepository);

  Future<List<Cafe>> call({
    required double latitude,
    required double longitude,
    required String query,
  }) async {
    // UseCase 레벨 비즈니스 로직 (검증, 캐싱, 다중 Repository 조합 등)
    // 현재는 단순 위임, 나중에 복잡도 추가
    return await _cafeRepository.searchCafes(latitude, longitude, query);
  }
}
