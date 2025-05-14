import 'dart:io';
import 'package:admin_repository/src/entities/entities_admin_profile.dart';
import 'package:admin_repository/src/entities/entities_issue.dart';
import 'package:admin_repository/src/models/region_model.dart';
import 'package:admin_repository/src/models/feedback_model.dart';  // Add this import

abstract class AdminRepository {
  Future<AdminProfile> fetchAdminProfile();
  Future<List<Issue>> fetchPriorities();
  Future<int> fetchNotificationsCount();
  Future<void> sendVerificationCode(String type);
  Future<void> updateAdminProfile({
    String? name,
    String? email,
    String? verificationCode,
    File? profilePicture,
  });
  Future<Map<String, dynamic>> fetchPreferences();
  Future<void> updatePreferences(Map<String, dynamic> preferences);
  Future<List<Region>> fetchTopRegions();
  Future<List<Feedback>> fetchFeedbacks({
    String? region,
    String? dateStart,
    String? dateEnd,
    String sortBy,
    String sortOrder,
  });  // Add this method
}