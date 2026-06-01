import 'package:equatable/equatable.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';

abstract class CreateArticleState extends Equatable {
  const CreateArticleState();

  @override
  List<Object?> get props => [];
}

class CreateArticleInitial extends CreateArticleState {
  const CreateArticleInitial();
}

class CreateArticleLoading extends CreateArticleState {
  const CreateArticleLoading();
}

class CreateArticleImageUploading extends CreateArticleState {
  final bool isVertical;
  const CreateArticleImageUploading({required this.isVertical});

  @override
  List<Object?> get props => [isVertical];
}

class CreateArticleFormUpdated extends CreateArticleState {
  final String? coverVerticalUrl;
  final String? coverHorizontalUrl;
  final String title;
  final String categoryId;
  final String bodyJson;

  const CreateArticleFormUpdated({
    this.coverVerticalUrl,
    this.coverHorizontalUrl,
    required this.title,
    required this.categoryId,
    required this.bodyJson,
  });

  bool get isValid =>
      coverVerticalUrl != null &&
      coverHorizontalUrl != null &&
      title.trim().length >= 3 &&
      categoryId.isNotEmpty &&
      bodyJson.length >= 50;

  @override
  List<Object?> get props => [
        coverVerticalUrl,
        coverHorizontalUrl,
        title,
        categoryId,
        bodyJson,
      ];
}

class CreateArticlePublishing extends CreateArticleState {
  const CreateArticlePublishing();
}

class CreateArticlePublished extends CreateArticleState {
  final ArticleEntity article;
  const CreateArticlePublished(this.article);

  @override
  List<Object?> get props => [article];
}

// Keep for backwards compatibility with existing tests
class CreateArticleSuccess extends CreateArticleState {
  final ArticleEntity article;
  const CreateArticleSuccess(this.article);

  @override
  List<Object?> get props => [article];
}

class CreateArticleError extends CreateArticleState {
  final String message;
  const CreateArticleError(this.message);

  @override
  List<Object?> get props => [message];
}
