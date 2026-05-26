import '../../domain/entities/cafe.dart';
import '../models/cafe_model.dart';

class CafeMapper {
  static Cafe toDomain(CafeModel model) {
    return Cafe(
      id: model.id,
      name: model.name,
      address: model.address,
      latitude: model.latitude,
      longitude: model.longitude,
      rating: model.rating,
      reviewCount: model.reviewCount,
    );
  }

  static List<Cafe> toDomainList(List<CafeModel> models) {
    return models.map(toDomain).toList();
  }
}
