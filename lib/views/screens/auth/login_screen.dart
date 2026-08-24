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
      final route = authController.getHomeRouteForRole(authController.userRole);
      Get.offAllNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Premium Gradient Background Header
            Container(
              height: 400.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1E40AF),
                    Color(0xFF3B82F6),
                    Color(0xFF60A5FA),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))
                        ],
                      ),
                      child: Icon(Icons.school_rounded, size: 48.sp, color: Colors.white),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'EduBD',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Learning Management System',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Floating Form Card
            Container(
              margin: EdgeInsets.only(top: 320.h, left: 24.w, right: 24.w, bottom: 40.h),
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32.r),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 12))
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back',
                      style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800, color: const Color(0xFF1E293B)),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Sign in to continue your journey',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: const Color(0xFF64748B)),
                    ),
                    SizedBox(height: 32.h),

                    // Username
                    Text('Username', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: const Color(0xFF334155))),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: _usernameController,
                      hintText: 'Enter your username',
                      isOutlined: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Icon(Icons.person_outline_rounded, size: 22.w, color: const Color(0xFF94A3B8)),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? 'Username is required' : null,
                    ),
                    SizedBox(height: 24.h),

                    // Password
                    Text('Password', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: const Color(0xFF334155))),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Enter your password',
                      isPassword: true,
                      isOutlined: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Icon(Icons.lock_outline_rounded, size: 22.w, color: const Color(0xFF94A3B8)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Password is required';
                        if (value.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    SizedBox(height: 40.h),

                    // Login Button
                    GetBuilder<AuthController>(
                      builder: (controller) {
                        return Container(
                          width: double.infinity,
                          height: 56.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            boxShadow: [
                              BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                            ),
                            onPressed: controller.isLoading ? null : _handleLogin,
                            child: controller.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text('Sign In', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 32.h),

                    // Register link
                    Center(
                      child: GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.register),
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(fontSize: 15.sp, color: const Color(0xFF64748B), fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(fontSize: 15.sp, color: const Color(0xFF3B82F6), fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
