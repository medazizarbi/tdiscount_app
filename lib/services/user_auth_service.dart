import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserAuthService {
  String get baseUrl => dotenv.env['WC_BASE_URL'] ?? "";

  /// Logs in a user with the provided username and password.
  Future<Map<String, dynamic>> login(String username, String password) async {
    const String endpoint = "jwt-auth/v1/token"; // Adjust endpoint if needed
    final String url = "$baseUrl$endpoint";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Store data in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token'] ?? '');
      await prefs.setString('user_email', data['user_email'] ?? '');
      await prefs.setString('user_nicename', data['user_nicename'] ?? '');
      await prefs.setString(
          'user_display_name', data['user_display_name'] ?? '');

      // Fetch and store first_name and last_name after login
      await getUserInfo();

      return data;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  /// Logs out the user by clearing stored preferences.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_email');
    await prefs.remove('user_nicename');
    await prefs.remove('user_display_name');
    await prefs.remove('user_first_name');
    await prefs.remove('user_last_name');
  }

  /// Updates the authenticated user's information.
  Future<Map<String, dynamic>> updateUserInfo({
    String? name,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
  }) async {
    const String endpoint = "wp/v2/users/me";
    final String url = "$baseUrl$endpoint";

    // Get token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found.');
    }

    // Build the body with only non-null fields
    final Map<String, dynamic> body = {};
    if (name != null) body['name'] = name;
    if (firstName != null) body['first_name'] = firstName;
    if (lastName != null) body['last_name'] = lastName;
    if (email != null) body['email'] = email;
    if (password != null) body['password'] = password;

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Update prefs with all user fields if present
      if (data['name'] != null) {
        await prefs.setString('user_display_name', data['name']);
      }
      if (data['email'] != null) {
        await prefs.setString('user_email', data['email']);
      }
      if (data['first_name'] != null) {
        await prefs.setString('user_first_name', data['first_name']);
      }
      if (data['last_name'] != null) {
        await prefs.setString('user_last_name', data['last_name']);
      }

      return data;
    } else {
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  /// Fetches the authenticated user's information. using the update endpoint to get the first and last name fields
  Future<Map<String, dynamic>> getUserInfo() async {
    const String endpoint = "wp/v2/users/me";
    final String url = "$baseUrl$endpoint";

    // Get token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found.');
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Store first_name and last_name in prefs if present
      if (data['first_name'] != null) {
        await prefs.setString('user_first_name', data['first_name']);
      }
      if (data['last_name'] != null) {
        await prefs.setString('user_last_name', data['last_name']);
      }

      return data;
    } else {
      throw Exception('Failed to fetch user info: ${response.body}');
    }
  }
}
