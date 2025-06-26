import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserAuthService {
  final String baseUrl =
      "https://tdiscount.tn/wp-json/"; // Replace with your API base URL

  /// Logs in a user with the provided username and password.
  Future<Map<String, dynamic>> login(String username, String password) async {
    const String endpoint = "jwt-auth/v1/token"; // Adjust endpoint if needed
    final String url = "$baseUrl$endpoint";

    print('🔑 [LOGIN] Called with username: $username, password: $password');

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

    print('🔑 [LOGIN] Response status: ${response.statusCode}');
    print('🔑 [LOGIN] Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Store data in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token'] ?? '');
      await prefs.setString('user_email', data['user_email'] ?? '');
      await prefs.setString('user_nicename', data['user_nicename'] ?? '');
      await prefs.setString(
          'user_display_name', data['user_display_name'] ?? '');

      // Console log to see the prefs data
      print('🔒 [PREFS] token: ${prefs.getString('token')}');
      print('🔒 [PREFS] user_email: ${prefs.getString('user_email')}');
      print('🔒 [PREFS] user_nicename: ${prefs.getString('user_nicename')}');
      print(
          '🔒 [PREFS] user_display_name: ${prefs.getString('user_display_name')}');

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

    // Console log to confirm removal
    print('🔒 [LOGOUT] User data cleared from SharedPreferences');
  }
}
