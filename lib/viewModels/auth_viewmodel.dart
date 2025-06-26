import 'package:flutter/material.dart';
import '../services/user_auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final UserAuthService _authService = UserAuthService();

  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? userData;

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
}
