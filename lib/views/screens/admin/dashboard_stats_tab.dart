import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/controller/admin_controller/admin_controller.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';

class DashboardStatsTab extends StatelessWidget {
  const DashboardStatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Admin Dashboard', style: AppStyles.h3(color: AppColors.titleColor)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GetBuilder<AdminController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = controller.dashboardStats;
          if (stats == null) {
            return Center(child: Text('No stats available', style: AppStyles.h5(color: AppColors.subtitleColor)));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.getDashboardStats();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overview', style: AppStyles.h2(color: AppColors.titleColor)),
                  const SizedBox(height: 16),
                  
                  // Total Users Grid
                  GridView.count(
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.2,
                    children: [
                      _buildStatCard('Total Users', stats['users']?['total']?.toString() ?? '0', Icons.people, Colors.blue),
                      _buildStatCard('Students', stats['users']?['students']?.toString() ?? '0', Icons.school, Colors.green),
                      _buildStatCard('Teachers', stats['users']?['teachers']?.toString() ?? '0', Icons.cast_for_education, Colors.orange),
                      _buildStatCard('Courses', stats['courses']?['total']?.toString() ?? '0', Icons.library_books, Colors.purple),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  Text('Platform Engagement', style: AppStyles.h2(color: AppColors.titleColor)),
                  const SizedBox(height: 16),
                  
                  // Engagement Grid
                  GridView.count(
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.2,
                    children: [
                      _buildStatCard('Total Lessons', stats['lessons']?.toString() ?? '0', Icons.play_lesson, Colors.teal),
                      _buildStatCard('Enrollments', stats['enrollments']?.toString() ?? '0', Icons.check_circle, Colors.indigo),
                      _buildStatCard('Certificates', stats['certificates']?.toString() ?? '0', Icons.workspace_premium, Colors.amber),
                      _buildStatCard('Quiz Subs', stats['quiz_submissions']?.toString() ?? '0', Icons.quiz, Colors.deepOrange),
                    ],
                  ),

                  const SizedBox(height: 24),
                  // Additional stat for average quiz score
                  _buildActionCard(
                    'Average Quiz Score', 
                    '${stats['avg_quiz_score']?.toString() ?? '0'}%', 
                    Icons.analytics, 
                    AppColors.primaryColor
                  ),

                  const SizedBox(height: 24),
                  Text('Action Required', style: AppStyles.h2(color: AppColors.titleColor)),
                  const SizedBox(height: 16),
                  
                  // Pending Items
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _buildActionCard('Pending Teachers', stats['users']?['pending_teachers']?.toString() ?? '0', Icons.person_add, AppColors.errorColor),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildActionCard('Pending Courses', stats['courses']?['pending']?.toString() ?? '0', Icons.pending_actions, AppColors.errorColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Bottom padding for nav bar
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Spacer(),
          Text(count, style: AppStyles.h1(color: AppColors.titleColor)),
          Text(title, style: AppStyles.h6(color: AppColors.subtitleColor)),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, String count, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(count, style: AppStyles.h2(color: AppColors.titleColor)),
                Text(title, style: AppStyles.h6(color: color)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
