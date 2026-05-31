import 'package:equatable/equatable.dart';
import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/shared/user/domain/entities/user_entity.dart';

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
  final UserEntity author;
  final bool isSaved;
  final List<ArticleEntity> relatedArticles;

  const ArticleDetailLoaded({
    required this.article,
    required this.author,
    required this.isSaved,
    required this.relatedArticles,
  });

  @override
  List<Object?> get props => [article, author, isSaved, relatedArticles];
}

class ArticleDetailError extends ArticleDetailState {
  final String message;
  const ArticleDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class ArticleDetailSaving extends ArticleDetailState {
  final ArticleEntity article;
  final UserEntity author;
  final bool isSaved;
  final List<ArticleEntity> relatedArticles;

  const ArticleDetailSaving({
    required this.article,
    required this.author,
    required this.isSaved,
    required this.relatedArticles,
  });

  @override
  List<Object?> get props => [article, author, isSaved, relatedArticles];
}
