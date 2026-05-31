import 'package:tortutip/features/articles/domain/entities/article_entity.dart';

abstract class CreateArticleState {}

class CreateArticleInitial extends CreateArticleState {}

class CreateArticleLoading extends CreateArticleState {}

class CreateArticleSuccess extends CreateArticleState {
  final ArticleEntity article;
  CreateArticleSuccess(this.article);
}

class CreateArticleError extends CreateArticleState {
  final String message;
  CreateArticleError(this.message);
}
