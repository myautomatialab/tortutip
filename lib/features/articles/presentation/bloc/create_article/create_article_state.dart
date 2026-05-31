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
