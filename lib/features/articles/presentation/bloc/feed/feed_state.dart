import 'package:tortutip/features/articles/domain/entities/article_entity.dart';

abstract class FeedState {}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<ArticleEntity> articles;
  FeedLoaded(this.articles);
}

class FeedError extends FeedState {
  final String message;
  FeedError(this.message);
}
