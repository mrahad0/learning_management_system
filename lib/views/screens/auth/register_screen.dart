import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/controller/auth_controller/auth_controller.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';
import 'package:learning_management_system/views/base/custom_button.dart';
import 'package:learning_management_system/views/base/custom_snackbar.dart';
import 'package:learning_management_system/views/base/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedRole = 'student';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final AuthController authController = Get.find<AuthController>();
    final bool success = await authController.register(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
      role: _selectedRole,
    );

    if (success) {
      Get.back(); // Go back to login
      showCustomSnackBar('Registration successful! Please login.', isError: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Premium Gradient Background Header
            Container(
              height: 380.h,
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
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))
                        ],
                      ),
                      child: Icon(Icons.person_add_alt_1_rounded, size: 40.sp, color: Colors.white),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Join our learning community today',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Floating Form Card
            Container(
              margin: EdgeInsets.only(top: 300.h, left: 24.w, right: 24.w, bottom: 40.h),
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
                    // Role Selection
                    Text('I want to register as a:', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: const Color(0xFF334155))),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildRoleCard(
                            title: 'Student',
                            icon: Icons.person_outline_rounded,
                            value: 'student',
                            color: const Color(0xFF3B82F6),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildRoleCard(
                            title: 'Teacher',
                            icon: Icons.school_outlined,
                            value: 'teacher',
                            color: const Color(0xFF8B5CF6),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // First & Last Name
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('First Name', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF334155))),
                              SizedBox(height: 8.h),
                              CustomTextField(
                                controller: _firstNameController,
                                hintText: 'John',
                                isOutlined: true,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Last Name', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF334155))),
                              SizedBox(height: 8.h),
                              CustomTextField(
                                controller: _lastNameController,
                                hintText: 'Doe',
                                isOutlined: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    Text('Username*', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF334155))),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _usernameController,
                      hintText: 'johndoe123',
                      isOutlined: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Icon(Icons.alternate_email_rounded, size: 20.w, color: const Color(0xFF94A3B8)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Username is required';
                        if (!RegExp(r'^[\w.@+-]+$').hasMatch(value)) return 'Letters, digits and @/./+/-/_ only';
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    Text('Email', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF334155))),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'john@example.com',
                      isOutlined: true,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Icon(Icons.email_outlined, size: 20.w, color: const Color(0xFF94A3B8)),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Text('Phone', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF334155))),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _phoneController,
                      hintText: '+8801...',
                      isOutlined: true,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Icon(Icons.phone_outlined, size: 20.w, color: const Color(0xFF94A3B8)),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Text('Password*', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF334155))),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Min 6 characters',
                      isPassword: true,
                      isOutlined: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Icon(Icons.lock_outline_rounded, size: 20.w, color: const Color(0xFF94A3B8)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Password is required';
                        if (value.length < 6) return 'Must be at least 6 characters';
                        return null;
                      },
                    ),
                    SizedBox(height: 32.h),

                    // Register Button
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
                            onPressed: controller.isLoading ? null : _handleRegister,
                            child: controller.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text('Sign Up', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                          ),
                        );
                      },
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

  Widget _buildRoleCard({
    required String title,
    required IconData icon,
    required String value,
    required Color color,
  }) {
    final bool isSelected = _selectedRole == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : const Color(0xFF94A3B8),
              size: 32.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: isSelected ? color : const Color(0xFF64748B),
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
