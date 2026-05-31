import 'package:tortutip/features/articles/domain/entities/article_entity.dart';

abstract class ArticleDetailState {}

class ArticleDetailInitial extends ArticleDetailState {}

class ArticleDetailLoading extends ArticleDetailState {}

class ArticleDetailLoaded extends ArticleDetailState {
  final ArticleEntity article;
  ArticleDetailLoaded(this.article);
}

class ArticleDetailError extends ArticleDetailState {
  final String message;
  ArticleDetailError(this.message);
}
