import 'package:equatable/equatable.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {
  const FeedInitial();
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

class FeedLoaded extends FeedState {
  final List<ArticleEntity> articles;
  const FeedLoaded(this.articles);

  @override
  List<Object?> get props => [articles];
}

class FeedError extends FeedState {
  final String message;
  const FeedError(this.message);

  @override
  List<Object?> get props => [message];
}
