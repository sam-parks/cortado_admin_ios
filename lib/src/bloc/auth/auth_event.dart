part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SignInEmailPressed extends AuthEvent {
  final String email;
  final String password;

  SignInEmailPressed(this.email, this.password);
}


class SignOut extends AuthEvent {}