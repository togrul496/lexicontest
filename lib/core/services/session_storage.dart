import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_models.dart';

class SessionStorage {
  static const _tokenKey = 'auth_token';
  static const _themeKey = 'theme';
  static const _languageKey = 'language';
  static const _userKey = 'user_json';

  Future<AppSession> load() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final theme = prefs.getString(_themeKey) ?? 'system';
    final language = prefs.getString(_languageKey) ?? 'az';
    final userJson = prefs.getString(_userKey);
    final user = userJson == null
        ? null
        : UserProfile.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    return AppSession(
      isReady: true,
      isAuthenticated: token != null && token.isNotEmpty,
      token: token,
      user: user,
      theme: theme,
      language: language,
    );
  }

  Future<void> saveSession({
    required String token,
    required UserProfile user,
    required String theme,
    required String language,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_themeKey, theme);
    await prefs.setString(_languageKey, language);
    await prefs.setString(_userKey, jsonEncode({
      'id': user.id,
      'username': user.username,
      'email': user.email,
      'role': user.role,
      'status': user.status,
      'language': user.language,
      'theme': user.theme,
      'full_name': user.fullName,
      'name': user.name,
      'surname': user.surname,
      'profile_image': user.profileImage,
    }));
  }

  Future<void> savePreferences({required String theme, required String language}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme);
    await prefs.setString(_languageKey, language);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}
