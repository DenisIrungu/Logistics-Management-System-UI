import 'dart:io';
import 'dart:convert';
import 'package:admin_repository/admin_repository.dart';
import 'package:logistcs/services/api_client.dart';
import 'package:admin_repository/src/models/admin_profile_model.dart';
import 'package:admin_repository/src/models/issue_model.dart';
import 'package:admin_repository/src/models/region_model.dart';
import 'package:admin_repository/src/models/feedback_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class DbAdminRepository implements AdminRepository {
  final ApiClient _apiClient;

  DbAdminRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<bool> _isValidPdf(File file) async {
    try {
      if (!file.path.toLowerCase().endsWith('.pdf')) {
        print('File ${file.path} does not have PDF extension');
        return false;
      }

      final bytes = await file.openRead(0, 5).first;
      final header = String.fromCharCodes(bytes);
      print('File ${file.path} header: $header');

      final isValid = header.startsWith('%PDF-');
      print('File ${file.path} is valid PDF: $isValid');
      return isValid;
    } catch (e) {
      print('Error validating PDF for file ${file.path}: $e');
      return false;
    }
  }

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
          'DbAuthRepository: Send verification code response: ${response.statusCode} - ${response.body}');
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 &&
          responseBody['message'] == 'Verification code sent to your email') {
        return;
      } else {
        throw Exception(
            'Failed to send verification code: ${responseBody['detail'] ?? responseBody}');
      }
    } catch (e) {
      print('DbAuthRepository: Error sending verification code: $e');
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
      final queryParams = <String, String>{
        'sort_by': sortBy,
        'sort_order': sortOrder,
      };
      if (region != null) queryParams['region'] = region;
      if (dateStart != null) queryParams['date_start'] = dateStart;
      if (dateEnd != null) queryParams['date_end'] = dateEnd;

      final uri =
          Uri.parse('/admin/feedbacks').replace(queryParameters: queryParams);
      final endpoint = uri.toString();

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

  @override
  Future<void> registerRider({
    required Map<String, dynamic> riderData,
  }) async {
    try {
      final fields = <String, String>{
        'first_name': riderData['first_name']?.toString() ?? '',
        'last_name': riderData['last_name']?.toString() ?? '',
        'phone_number': riderData['phone_number']?.toString() ?? '',
        'email': riderData['email']?.toString() ?? '',
        'bike_model': riderData['bike_model']?.toString() ?? '',
        'bike_color': riderData['bike_color']?.toString() ?? '',
        'plate_number': riderData['plate_number']?.toString() ?? '',
        'license': riderData['license']?.toString() ?? '',
        'emergency_contact_name':
            riderData['emergency_contact_name']?.toString() ?? '',
        'emergency_contact_phone':
            riderData['emergency_contact_phone']?.toString() ?? '',
        'emergency_contact_relationship':
            riderData['emergency_contact_relationship']?.toString() ?? '',
        'terms_accepted': riderData['terms_accepted']?.toString() ?? 'false',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${ApiClient.baseUrl}/admin/register-rider'), // Use ApiClient.baseUrl
      );

      // Add session cookie from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final session =
          prefs.getString('session_cookie'); // Match key used in ApiClient
      print('Retrieved session from SharedPreferences: $session');
      if (session != null) {
        request.headers['Cookie'] = session;
        print('Sent Cookie header value: ${request.headers['Cookie']}');
      } else {
        throw Exception('Session cookie not found. Please log in again.');
      }

      request.fields.addAll(fields);

      for (var key in ['id_document', 'driving_license', 'insurance']) {
        if (riderData[key] != null) {
          final filePath = riderData[key] as String;
          final file = File(filePath);
          if (await file.exists()) {
            final isValidPdf = await _isValidPdf(file);
            if (!isValidPdf) {
              throw Exception(
                  'File ${path.basename(file.path)} is not a valid PDF');
            }
            request.files.add(
              await http.MultipartFile.fromPath(
                key,
                file.path,
                filename: path.basename(file.path),
                contentType: MediaType('application', 'pdf'),
              ),
            );
            print('Added file for $key: ${file.path}');
          } else {
            throw Exception('File not found at path: $filePath');
          }
        }
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var responseData = jsonDecode(responseBody) as Map<String, dynamic>;

      print('Register rider response: ${response.statusCode} - $responseBody');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception(
            'Failed to register rider: ${responseData['detail'] ?? responseData}');
      }
    } catch (e) {
      print('Error registering rider: $e');
      throw Exception('Failed to register rider: $e');
    }
  }

  @override
  Future<void> resendVerificationEmail(String email) async {
    try {
      print('DbAdminRepository: Resending verification email for: $email');
      final response = await _apiClient.post(
        '/admin/resend-verification-email',
        body: {'email': email},
        useFormData: true,
      );
      print(
          'DbAdminRepository: Resend verification email response: ${response.statusCode} - ${response.body}');
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 &&
          responseBody['message'] == 'Verification email resent successfully') {
        return;
      } else {
        throw Exception(
            'Failed to resend verification email: ${responseBody['detail'] ?? responseBody}');
      }
    } catch (e) {
      print('DbAdminRepository: Error resending verification email: $e');
      throw Exception('Failed to resend verification email: $e');
    }
  }
}
