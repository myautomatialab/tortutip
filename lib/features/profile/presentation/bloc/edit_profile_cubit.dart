import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/features/profile/domain/use_cases/upload_avatar_use_case.dart';
import 'package:tortutip/shared/user/domain/entities/user_entity.dart';
import 'package:tortutip/shared/user/domain/use_cases/update_user_profile_use_case.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final UpdateUserProfileUseCase _updateUserProfile;
  final UploadAvatarUseCase _uploadAvatar;

  EditProfileCubit(this._updateUserProfile, this._uploadAvatar)
      : super(const EditProfileInitial());

  Future<void> uploadAvatar(File imageFile, String userId) async {
    emit(const EditProfileImageUploading());
    final result = await _uploadAvatar(
      UploadAvatarParams(imageFile: imageFile, userId: userId),
    );
    if (result.isSuccess) {
      emit(EditProfileImageUploaded(result.data!));
    } else {
      emit(EditProfileError(_mapErrorToMessage(result.error!)));
    }
  }

  Future<void> saveProfile({
    required UserEntity currentUser,
    required String name,
    required String bio,
    String? avatarUrl,
  }) async {
    emit(const EditProfileLoading());

    final updatedUser = UserEntity(
      id: currentUser.id,
      name: name.trim(),
      email: currentUser.email,
      avatarUrl: avatarUrl ?? currentUser.avatarUrl,
      bio: bio.trim(),
      role: currentUser.role,
      gender: currentUser.gender,
      ageRange: currentUser.ageRange,
      createdAt: currentUser.createdAt,
    );

    final result = await _updateUserProfile(
      UpdateUserProfileParams(user: updatedUser),
    );

    if (result.isSuccess) {
      emit(EditProfileSuccess(result.data!));
    } else {
      emit(EditProfileError(_mapErrorToMessage(result.error!)));
    }
  }

  String _mapErrorToMessage(Exception error) {
    if (error is FirebaseException) {
      return switch (error.code) {
        'permission-denied' => 'No tienes permiso para actualizar tu perfil',
        'unavailable' => 'Sin conexión. Inténtalo de nuevo',
        _ => 'Algo salió mal. Inténtalo de nuevo',
      };
    }
    return 'Algo salió mal. Inténtalo de nuevo';
  }
}
