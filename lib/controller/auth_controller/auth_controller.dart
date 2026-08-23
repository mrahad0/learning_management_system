
import 'package:get/get.dart';
import 'package:learning_management_system/data/model/login_response_model.dart';
import 'package:learning_management_system/data/model/user_model.dart';
import 'package:learning_management_system/data/repo/auth_repo.dart';
import 'package:learning_management_system/views/base/custom_snackbar.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  String _userRole = '';
  String get userRole => _userRole;

  // ─── Login ─────────────────────────────────────────────
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    update();

    Response response = await authRepo.login(username, password);

    if (response.statusCode == 200 && response.body != null) {
      LoginResponseModel loginResponse =
          LoginResponseModel.fromJson(response.body);

      // Save tokens
      await authRepo.saveTokens(
        accessToken: loginResponse.access ?? '',
        refreshToken: loginResponse.refresh ?? '',
      );

      // Save user info
      if (loginResponse.user != null) {
        _userModel = loginResponse.user;
        _userRole = loginResponse.user!.role ?? '';

        await authRepo.saveUserInfo(
          userId: loginResponse.user!.id ?? 0,
          role: _userRole,
          username: loginResponse.user!.username ?? '',
        );
      }

      _isLoading = false;
      update();
      return true;
    } else {
      _isLoading = false;
      update();
      showCustomSnackBar(
        response.statusText ?? 'Login failed',
        getXSnackBar: true,
      );
      return false;
    }
  }

  // ─── Register ──────────────────────────────────────────
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    _isLoading = true;
    update();

    Map<String, dynamic> body = {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };

    if (firstName != null && firstName.isNotEmpty) {
      body['first_name'] = firstName;
    }
    if (lastName != null && lastName.isNotEmpty) {
      body['last_name'] = lastName;
    }
    if (phone != null && phone.isNotEmpty) {
      body['phone'] = phone;
    }

    Response response = await authRepo.register(body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      _isLoading = false;
      update();
      return true;
    } else {
      _isLoading = false;
      update();
      showCustomSnackBar(
        response.statusText ?? 'Registration failed',
        getXSnackBar: true,
      );
      return false;
    }
  }

  // ─── Get Profile ───────────────────────────────────────
  Future<bool> getProfile() async {
    Response response = await authRepo.getProfile();

    if (response.statusCode == 200 && response.body != null) {
      _userModel = UserModel.fromJson(response.body);
      _userRole = _userModel?.role ?? '';
      update();
      return true;
    }
    return false;
  }

  // ─── Check Login Status ────────────────────────────────
  Future<bool> isLoggedIn() async {
    return await authRepo.isLoggedIn();
  }

  /// Get saved user role from prefs
  Future<String> getSavedRole() async {
    _userRole = await authRepo.getUserRole();
    return _userRole;
  }

  // ─── Logout ────────────────────────────────────────────
  Future<void> logout() async {
    await authRepo.clearAll();
    _userModel = null;
    _userRole = '';
    update();
  }

  // ─── Route helper based on role ────────────────────────
  String getHomeRouteForRole(String role) {
    switch (role) {
      case 'student':
        return '/student-home';
      case 'teacher':
        return '/teacher-home';
      case 'admin':
        return '/admin-home';
      default:
        return '/login';
    }
  }
}
