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
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.titleColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Create Account',
          style: AppStyles.h3(
            color: AppColors.titleColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Role Selection ──────────────────────
                _buildLabel('I want to register as a:'),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildRoleCard(
                        title: 'Student',
                        icon: Icons.person_outline_rounded,
                        value: 'student',
                        color: AppColors.studentColor,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildRoleCard(
                        title: 'Teacher',
                        icon: Icons.school_outlined,
                        value: 'teacher',
                        color: AppColors.teacherColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // ─── Form Fields ─────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('First Name'),
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
                          _buildLabel('Last Name'),
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

                _buildLabel('Username*'),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _usernameController,
                  hintText: 'johndoe123',
                  isOutlined: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required';
                    }
                    if (!RegExp(r'^[\w.@+-]+$').hasMatch(value)) {
                      return 'Letters, digits and @/./+/-/_ only';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                _buildLabel('Email'),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'john@example.com',
                  isOutlined: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.h),

                _buildLabel('Phone'),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _phoneController,
                  hintText: '+8801...',
                  isOutlined: true,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16.h),

                _buildLabel('Password*'),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Min 6 characters',
                  isPassword: true,
                  isOutlined: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.h),

                // ─── Register Button ─────────────────────
                GetBuilder<AuthController>(
                  builder: (controller) {
                    return CustomButton(
                      text: 'Sign Up',
                      loading: controller.isLoading,
                      onTap: _handleRegister,
                      height: 52.h,
                      radius: 12.r,
                    );
                  },
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
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
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? color : AppColors.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColors.captionColor,
              size: 32.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: AppStyles.h5(
                color: isSelected ? color : AppColors.subtitleColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
