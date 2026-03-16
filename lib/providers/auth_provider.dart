import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibaruki_mobile/core/app_constants.dart';
import 'package:sibaruki_mobile/models/user_model.dart';
import 'package:sibaruki_mobile/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final _secureStorage = const FlutterSecureStorage();
  
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(AppConstants.userDataKey);
    if (userData != null) {
      _user = UserModel.fromJson(jsonDecode(userData));
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(username, password);
      final authResponse = AuthResponse.fromJson(response.data);

      if (authResponse.status && authResponse.token != null) {
        // Store Token securely
        await _secureStorage.write(
          key: AppConstants.tokenKey, 
          value: authResponse.token
        );

        // Store User Data in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          AppConstants.userDataKey, 
          jsonEncode(authResponse.user!.toJson())
        );

        _user = authResponse.user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = authResponse.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = AppConstants.errorConnection;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: AppConstants.tokenKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userDataKey);
    _user = null;
    notifyListeners();
  }
}
