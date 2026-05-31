abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingRoleSelected extends OnboardingState {
  final String role;
  OnboardingRoleSelected(this.role);
}

class OnboardingComplete extends OnboardingState {}

class OnboardingError extends OnboardingState {
  final String message;
  OnboardingError(this.message);
}
