import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/features/articles/domain/use_cases/get_user_articles_use_case.dart';
import 'package:tortutip/shared/user/domain/use_cases/get_current_user_use_case.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetCurrentUserUseCase _getCurrentUser;
  final GetUserArticlesUseCase _getUserArticles;

  ProfileCubit(this._getCurrentUser, this._getUserArticles)
      : super(const ProfileInitial());

  Future<void> loadProfile(String userId) async {
    emit(const ProfileLoading());
    final userResult = await _getCurrentUser(const NoParams());
    if (userResult.isFailure) {
      emit(ProfileError(_mapErrorToMessage(userResult.error!)));
      return;
    }
    final articlesResult = await _getUserArticles(userId);
    if (articlesResult.isSuccess) {
      emit(ProfileLoaded(userResult.data!, articlesResult.data!));
    } else {
      emit(ProfileError(_mapErrorToMessage(articlesResult.error!)));
    }
  }

  String _mapErrorToMessage(Exception error) {
    if (error is FirebaseException) {
      return switch (error.code) {
        'permission-denied' => 'No tienes permiso para ver este perfil',
        'not-found'         => 'El perfil no existe',
        'unavailable'       => 'Sin conexión. Inténtalo de nuevo',
        _                   => 'Algo salió mal. Inténtalo de nuevo',
      };
    }
    return 'Algo salió mal. Inténtalo de nuevo';
  }
}
