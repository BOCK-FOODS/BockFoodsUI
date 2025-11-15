import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  Map<String, String> _userData = {};

  bool get isLoggedIn => _isLoggedIn;
  Map<String, String> get userData => _userData;

  Future<bool> login({
    required String name,
    required String mobileNo,
    required String email,
    required String password,
    required String address,
  }) async {
    try {
      // Simulate API call with a small delay
      await Future.delayed(const Duration(seconds: 1));

      // Simple validation
      if (name.isEmpty ||
          mobileNo.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          address.isEmpty) {
        throw Exception('All fields are required');
      }

      if (mobileNo.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(mobileNo)) {
        throw Exception('Mobile number must be 10 digits');
      }

      if (!email.contains('@')) {
        throw Exception('Invalid email address');
      }

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      // Store user data
      _userData = {
        'name': name,
        'mobileNo': mobileNo,
        'email': email,
        'address': address,
      };

      _isLoggedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signup({
    required String name,
    required String mobileNo,
    required String email,
    required String password,
    required String address,
  }) async {
    // For this demo, signup and login are the same
    return login(
      name: name,
      mobileNo: mobileNo,
      email: email,
      password: password,
      address: address,
    );
  }

  void logout() {
    _isLoggedIn = false;
    _userData = {};
    notifyListeners();
  }
}
