import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/features/articles/domain/use_cases/get_user_articles_use_case.dart';
import 'package:tortutip/shared/user/domain/use_cases/get_current_user_use_case.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetCurrentUserUseCase _getCurrentUser;
  final GetUserArticlesUseCase _getUserArticles;

  ProfileCubit(this._getCurrentUser, this._getUserArticles)
      : super(ProfileInitial());

  Future<void> loadProfile(String userId) async {
    emit(ProfileLoading());
    final userResult = await _getCurrentUser(NoParams());
    if (userResult.data == null) {
      emit(ProfileError(userResult.error.toString()));
      return;
    }
    final articlesResult = await _getUserArticles(userId);
    if (articlesResult.data != null) {
      emit(ProfileLoaded(userResult.data!, articlesResult.data!));
    } else {
      emit(ProfileError(articlesResult.error.toString()));
    }
  }
}
