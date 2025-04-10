import 'package:equatable/equatable.dart';

class Issue extends Equatable {
  final String title;
  final String description;

  const Issue({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}