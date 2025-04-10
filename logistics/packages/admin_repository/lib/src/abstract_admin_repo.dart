//import 'package:admin_repository/src/entities/admin_profile.dart';
import 'package:admin_repository/src/entities/entities_admin_profile.dart';
import 'package:admin_repository/src/entities/entities_issue.dart';
//import 'package:admin_repository/src/entities/issue.dart';

abstract class AdminRepository {
  Future<AdminProfile> fetchAdminProfile();
  Future<List<Issue>> fetchPriorities();
  Future<int> fetchNotificationsCount();
}