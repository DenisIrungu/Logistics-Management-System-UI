import 'dart:io';
import 'dart:convert';
import 'package:admin_repository/admin_repository.dart';
import 'package:logistcs/services/api_client.dart';
import 'package:admin_repository/src/models/admin_profile_model.dart';
import 'package:admin_repository/src/models/issue_model.dart';
import 'package:admin_repository/src/models/region_model.dart';
import 'package:admin_repository/src/models/feedback_model.dart';  // Add this import

class DbAdminRepository implements AdminRepository {
  final ApiClient _apiClient;

  DbAdminRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<AdminProfile> fetchAdminProfile() async {
    try {
      final data = await _apiClient.get('/admin/profile');
      print('Profile response: $data');
      if (data is Map<String, dynamic>) {
        final model = AdminProfileModel.fromJson(data);
        return model.toEntity();
      } else {
        throw Exception('Expected a map for profile response, but got: $data');
      }
    } catch (e) {
      print('Error fetching admin profile: $e');
      throw Exception('Failed to fetch admin profile: $e');
    }
  }

  @override
  Future<List<Issue>> fetchPriorities() async {
    try {
      final data = await _apiClient.get('/admin/priorities');
      print('Priorities response: $data');
      if (data is List<dynamic>) {
        final issues = data
            .map((item) => IssueModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return issues
            .map((issue) => Issue(
                  title: issue.title,
                  description: issue.description,
                ))
            .toList();
      } else {
        throw Exception(
            'Expected a list of issues for priorities, but got: $data');
      }
    } catch (e) {
      print('Error fetching priorities: $e');
      throw Exception('Failed to fetch priorities: $e');
    }
  }

  @override
  Future<int> fetchNotificationsCount() async {
    try {
      final data = await _apiClient.get('/admin/notifications');
      print('Notifications response: $data');
      if (data is List<dynamic>) {
        final issues = data
            .map((item) => IssueModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return issues.length;
      } else {
        throw Exception(
            'Expected a list of issues for notifications, but got: $data');
      }
    } catch (e) {
      print('Error fetching notifications count: $e');
      throw Exception('Failed to fetch notifications count: $e');
    }
  }

  @override
  Future<void> sendVerificationCode(String type) async {
    try {
      print('DbAdminRepository: Sending verification code with type: $type');
      final response = await _apiClient.post(
        '/admin/send-verification-code',
        queryParams: {'type': type},
      );
      print(
          'DbAdminRepository: Send verification code response: ${response.statusCode} - ${response.body}');
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 &&
          responseBody['message'] == 'Verification code sent to your email') {
        return;
      } else {
        throw Exception(
            'Failed to send verification code: ${responseBody['detail'] ?? responseBody}');
      }
    } catch (e) {
      print('DbAdminRepository: Error sending verification code: $e');
      throw Exception('Failed to send verification code: $e');
    }
  }

  @override
  Future<void> updateAdminProfile({
    String? name,
    String? email,
    String? verificationCode,
    File? profilePicture,
  }) async {
    try {
      final fields = <String, String>{};
      if (name != null) fields['name'] = name;
      if (email != null) fields['email'] = email;
      if (verificationCode != null)
        fields['verification_code'] = verificationCode;

      final response = await _apiClient.multipartPut(
        '/admin/profile',
        fields: fields.isNotEmpty ? fields : null,
        file: profilePicture,
      );

      print('Update profile response: $response');
      if (response is Map<String, dynamic>) {
        return;
      } else {
        throw Exception(
            'Expected a map for update profile response, but got: $response');
      }
    } catch (e) {
      print('Error updating admin profile: $e');
      throw Exception('Failed to fetch admin profile: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> fetchPreferences() async {
    try {
      final data = await _apiClient.get('/admin/preferences');
      print('Preferences response: $data');
      if (data is Map<String, dynamic>) {
        return {
          'theme': data['theme'] ?? 'light',
          'notifications': data['notifications'] ?? true,
        };
      } else {
        throw Exception(
            'Expected a map for preferences response, but got: $data');
      }
    } catch (e) {
      print('Error fetching preferences: $e');
      throw Exception('Failed to fetch preferences: $e');
    }
  }

  @override
  Future<void> updatePreferences(Map<String, dynamic> preferences) async {
    try {
      final response = await _apiClient.put(
        '/admin/preferences',
        preferences,
      );
      print(
          'Update preferences response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody is Map<String, dynamic>) {
          return;
        } else {
          throw Exception(
              'Expected a map for update preferences response, but got: ${response.body}');
        }
      } else {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(
            'Failed to update preferences: ${response.statusCode} - ${responseBody['detail'] ?? responseBody}');
      }
    } catch (e) {
      print('Error updating preferences: $e');
      throw Exception('Failed to update preferences: $e');
    }
  }

  @override
  Future<List<Region>> fetchTopRegions() async {
    try {
      final data = await _apiClient.get('/admin/top-regions');
      print('Top regions response: $data');
      if (data is List<dynamic>) {
        return data
            .map((item) => Region.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Expected a list of regions, but got: $data');
      }
    } catch (e) {
      print('Error fetching top regions: $e');
      throw Exception('Failed to fetch top regions: $e');
    }
  }

  @override
Future<List<Feedback>> fetchFeedbacks({
  String? region,
  String? dateStart,
  String? dateEnd,
  String sortBy = 'date',
  String sortOrder = 'desc',
}) async {
  try {
    // Construct query parameters
    final queryParams = <String, String>{
      'sort_by': sortBy,
      'sort_order': sortOrder,
    };
    if (region != null) queryParams['region'] = region;
    if (dateStart != null) queryParams['date_start'] = dateStart;
    if (dateEnd != null) queryParams['date_end'] = dateEnd;

    // Construct the full endpoint with query parameters
    final uri = Uri.parse('/admin/feedbacks').replace(queryParameters: queryParams);
    final endpoint = uri.toString(); // e.g., /admin/feedbacks?sort_by=date&sort_order=desc

    final data = await _apiClient.get(endpoint);
    print('Feedbacks response: $data');
    if (data is List<dynamic>) {
      final feedbackModels = data
          .map((item) => FeedbackModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return feedbackModels.map((model) => model.toEntity()).toList();
    } else {
      throw Exception('Expected a list of feedbacks, but got: $data');
    }
  } catch (e) {
    print('Error fetching feedbacks: $e');
    throw Exception('Failed to fetch feedbacks: $e');
  }
}
}