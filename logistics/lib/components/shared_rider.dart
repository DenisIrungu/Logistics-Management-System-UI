class Rider {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String bikeNumber;
  final String bikeModel;
  final String bikeColor;
  final String license;
  final String? idDocument; // Changed to nullable
  final String? drivingLicense;
  final String? insurance;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String emergencyContactRelationship;
  final int createdBy;
  final String status;
  final DateTime createdAt;

  Rider({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.bikeNumber,
    required this.bikeModel,
    required this.bikeColor,
    required this.license,
    this.idDocument,
    this.drivingLicense,
    this.insurance,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.emergencyContactRelationship,
    required this.createdBy,
    required this.status,
    required this.createdAt,
  });

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      bikeNumber: json['bike_number'] as String,
      bikeModel: json['bike_model'] as String,
      bikeColor: json['bike_color'] as String,
      license: json['license'] as String,
      idDocument: json['id_document'] as String?, // Updated to nullable
      drivingLicense: json['driving_license'] as String?,
      insurance: json['insurance'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String,
      emergencyContactPhone: json['emergency_contact_phone'] as String,
      emergencyContactRelationship:
          json['emergency_contact_relationship'] as String,
      createdBy: json['created_by'] as int,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'bike_number': bikeNumber,
      'bike_model': bikeModel,
      'bike_color': bikeColor,
      'license': license,
      'id_document': idDocument,
      'driving_license': drivingLicense,
      'insurance': insurance,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
      'emergency_contact_relationship': emergencyContactRelationship,
      'created_by': createdBy,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class PaginatedRiders {
  final int total;
  final int skip;
  final int limit;
  final List<Rider> riders;

  PaginatedRiders({
    required this.total,
    required this.skip,
    required this.limit,
    required this.riders,
  });

  factory PaginatedRiders.fromJson(Map<String, dynamic> json) {
    return PaginatedRiders(
      total: json['total'] as int,
      skip: json['skip'] as int,
      limit: json['limit'] as int,
      riders: (json['riders'] as List<dynamic>)
          .map((riderJson) => Rider.fromJson(riderJson as Map<String, dynamic>))
          .toList(),
    );
  }
}
