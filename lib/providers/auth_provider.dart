import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isAdmin = false;

  bool get isAuthenticated => _isAuthenticated;

  bool get isAdmin => _isAdmin;

  bool login(String username, String password) {
    if (username == 'Admin' && password == 'Admin') {
      _isAuthenticated = true;
      _isAdmin = true;
      notifyListeners();
      return true;
    } else if (username == 'User' && password == 'User') {
      _isAuthenticated = true;
      _isAdmin = false;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    _isAdmin = false;
    notifyListeners();
  }
}
