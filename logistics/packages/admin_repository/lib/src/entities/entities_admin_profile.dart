import 'package:equatable/equatable.dart';

class AdminProfile extends Equatable {
  final String name;
  final String email;
  final String? profilePicture;

  const AdminProfile({
    required this.name,
    required this.email,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [name, email, profilePicture];
}