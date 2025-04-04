import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:8000'; // Match your backend URL
  String? sessionCookie;

  // Singleton instance
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  // Set session cookie after login
  void setSessionCookie(String cookie) {
    sessionCookie = cookie;
  }

  // Clear session cookie on logout
  void clearSessionCookie() {
    sessionCookie = null;
  }

  // Generic GET request (for future use, e.g., fetching profile or priorities)
  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        if (sessionCookie != null) 'Cookie': sessionCookie!,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode} - ${response.body}');
    }
  }

  // Generic POST request (used in logIn)
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    return response;
  }
}