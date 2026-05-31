import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/shared/user/domain/use_cases/update_user_role_use_case.dart';
import 'package:tortutip/shared/user/domain/use_cases/select_user_categories_use_case.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final UpdateUserRoleUseCase _updateUserRole;
  final SelectUserCategoriesUseCase _selectCategories;

  OnboardingCubit(this._updateUserRole, this._selectCategories)
      : super(OnboardingInitial());

  Future<void> selectRole(String userId, String role) async {
    if (state is OnboardingLoading) return;
    emit(OnboardingLoading());
    final result = await _updateUserRole(
        UpdateUserRoleParams(userId: userId, role: role));
    if (result.data == true) {
      emit(OnboardingRoleSelected(role));
    } else {
      emit(OnboardingError(result.error.toString()));
    }
  }

  Future<void> selectCategories(String userId, List<String> categoryIds) async {
    if (state is OnboardingLoading || state is OnboardingComplete) return;
    emit(OnboardingLoading());
    final result = await _selectCategories(
        SelectUserCategoriesParams(userId: userId, categoryIds: categoryIds));
    if (result.data == true) {
      emit(OnboardingComplete());
    } else {
      emit(OnboardingError(result.error.toString()));
    }
  }
}
