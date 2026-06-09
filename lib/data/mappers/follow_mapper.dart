import '../../domain/entities/follow.dart';
import '../models/follow_model.dart';

class FollowMapper {
  static Follow toDomain(FollowModel model) {
    return Follow(
      followerId: model.followerId,
      followingId: model.followingId,
      followedAt: model.followedAt,
    );
  }

  static FollowModel toModel(Follow entity) {
    return FollowModel(
      followerId: entity.followerId,
      followingId: entity.followingId,
      followedAt: entity.followedAt,
    );
  }

  static List<Follow> toDomainList(List<FollowModel> models) {
    return models.map(toDomain).toList();
  }

  static List<FollowModel> toModelList(List<Follow> entities) {
    return entities.map(toModel).toList();
  }
}
