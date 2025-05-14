import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:8000';
  String? sessionCookie;

  // Singleton instance
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal() {
    _loadSessionCookie();
  }

  Future<void> _loadSessionCookie() async {
    final prefs = await SharedPreferences.getInstance();
    sessionCookie = prefs.getString('session_cookie');
    print(
        'ApiClient: Loaded session cookie from SharedPreferences: $sessionCookie');
  }

  Future<void> setSessionCookie(String cookie) async {
    sessionCookie = cookie;
    print('ApiClient: Session cookie set to: $sessionCookie');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_cookie', cookie);
    print('ApiClient: Session cookie saved to SharedPreferences');
  }

  Future<void> clearSessionCookie() async {
    sessionCookie = null;
    print('ApiClient: Session cookie cleared');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_cookie');
    print('ApiClient: Session cookie removed from SharedPreferences');
  }

  Future<dynamic> get(String endpoint) async {
    print(
        'ApiClient: Making GET request to $endpoint with cookie: $sessionCookie');
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        if (sessionCookie != null) 'Cookie': sessionCookie!,
        'Content-Type': 'application/json',
      },
    );

    print(
        'ApiClient: GET response status: ${response.statusCode}, body: ${response.body}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to load data: ${response.statusCode} - ${response.body}');
    }
  }

  // Updated POST request to use named parameters for body and queryParams
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
  }) async {
    // Build the URL with query parameters if provided
    final uri = Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: queryParams,
    );

    print('ApiClient: Making POST request to $uri with body: $body');
    print('ApiClient: Headers: {'
        'Content-Type: application/json, '
        'Cookie: ${sessionCookie ?? 'none'}}');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (sessionCookie != null) 'Cookie': sessionCookie!,
      },
      body: body != null ? jsonEncode(body) : null,
    );
    print(
        'ApiClient: POST response status: ${response.statusCode}, body: ${response.body}, headers: ${response.headers}');
    return response;
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    print('ApiClient: Making PUT request to $endpoint with body: $body');
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (sessionCookie != null) 'Cookie': sessionCookie!,
      },
      body: jsonEncode(body),
    );
    print(
        'ApiClient: PUT response status: ${response.statusCode}, body: ${response.body}, headers: ${response.headers}');
    return response;
  }

  Future<dynamic> multipartPut(
    String endpoint, {
    Map<String, String>? fields,
    File? file,
  }) async {
    final request =
        http.MultipartRequest('PUT', Uri.parse('$baseUrl$endpoint'));

    if (sessionCookie != null) {
      request.headers['Cookie'] = sessionCookie!;
    }

    if (fields != null) {
      request.fields.addAll(fields);
    }

    if (file != null) {
      final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      print('ApiClient: File MIME type: $mimeType');
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType.parse(mimeType),
        ),
      );
    }

    print('ApiClient: Making multipart PUT request to $endpoint');
    print('ApiClient: Fields: $fields');
    print('ApiClient: File: ${file?.path}');

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print(
        'ApiClient: Multipart PUT response status: ${response.statusCode}, body: $responseBody');

    if (response.statusCode == 200) {
      return jsonDecode(responseBody);
    } else {
      throw Exception(
          'Failed to update data: ${response.statusCode} - $responseBody');
    }
  }
}
