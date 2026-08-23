import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/controller/student_controller/student_controller.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';
import 'package:learning_management_system/helper/route_helper.dart';

class MyCoursesTab extends StatefulWidget {
  const MyCoursesTab({super.key});

  @override
  State<MyCoursesTab> createState() => _MyCoursesTabState();
}

class _MyCoursesTabState extends State<MyCoursesTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<StudentController>().getMyProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Courses', style: AppStyles.h3(color: AppColors.titleColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GetBuilder<StudentController>(
        builder: (studentController) {
          if (studentController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (studentController.myProgress == null || studentController.myProgress!.isEmpty) {
            return Center(
              child: Text(
                'You are not enrolled in any courses yet.',
                style: AppStyles.h5(color: AppColors.subtitleColor),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: studentController.myProgress!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final progress = studentController.myProgress![index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed('${AppRoutes.studentDashboard}/course/${progress.courseId}');
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primaryLight,
                        ),
                        child: const Icon(Icons.menu_book, color: AppColors.primaryColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              progress.courseTitle ?? 'Course Name',
                              style: AppStyles.h5(color: AppColors.titleColor),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: (progress.progressPercent ?? 0) / 100,
                                      backgroundColor: Colors.grey[200],
                                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.successColor),
                                      minHeight: 8,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${(progress.progressPercent ?? 0).toStringAsFixed(0)}%',
                                  style: AppStyles.h6(color: AppColors.subtitleColor),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
