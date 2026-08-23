import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/controller/admin_controller/admin_controller.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';
import 'package:learning_management_system/data/model/user_model.dart';
import 'package:learning_management_system/data/model/course_model.dart';

class ApprovalsTab extends StatelessWidget {
  const ApprovalsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Pending Approvals', style: AppStyles.h3(color: AppColors.titleColor)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GetBuilder<AdminController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final pendingTeachers = controller.pendingTeachers ?? [];
          final pendingCourses = controller.pendingCourses ?? [];

          if (pendingTeachers.isEmpty && pendingCourses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 80, color: Colors.green[300]),
                  const SizedBox(height: 16),
                  Text('All caught up!', style: AppStyles.h2(color: AppColors.titleColor)),
                  const SizedBox(height: 8),
                  Text('There are no pending approvals.', style: AppStyles.h5(color: AppColors.subtitleColor)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.getPendingApprovals();
            },
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                if (pendingTeachers.isNotEmpty) ...[
                  Text('Pending Teachers (${pendingTeachers.length})', style: AppStyles.h3(color: AppColors.titleColor)),
                  const SizedBox(height: 8),
                  ...pendingTeachers.map((t) => _buildTeacherCard(t, controller)),
                  const SizedBox(height: 24),
                ],
                if (pendingCourses.isNotEmpty) ...[
                  Text('Pending Courses (${pendingCourses.length})', style: AppStyles.h3(color: AppColors.titleColor)),
                  const SizedBox(height: 8),
                  ...pendingCourses.map((c) => _buildCourseCard(c, controller)),
                ],
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeacherCard(UserModel teacher, AdminController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: Text(teacher.firstName?.substring(0, 1).toUpperCase() ?? 'U', style: const TextStyle(color: AppColors.primaryColor)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${teacher.firstName} ${teacher.lastName}', style: AppStyles.h4(color: AppColors.titleColor)),
                  Text(teacher.email ?? '', style: AppStyles.h6(color: AppColors.subtitleColor)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => controller.approveTeacher(teacher.id!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Approve', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(CourseModel course, AdminController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course.title ?? 'Untitled', style: AppStyles.h4(color: AppColors.titleColor)),
                      Text('By ${course.teacherName}', style: AppStyles.h6(color: AppColors.primaryColor)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('Pending', style: TextStyle(color: Colors.amber[900], fontSize: 12)),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => controller.rejectCourse(course.id!),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.errorColor,
                      side: const BorderSide(color: AppColors.errorColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.approveCourse(course.id!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Approve', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
