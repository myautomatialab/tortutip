abstract class AuthEvent {}

class CheckAuthEvent extends AuthEvent {}

class SignInWithGoogleEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}
