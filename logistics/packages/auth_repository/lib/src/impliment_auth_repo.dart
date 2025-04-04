import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:auth_repository/src/abstract_auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logistcs/services/api_client.dart';

class DbAuthRepository implements AuthRepository {
  final String baseUrl = 'http://10.0.2.2:8000';

  @override
  Future<void> logIn(String email, String password) async {
    try {
      final response = await ApiClient().post(
        '/auth/login',
        {'email': email, 'password': password},
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');
      print('Login response headers: ${response.headers}');

      if (response.statusCode == 200) {
        // Extract session cookie from response headers
        final cookies = response.headers['set-cookie'];
        if (cookies == null) {
          throw Exception('Set-Cookie header not found in response');
        }

        final sessionCookie = cookies.split(';').firstWhere(
          (cookie) => cookie.trim().startsWith('session='),
          orElse: () => '',
        );
        if (sessionCookie.isEmpty) {
          throw Exception('Session cookie not found in response');
        }

        // Extract role from the session cookie (format: session={user_id}|{role})
        final sessionValue = sessionCookie.split('=')[1]; // e.g., "5|admin"
        final role = sessionValue.split('|')[1]; // e.g., "admin"
        if (role.isEmpty) {
          throw Exception('Role not found in session cookie');
        }

        // Store the session cookie in ApiClient for future requests
        ApiClient().setSessionCookie(sessionCookie);

        // Store the role and login status in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_role', role);
        await prefs.setBool('is_logged_in', true);
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] as String? ?? 'Login failed');
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
      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Clear session cookie from ApiClient
      ApiClient().clearSessionCookie();
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
        throw Exception(data['message'] as String? ?? 'Failed to reset password');
      }
    } catch (e) {
      print("Forgot password error: ${e.toString()}");
      rethrow;
    }
  }
}