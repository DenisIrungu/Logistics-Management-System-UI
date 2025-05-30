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

  // Updated POST request to support form-data or JSON
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    bool useFormData =
        false, // New parameter to switch between JSON and form-data
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: queryParams,
    );

    print(
        'ApiClient: Making POST request to $uri with body: $body, useFormData: $useFormData');
    print('ApiClient: Headers: {'
        'Cookie: ${sessionCookie ?? 'none'}}');

    http.Response response;
    if (useFormData && body != null) {
      final request = http.MultipartRequest('POST', uri)
        ..fields
            .addAll(body.map((key, value) => MapEntry(key, value.toString())))
        ..headers.addAll({
          if (sessionCookie != null) 'Cookie': sessionCookie!,
        });
      final streamedResponse = await request.send();
      response = await http.Response.fromStream(streamedResponse);
    } else {
      response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie!,
        },
        body: body != null ? jsonEncode(body) : null,
      );
    }

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

  // Replace the existing multipartPut method in api_client.dart
  Future<dynamic> multipartPut(
    String endpoint, {
    Map<String, String>? fields,
    Map<String, File>? files,
  }) async {
    final request =
        http.MultipartRequest('PUT', Uri.parse('$baseUrl$endpoint'));

    if (sessionCookie != null) {
      request.headers['Cookie'] = sessionCookie!;
    }

    if (fields != null) {
      request.fields.addAll(fields);
    }

    if (files != null) {
      for (var entry in files.entries) {
        final file = entry.value;
        final mimeType = lookupMimeType(file.path) ?? 'application/pdf';
        print('ApiClient: File MIME type for ${entry.key}: $mimeType');
        request.files.add(
          await http.MultipartFile.fromPath(
            entry
                .key, // Use the map key as the field name (e.g., 'driving_license')
            file.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }
    }

    print('ApiClient: Making multipart PUT request to $endpoint');
    print('ApiClient: Fields: $fields');
    print('ApiClient: Files: ${files?.keys.join(", ")}');

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
