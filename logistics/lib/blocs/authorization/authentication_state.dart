part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown, loading }

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final String? role;

  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.role,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(String role)
      : this._(status: AuthenticationStatus.authenticated, role: role);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.loading()
      : this._(status: AuthenticationStatus.loading);

  @override
  List<Object?> get props => [status, role];
}
