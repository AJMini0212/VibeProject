import '../../domain/entities/user.dart';
import '../models/user_model.dart';

class UserMapper {
  static User toDomain(UserModel model) {
    return User(
      uid: model.uid,
      email: model.email,
      displayName: model.displayName,
      photoUrl: model.photoUrl,
      createdAt: model.createdAt,
      favoriteIds: model.favoriteIds,
    );
  }

  static UserModel toModel(User entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      createdAt: entity.createdAt,
      favoriteIds: entity.favoriteIds,
    );
  }

  static List<User> toDomainList(List<UserModel> models) {
    return models.map(toDomain).toList();
  }

  static List<UserModel> toModelList(List<User> entities) {
    return entities.map(toModel).toList();
  }
}
