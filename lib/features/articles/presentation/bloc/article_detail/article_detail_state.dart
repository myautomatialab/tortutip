import 'package:equatable/equatable.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';

abstract class ArticleDetailState extends Equatable {
  const ArticleDetailState();

  @override
  List<Object?> get props => [];
}

class ArticleDetailInitial extends ArticleDetailState {
  const ArticleDetailInitial();
}

class ArticleDetailLoading extends ArticleDetailState {
  const ArticleDetailLoading();
}

class ArticleDetailLoaded extends ArticleDetailState {
  final ArticleEntity article;
  const ArticleDetailLoaded(this.article);

  @override
  List<Object?> get props => [article];
}

class ArticleDetailError extends ArticleDetailState {
  final String message;
  const ArticleDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
