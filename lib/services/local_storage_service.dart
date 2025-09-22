import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class LocalStorageService {
  static const String _userKey = 'user_data';
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;

  LocalStorageService._();

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Save user data
  Future<bool> saveUser(UserModel user) async {
    final String userJson = jsonEncode(user.toJson());
    return await _preferences!.setString(_userKey, userJson);
  }

  // Get user data
  UserModel? getUser() {
    final String? userJson = _preferences?.getString(_userKey);
    if (userJson == null) return null;

    try {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return UserModel.fromJson(userMap);
    } catch (e) {
      print('Error parsing user data: $e');
      return null;
    }
  }

  // Clear user data (for logout)
  Future<bool> clearUser() async {
    return await _preferences!.remove(_userKey);
  }

  // Check if user is logged in
  bool isUserLoggedIn() {
    return _preferences?.getString(_userKey) != null;
  }
}
