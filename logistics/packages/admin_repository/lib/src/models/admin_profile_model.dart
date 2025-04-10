import 'package:equatable/equatable.dart';

class AdminProfileModel extends Equatable {
  final String name;
  final String email;
  final String? profilePicture;

  const AdminProfileModel({
    required this.name,
    required this.email,
    this.profilePicture,
  });

  factory AdminProfileModel.fromJson(Map<String, dynamic> json) {
    return AdminProfileModel(
      name: json['name'] as String? ?? 'Unknown',
      email: json['email'] as String? ?? '',
      profilePicture: json['profile_picture'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profile_picture': profilePicture,
    };
  }

  @override
  List<Object?> get props => [name, email, profilePicture];
}