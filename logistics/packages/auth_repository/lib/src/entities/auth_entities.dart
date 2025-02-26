import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String email;
  final String password;
  final String role;

  const AuthEntity({
    required this.email,
    required this.password,
    required this.role,
  });
  @override
  List<Object?> get props => [email, password, role];
}
