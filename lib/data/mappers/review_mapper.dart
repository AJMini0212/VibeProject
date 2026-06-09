import '../../domain/entities/review.dart';
import '../models/review_model.dart';

class ReviewMapper {
  static Review toDomain(ReviewModel model) {
    return Review(
      id: model.id,
      cafeId: model.cafeId,
      userId: model.userId,
      rating: model.rating,
      text: model.text,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      likedByUserIds: model.likedByUserIds,
      likeCount: model.likeCount,
      commentCount: model.commentCount,
    );
  }

  static ReviewModel toModel(Review entity) {
    return ReviewModel(
      id: entity.id,
      cafeId: entity.cafeId,
      userId: entity.userId,
      rating: entity.rating,
      text: entity.text,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      likedByUserIds: entity.likedByUserIds,
      likeCount: entity.likeCount,
      commentCount: entity.commentCount,
    );
  }

  static List<Review> toDomainList(List<ReviewModel> models) {
    return models.map(toDomain).toList();
  }

  static List<ReviewModel> toModelList(List<Review> entities) {
    return entities.map(toModel).toList();
  }
}
