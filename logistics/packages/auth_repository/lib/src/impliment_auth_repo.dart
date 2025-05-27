import 'dart:convert';
import 'package:auth_repository/src/abstract_auth_repo.dart';
import 'package:logistcs/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbAuthRepository implements AuthRepository {
  final ApiClient _apiClient;

  DbAuthRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<void> logIn(String email, String password) async {
    try {
      print('DbAuthRepository: Login started for email: $email');
      final response = await _apiClient.post(
        '/auth/login',
        body: {'email': email, 'password': password},
      );

      print('DbAuthRepository: Login response status: ${response.statusCode}');
      print('DbAuthRepository: Login response body: ${response.body}');
      print('DbAuthRepository: Login response headers: ${response.headers}');

      if (response.statusCode == 200) {
        // Extract session cookie from response headers
        final cookies = response.headers['set-cookie'];
        print('DbAuthRepository: Cookies from response: $cookies');
        if (cookies == null) {
          throw Exception('Set-Cookie header not found in response');
        }

        final sessionCookie = cookies.split(';').firstWhere(
              (cookie) => cookie.trim().startsWith('session='),
              orElse: () => '',
            );
        print('DbAuthRepository: Extracted session cookie: $sessionCookie');
        if (sessionCookie.isEmpty) {
          throw Exception('Session cookie not found in response');
        }

        // Extract session value and role
        final sessionValue = sessionCookie.split('=')[1]; // e.g., "5|admin"
        print('DbAuthRepository: Session value: $sessionValue');
        final role = sessionValue.split('|')[1]; // e.g., "admin"
        print('DbAuthRepository: Extracted role: $role');
        if (role.isEmpty) {
          throw Exception('Role not found in session cookie');
        }

        // Store the session value (not the full cookie) and role in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('session', sessionValue); // Store "6|admin"
        await prefs.setString('user_role', role);
        await prefs.setBool('is_logged_in', true);
        print(
            'DbAuthRepository: Stored session in SharedPreferences: $sessionValue');
        final storedSession = prefs.getString('session');
        print('DbAuthRepository: Verified stored session: $storedSession');

        // Store the session cookie in ApiClient for future requests
        await _apiClient.setSessionCookie(sessionCookie);
        print(
            'DbAuthRepository: Login successful! Session: $sessionCookie, Role: $role');
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] as String? ?? 'Login failed');
      }
    } catch (e) {
      print("DbAuthRepository: Login error: ${e.toString()}");
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
      await _apiClient.clearSessionCookie();
      print('DbAuthRepository: Logged out');
    } catch (e) {
      print("DbAuthRepository: Logout error: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      print('DbAuthRepository: Forgot password started for email: $email');
      final response = await _apiClient.post(
        '/forgot-password',
        body: {'email': email},
      );

      print(
          'DbAuthRepository: Forgot password response status: ${response.statusCode}');
      print(
          'DbAuthRepository: Forgot password response body: ${response.body}');

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw Exception(
            data['message'] as String? ?? 'Failed to reset password');
      }
    } catch (e) {
      print("DbAuthRepository: Forgot password error: ${e.toString()}");
      rethrow;
    }
  }
}
