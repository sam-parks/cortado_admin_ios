part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class SignInEmailPressed extends AuthEvent {
  final String email;
  final String password;

  SignInEmailPressed(this.email, this.password);
}

class SignInGooglePressed extends AuthEvent {}

class SignInApplePressed extends AuthEvent {}

class SignOut extends AuthEvent {}
