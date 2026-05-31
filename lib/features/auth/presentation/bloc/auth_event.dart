abstract class AuthEvent {
  const AuthEvent();
}

class CheckAuthEvent extends AuthEvent {
  const CheckAuthEvent();
}

class SignInWithGoogleEvent extends AuthEvent {
  const SignInWithGoogleEvent();
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}
