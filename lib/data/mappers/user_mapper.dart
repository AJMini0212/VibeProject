import '../../domain/entities/user.dart';
import '../models/user_model.dart';

class UserMapper {
  static User toDomain(UserModel model) {
    return User(
      uid: model.uid,
      email: model.email,
      displayName: model.displayName,
      photoUrl: model.photoUrl,
      bio: model.bio,
      createdAt: model.createdAt,
      favoriteIds: model.favoriteIds,
      followerIds: model.followerIds,
      followingIds: model.followingIds,
    );
  }

  static UserModel toModel(User entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      bio: entity.bio,
      createdAt: entity.createdAt,
      favoriteIds: entity.favoriteIds,
      followerIds: entity.followerIds,
      followingIds: entity.followingIds,
    );
  }

  static List<User> toDomainList(List<UserModel> models) {
    return models.map(toDomain).toList();
  }

  static List<UserModel> toModelList(List<User> entities) {
    return entities.map(toModel).toList();
  }
}
