import 'dart:convert';

import 'package:get/get.dart';
import 'package:learning_management_system/data/api/api_client.dart';
import 'package:learning_management_system/data/api/api_constant.dart';
import 'package:learning_management_system/helper/prefs_helper.dart';
import 'package:learning_management_system/utils/app_constants.dart';

class AuthRepo {
  /// Login with username and password
  Future<Response> login(String username, String password) async {
    return await ApiClient.postData(
      ApiConstant.login,
      jsonEncode({
        'username': username,
        'password': password,
      }),
    );
  }

  /// Register a new student or teacher
  Future<Response> register(Map<String, dynamic> body) async {
    return await ApiClient.postData(
      ApiConstant.register,
      jsonEncode(body),
    );
  }

  /// Get current user profile
  Future<Response> getProfile() async {
    return await ApiClient.getData(ApiConstant.me);
  }

  /// Refresh access token
  Future<Response> refreshToken(String refreshToken) async {
    return await ApiClient.postData(
      ApiConstant.refreshToken,
      jsonEncode({'refresh': refreshToken}),
    );
  }

  // ─── Token Management ─────────────────────────────────

  /// Save tokens after login
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await PrefsHelper.setString(AppConstants.bearerToken, accessToken);
    await PrefsHelper.setString(AppConstants.refreshToken, refreshToken);
    await PrefsHelper.setBool(AppConstants.isLoggedIn, true);
  }

  /// Save user info after login
  Future<void> saveUserInfo({
    required int userId,
    required String role,
    required String username,
  }) async {
    await PrefsHelper.setInt(AppConstants.userId, userId);
    await PrefsHelper.setString(AppConstants.userRole, role);
    await PrefsHelper.setString(AppConstants.username, username);
  }

  /// Get stored access token
  Future<String> getAccessToken() async {
    return await PrefsHelper.getString(AppConstants.bearerToken);
  }

  /// Get stored user role
  Future<String> getUserRole() async {
    return await PrefsHelper.getString(AppConstants.userRole);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await PrefsHelper.getBool(AppConstants.isLoggedIn);
  }

  /// Clear all stored data (logout)
  Future<void> clearAll() async {
    await PrefsHelper.remove(AppConstants.bearerToken);
    await PrefsHelper.remove(AppConstants.refreshToken);
    await PrefsHelper.remove(AppConstants.userId);
    await PrefsHelper.remove(AppConstants.userRole);
    await PrefsHelper.remove(AppConstants.username);
    await PrefsHelper.setBool(AppConstants.isLoggedIn, false);
  }
}
