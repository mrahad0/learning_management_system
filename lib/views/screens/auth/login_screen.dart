import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/controller/auth_controller/auth_controller.dart';
import 'package:learning_management_system/helper/route_helper.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';
import 'package:learning_management_system/views/base/custom_button.dart';
import 'package:learning_management_system/views/base/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final AuthController authController = Get.find<AuthController>();
    final bool success = await authController.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      final route =
          authController.getHomeRouteForRole(authController.userRole);
      Get.offAllNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ─── Header ──────────────────────────────
              _buildHeader(),

              // ─── Form ────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32.h),

                      // Welcome text
                      Text(
                        'Welcome Back',
                        style: AppStyles.h1(
                          color: AppColors.titleColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Sign in to continue your learning journey',
                        style: AppStyles.h5(
                          color: AppColors.subtitleColor,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Username field
                      _buildLabel('Username'),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: _usernameController,
                        hintText: 'Enter your username',
                        isOutlined: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Icon(Icons.person_outline_rounded, size: 22.w),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Password field
                      _buildLabel('Password'),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Enter your password',
                        isPassword: true,
                        isOutlined: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Icon(Icons.lock_outline_rounded, size: 22.w),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 32.h),

                      // Login Button
                      GetBuilder<AuthController>(
                        builder: (controller) {
                          return CustomButton(
                            text: 'Sign In',
                            loading: controller.isLoading,
                            onTap: _handleLogin,
                            height: 52.h,
                            radius: 12.r,
                          );
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Register link
                      Center(
                        child: GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.register),
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: AppStyles.h5(
                                color: AppColors.subtitleColor,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: AppStyles.h5(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 48.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E40AF),
            AppColors.primaryColor,
            Color(0xFF3B82F6),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // App Icon
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              Icons.school_rounded,
              size: 40.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'EduBD',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Learning Management System',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppStyles.h5(
        color: AppColors.titleColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
