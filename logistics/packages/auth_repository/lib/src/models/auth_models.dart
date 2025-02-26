import 'package:auth_repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

class AuthModels extends Equatable {
  final String email;
  final String password;
  final String role;

  const AuthModels(
      {required this.email, required this.password, required this.role});
  //Creating an empty method
  static const empty = AuthModels(email: '', password: '', role: '');
  //Creating a copyWith method
  AuthModels copyWith({String? email, String? password, String? role}) {
    return AuthModels(
        email: email ?? this.email,
        password: password ?? this.password,
        role: role ?? this.role);
  }

  bool get isEmpty => email.isEmpty && password.isEmpty && role.isEmpty;
  bool get isNotEmpty => !isEmpty;
  //Converting models to entities

  AuthEntity toEntity() {
    return AuthEntity(email: email, password: password, role: role);
  }

  // Converts JSON → Model (for API response)
  factory AuthModels.fromJson(Map<String, dynamic> json) {
    return (AuthModels(
        email: json['email'] ?? '',
        password: json['password'] ?? '',
        role: json['role'] ?? ''));
  }
  // Converts Model → JSON (for API request)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role,
    };
  }

  // Creates AuthModel from AuthEntity
  factory AuthModels.fromEntity(AuthEntity entity) {
    return AuthModels(
        email: entity.email, password: entity.password, role: entity.role);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [email, password, role];
}
