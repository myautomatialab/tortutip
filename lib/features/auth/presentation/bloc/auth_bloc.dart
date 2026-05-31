import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortutip/core/usecase/usecase.dart';
import 'package:tortutip/features/auth/domain/repository/auth_repository.dart';
import 'package:tortutip/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import 'package:tortutip/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogleUseCase _signInWithGoogle;
  final SignOutUseCase _signOut;
  final AuthRepository _authRepository;

  AuthBloc(this._signInWithGoogle, this._signOut, this._authRepository)
      : super(AuthInitial()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<SignInWithGoogleEvent>(_onSignIn);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onCheckAuth(
      CheckAuthEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepository.checkCurrentAuth();
    if (result.data != null) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _onSignIn(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _signInWithGoogle(NoParams());
    if (result.data != null) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(AuthError(result.error.toString()));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    await _signOut(NoParams());
    emit(AuthInitial());
  }
}
