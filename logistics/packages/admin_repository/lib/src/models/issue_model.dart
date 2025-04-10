import 'package:equatable/equatable.dart';

class IssueModel extends Equatable {
  final int? id;
  final String title;
  final String description;
  final bool? isUrgent;

  const IssueModel({
    this.id,
    required this.title,
    required this.description,
    this.isUrgent,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'] as int?,
      title: json['title'] as String? ?? 'Unknown Issue',
      description: json['description'] as String? ?? 'No description',
      isUrgent: json['is_urgent'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_urgent': isUrgent,
    };
  }

  @override
  List<Object?> get props => [id, title, description, isUrgent];
}