import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/controller/student_controller/student_controller.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';
import 'package:learning_management_system/helper/route_helper.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<StudentController>().getApprovedCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Courses', style: AppStyles.h3(color: AppColors.titleColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GetBuilder<StudentController>(
        builder: (studentController) {
          if (studentController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (studentController.approvedCourses == null || studentController.approvedCourses!.isEmpty) {
            return Center(
              child: Text(
                'No courses available at the moment.',
                style: AppStyles.h5(color: AppColors.subtitleColor),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 800 ? 4 : constraints.maxWidth > 600 ? 3 : 2;
              
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: studentController.approvedCourses!.length,
                itemBuilder: (context, index) {
                  final course = studentController.approvedCourses![index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('${AppRoutes.studentDashboard}/course/${course.id}');
                    },
                    child: Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure children stretch to fill card width
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: course.thumbnail == null || course.thumbnail!.isEmpty
                                  ? _buildPlaceholder()
                                  : Image.network(
                                      course.thumbnail!,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.title ?? '',
                                  style: AppStyles.h5(color: AppColors.titleColor),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  course.teacherName ?? '',
                                  style: AppStyles.h6(color: AppColors.primaryColor),
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
            }
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryLight.withOpacity(0.5),
            AppColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.menu_book_rounded, size: 48, color: AppColors.primaryColor),
      ),
    );
  }
}
