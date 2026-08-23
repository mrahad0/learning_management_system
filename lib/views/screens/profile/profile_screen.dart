import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/controller/auth_controller/auth_controller.dart';
import 'package:learning_management_system/helper/route_helper.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppStyles.h3(color: AppColors.titleColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GetBuilder<AuthController>(
        initState: (state) {
          Get.find<AuthController>().getProfile();
        },
        builder: (authController) {
          final user = authController.userModel;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryLight,
                  backgroundImage: user.avatar != null && user.avatar!.isNotEmpty
                      ? NetworkImage(user.avatar!)
                      : null,
                  child: user.avatar == null || user.avatar!.isEmpty
                      ? Text(
                          user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                          style: AppStyles.h1(color: AppColors.primaryColor),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                
                // Name and Role
                Text(
                  user.fullName,
                  style: AppStyles.h3(color: AppColors.titleColor),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.role?.toUpperCase() ?? 'USER',
                    style: AppStyles.h6(color: AppColors.primaryColor),
                  ),
                ),
                const SizedBox(height: 32),

                // Info Cards
                _buildInfoTile(Icons.email_outlined, 'Email', user.email ?? 'N/A'),
                const SizedBox(height: 16),
                _buildInfoTile(Icons.phone_outlined, 'Phone', user.phone ?? 'N/A'),
                const SizedBox(height: 32),
                if (user.role == 'student')
                  _buildFeatureTile(
                    Icons.workspace_premium, 
                    'My Certificates', 
                    subtitle: 'View earned', 
                    onTap: () {
                      Get.toNamed(AppRoutes.myCertificates);
                    }
                  ),
                  
                const SizedBox(height: 32),

                const SizedBox(height: 32),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                      foregroundColor: Colors.redAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await authController.logout();
                      Get.offAllNamed(AppRoutes.login);
                    },
                    child: const Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStyles.h6(color: AppColors.subtitleColor)),
              const SizedBox(height: 4),
              Text(value, style: AppStyles.h5(color: AppColors.titleColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, {String? subtitle, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[400]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: AppStyles.h5(color: Colors.grey[600]!)),
            ),
            if (subtitle != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(subtitle, style: AppStyles.h6(color: Colors.grey[600]!)),
              ),
            if (onTap != null)
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
