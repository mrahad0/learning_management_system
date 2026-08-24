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
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1B2A3B))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: GetBuilder<AdminController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = controller.dashboardStats;
          if (stats == null) {
            return const Center(child: Text('No stats available', style: TextStyle(color: Colors.grey, fontSize: 16)));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.getDashboardStats();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Platform Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1B2A3B))),
                  const SizedBox(height: 16),
                  
                  // Total Users Grid
                  GridView.count(
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.05,
                    children: [
                      _buildStatCard('Total Users', stats['users']?['total']?.toString() ?? '0', Icons.people_alt_rounded, const Color(0xFF4785FF)),
                      _buildStatCard('Students', stats['users']?['students']?.toString() ?? '0', Icons.school_rounded, const Color(0xFF22C55E)),
                      _buildStatCard('Teachers', stats['users']?['teachers']?.toString() ?? '0', Icons.cast_for_education_rounded, const Color(0xFFF59E0B)),
                      _buildStatCard('Courses', stats['courses']?['total']?.toString() ?? '0', Icons.library_books_rounded, const Color(0xFF8B5CF6)),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  const Text('Engagement Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1B2A3B))),
                  const SizedBox(height: 16),
                  
                  // Engagement Grid
                  GridView.count(
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.05,
                    children: [
                      _buildStatCard('Total Lessons', stats['lessons']?.toString() ?? '0', Icons.play_lesson_rounded, const Color(0xFF14B8A6)),
                      _buildStatCard('Enrollments', stats['enrollments']?.toString() ?? '0', Icons.check_circle_rounded, const Color(0xFF6366F1)),
                      _buildStatCard('Certificates', stats['certificates']?.toString() ?? '0', Icons.workspace_premium_rounded, const Color(0xFFEAB308)),
                      _buildStatCard('Quiz Subs', stats['quiz_submissions']?.toString() ?? '0', Icons.quiz_rounded, const Color(0xFFEC4899)),
                    ],
                  ),

                  const SizedBox(height: 16),
                  // Additional stat for average quiz score
                  _buildActionCard(
                    'Average Quiz Score', 
                    '${stats['avg_quiz_score']?.toString() ?? '0'}%', 
                    Icons.analytics_rounded, 
                    const Color(0xFF4785FF),
                  ),

                  const SizedBox(height: 32),
                  const Text('Action Required', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1B2A3B))),
                  const SizedBox(height: 16),
                  
                  // Pending Items
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _buildActionCard('Pending\nTeachers', stats['users']?['pending_teachers']?.toString() ?? '0', Icons.person_add_rounded, const Color(0xFFEF4444)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildActionCard('Pending\nCourses', stats['courses']?['pending']?.toString() ?? '0', Icons.pending_actions_rounded, const Color(0xFFEF4444)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120), // Bottom padding for nav bar
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
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count, 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1B2A3B), height: 1.1),
              ),
              const SizedBox(height: 4),
              Text(
                title, 
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, String count, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count, 
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1B2A3B), height: 1.2),
                ),
                Text(
                  title, 
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
