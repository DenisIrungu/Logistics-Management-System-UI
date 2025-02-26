import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:auth_repository/src/abstract_auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbAuthRepository implements AuthRepository {
  final String baseUrl = 'http://10.0.2.2:8000';

  @override
  Future<void> logIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final role = data['role'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_role', role);
        await prefs.setBool('is_logged_in', true);
      } else {
        throw Exception(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      print("Login error: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  @override
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  @override
  Future<void> logOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print("Logout error: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw Exception(data['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      print("Forgot password error: ${e.toString()}");
      rethrow;
    }
  }
}
