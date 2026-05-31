import 'package:tortutip/features/articles/domain/entities/article_entity.dart';
import 'package:tortutip/shared/user/domain/entities/user_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;
  final List<ArticleEntity> articles;
  ProfileLoaded(this.user, this.articles);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
