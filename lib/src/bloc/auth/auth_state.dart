part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated, unknown, loading, error }

class AuthState extends Equatable {
  const AuthState._(
      {this.status = AuthStatus.unknown,
      this.user = CortadoUser.empty,
      this.error = ''});

  const AuthState.unknown() : this._();

  const AuthState.loading() : this._(status: AuthStatus.loading);

  const AuthState.authenticated(CortadoUser user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  const AuthState.error(error) : this._(status: AuthStatus.error, error: error);

  final AuthStatus status;
  final CortadoUser user;
  final String error;

  @override
  List<Object> get props => [status, user];
}
