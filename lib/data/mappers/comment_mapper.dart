import '../../domain/entities/comment.dart';
import '../models/comment_model.dart';

class CommentMapper {
  static Comment toDomain(CommentModel model) {
    return Comment(
      id: model.id,
      reviewId: model.reviewId,
      userId: model.userId,
      text: model.text,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static CommentModel toModel(Comment entity) {
    return CommentModel(
      id: entity.id,
      reviewId: entity.reviewId,
      userId: entity.userId,
      text: entity.text,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static List<Comment> toDomainList(List<CommentModel> models) {
    return models.map(toDomain).toList();
  }

  static List<CommentModel> toModelList(List<Comment> entities) {
    return entities.map(toModel).toList();
  }
}
