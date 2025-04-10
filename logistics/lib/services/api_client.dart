import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Add this

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:8000';
  String? sessionCookie;

  // Singleton instance
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal() {
    _loadSessionCookie(); // Load the cookie on initialization
  }

  // Load session cookie from SharedPreferences
  Future<void> _loadSessionCookie() async {
    final prefs = await SharedPreferences.getInstance();
    sessionCookie = prefs.getString('session_cookie');
    print('ApiClient: Loaded session cookie from SharedPreferences: $sessionCookie');
  }

  // Set session cookie after login and save to SharedPreferences
  Future<void> setSessionCookie(String cookie) async {
    sessionCookie = cookie;
    print('ApiClient: Session cookie set to: $sessionCookie');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_cookie', cookie);
    print('ApiClient: Session cookie saved to SharedPreferences');
  }

  // Clear session cookie on logout and remove from SharedPreferences
  Future<void> clearSessionCookie() async {
    sessionCookie = null;
    print('ApiClient: Session cookie cleared');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_cookie');
    print('ApiClient: Session cookie removed from SharedPreferences');
  }

  // Generic GET request
  Future<dynamic> get(String endpoint) async {
    print('ApiClient: Making GET request to $endpoint with cookie: $sessionCookie');
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        if (sessionCookie != null) 'Cookie': sessionCookie!,
        'Content-Type': 'application/json',
      },
    );

    print('ApiClient: GET response status: ${response.statusCode}, body: ${response.body}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode} - ${response.body}');
    }
  }

  // Generic POST request (used in logIn)
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    print('ApiClient: Making POST request to $endpoint with body: $body');
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    print('ApiClient: POST response status: ${response.statusCode}, body: ${response.body}, headers: ${response.headers}');
    return response;
  }
}