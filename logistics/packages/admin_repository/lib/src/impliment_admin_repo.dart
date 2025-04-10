import 'package:admin_repository/admin_repository.dart';
import 'package:logistcs/services/api_client.dart';import 'package:admin_repository/src/models/admin_profile_model.dart';
import 'package:admin_repository/src/models/issue_model.dart';

class DbAdminRepository implements AdminRepository {
  final ApiClient _apiClient;

  DbAdminRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  @override
  Future<AdminProfile> fetchAdminProfile() async {
    try {
      final data = await _apiClient.get('/admin/profile');
      print('Profile response: $data');
      if (data is Map<String, dynamic>) {
        final model = AdminProfileModel.fromJson(data);
        return AdminProfile(name: model.name);
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
        final issues = data.map((item) => IssueModel.fromJson(item as Map<String, dynamic>)).toList();
        return issues.map((issue) => Issue(
          title: issue.title,
          description: issue.description,
        )).toList();
      } else {
        throw Exception('Expected a list of issues for priorities, but got: $data');
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
        final issues = data.map((item) => IssueModel.fromJson(item as Map<String, dynamic>)).toList();
        return issues.length;
      } else {
        throw Exception('Expected a list of issues for notifications, but got: $data');
      }
    } catch (e) {
      print('Error fetching notifications count: $e');
      throw Exception('Failed to fetch notifications count: $e');
    }
  }
}