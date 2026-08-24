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
      backgroundColor: const Color(0xFFF9F8F3), // Light cream background
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1B2A3B)),
        ),
        centerTitle: true,
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

          String initials = 'U';
          if (user.fullName.isNotEmpty) {
            final parts = user.fullName.split(' ');
            if (parts.length > 1) {
              initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
            } else {
              initials = user.fullName.substring(0, 1).toUpperCase();
            }
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar Squircle
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: user.avatar != null && user.avatar!.isNotEmpty
                        ? Image.network(user.avatar!, fit: BoxFit.cover)
                        : Center(
                            child: Text(
                              initials,
                              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFF488BB9)),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Name
                Text(
                  user.fullName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1B2A3B)),
                ),
                const SizedBox(height: 8),
                
                // Student Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF90C2E4), // Light blue denimish
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    user.role?.toUpperCase() ?? 'STUDENT',
                    style: const TextStyle(
                      color: Color(0xFF1B2A3B), 
                      fontWeight: FontWeight.w900, 
                      fontSize: 12, 
                      letterSpacing: 1.2
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Info Cards
                _buildInfoTile(Icons.email, 'Email', user.email ?? 'N/A'),
                _buildInfoTile(Icons.phone, 'Phone', user.phone ?? 'N/A'),
                
                const SizedBox(height: 16),
                
                // Certificates Card
                if (user.role == 'student')
                  _buildFeatureTile(
                    'My Certificates', 
                    subtitle: 'View earned', 
                    onTap: () {
                      Get.toNamed(AppRoutes.myCertificates);
                    }
                  ),
                  
                const SizedBox(height: 40),

                // Logout Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFBDDDD), Color(0xFFF5BDBD)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF5BDBD).withOpacity(0.4), 
                        blurRadius: 15, 
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    onPressed: () {
                      Get.dialog(
                        Dialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFEE2E2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 36),
                                ),
                                const SizedBox(height: 20),
                                const Text('Log Out', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B2A3B))),
                                const SizedBox(height: 12),
                                const Text('Are you sure you want to log out of your account?', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Color(0xFF64748B), height: 1.4)),
                                const SizedBox(height: 32),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () => Get.back(),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          backgroundColor: const Color(0xFFF1F5F9),
                                        ),
                                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF475569), fontSize: 16, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          Get.back();
                                          await authController.logout();
                                          Get.offAllNamed(AppRoutes.login);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFEF4444),
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          elevation: 0,
                                        ),
                                        child: const Text('Log Out', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.logout, color: Color(0xFFA51B1B)),
                        SizedBox(width: 8),
                        Text(
                          'Logout', 
                          style: TextStyle(
                            color: Color(0xFFA51B1B), 
                            fontSize: 16, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF329393), size: 28), // Teal color
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: Color(0xFF212F3D), fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile(String title, {String? subtitle, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: const TextStyle(color: Color(0xFF212F3D), fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            if (subtitle != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black54),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
