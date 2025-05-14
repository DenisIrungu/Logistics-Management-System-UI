import 'package:equatable/equatable.dart';

class Region extends Equatable {
  final String region;
  final double onTimeDeliveryRate;

  const Region({
    required this.region,
    required this.onTimeDeliveryRate,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      region: json['region'] as String,
      onTimeDeliveryRate: ((json['success_rate'] as num?) ?? 0.0) / 100.0,
    );
  }

  @override
  List<Object?> get props => [region, onTimeDeliveryRate];
}