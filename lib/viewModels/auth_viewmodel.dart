import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final UserAuthService _authService = UserAuthService();

  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? userData;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  AuthViewModel() {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    _isLoggedIn = token != null && token.isNotEmpty;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      userData = await _authService.login(username, password);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();
    await _authService.logout();
    userData = null;
    isLoading = false;
    notifyListeners();
  }

  Future<bool> updateUserInfo({
    String? name,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final updatedData = await _authService.updateUserInfo(
        name: name,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      userData = updatedData;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, String>> getUserInfoFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'first_name': prefs.getString('user_first_name') ?? '',
      'last_name': prefs.getString('user_last_name') ?? '',
      'display_name': prefs.getString('user_display_name') ?? '',
      'email': prefs.getString('user_email') ?? '',
    };
  }

  // Call this after login/logout to update state
  Future<void> setLoggedIn(bool value) async {
    _isLoggedIn = value;
    notifyListeners();
  }
}
