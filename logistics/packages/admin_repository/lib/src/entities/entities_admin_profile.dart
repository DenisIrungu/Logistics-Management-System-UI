import 'package:equatable/equatable.dart';

class AdminProfile extends Equatable {
  final String name;

  const AdminProfile({required this.name});

  @override
  List<Object?> get props => [name];
}