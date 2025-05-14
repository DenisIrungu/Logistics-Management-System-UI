import 'package:equatable/equatable.dart';

class FeedbackModel extends Equatable {
  final int id;
  final int userId;
  final String userType;
  final String message;
  final String region;
  final String category;
  final String status;
  final int rating;
  final DateTime timestamp;

  const FeedbackModel({
    required this.id,
    required this.userId,
    required this.userType,
    required this.message,
    required this.region,
    required this.category,
    required this.status,
    required this.rating,
    required this.timestamp,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      userType: json['user_type'] as String,
      message: json['message'] as String,
      region: json['region'] as String,
      category: json['category'] as String,
      status: json['status'] as String,
      rating: json['rating'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Feedback toEntity() {
    return Feedback(
      id: id,
      userId: userId,
      userType: userType,
      message: message,
      region: region,
      category: category,
      status: status,
      rating: rating,
      timestamp: timestamp,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        userType,
        message,
        region,
        category,
        status,
        rating,
        timestamp,
      ];
}

class Feedback extends Equatable {
  final int id;
  final int userId;
  final String userType;
  final String message;
  final String region;
  final String category;
  final String status;
  final int rating;
  final DateTime timestamp;

  const Feedback({
    required this.id,
    required this.userId,
    required this.userType,
    required this.message,
    required this.region,
    required this.category,
    required this.status,
    required this.rating,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userType,
        message,
        region,
        category,
        status,
        rating,
        timestamp,
      ];
}