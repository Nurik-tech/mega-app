// TODO Implement this library.
import 'package:flutter/material.dart';
import '../services/auth_service.dart';  // go one folder up, then into services

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLogin() async {
    _isLoggedIn = await _authService.isLoggedIn();
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    bool success = await _authService.login(username, password);
    if (success) {
      _isLoggedIn = true;
      notifyListeners();
    }
    return success;
  }

  Future<bool> register(String username, String password) async {
    bool success = await _authService.register(username, password);
    if (success) {
      _isLoggedIn = true;
      notifyListeners();
    }
    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}
