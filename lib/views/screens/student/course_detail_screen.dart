import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/controller/student_controller/student_controller.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';
import 'package:learning_management_system/helper/route_helper.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late int courseId;

  @override
  void initState() {
    super.initState();
    courseId = int.parse(Get.parameters['id'] ?? '0');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<StudentController>().getCourseDetails(courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<StudentController>(
        builder: (controller) {
          if (controller.isLoading || controller.courseDetail == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final course = controller.courseDetail!;
          // check if enrolled
          bool isEnrolled = controller.myProgress?.any((p) => p.courseId == course.id) ?? false;
          final courseProgress = isEnrolled ? controller.myProgress!.firstWhere((p) => p.courseId == course.id) : null;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: (course.thumbnail == null || course.thumbnail!.isEmpty)
                      ? _buildPlaceholder()
                      : Image.network(
                          course.thumbnail!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course.title ?? '', style: AppStyles.h3(color: AppColors.titleColor)),
                      const SizedBox(height: 8),
                      Text('By ${course.teacherName ?? ''}', style: AppStyles.h5(color: AppColors.primaryColor)),
                      const SizedBox(height: 16),
                      Text(course.description ?? '', style: AppStyles.h5(color: AppColors.subtitleColor)),
                      const SizedBox(height: 24),
                      if (!isEnrolled)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: controller.isEnrolling
                                ? null
                                : () async {
                                    bool success = await controller.enrollInCourse(course.id!);
                                    if (success) {
                                      setState(() {}); // refresh UI to show enrolled
                                    }
                                  },
                            child: controller.isEnrolling
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Enroll Now', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      if (isEnrolled && courseProgress != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Progress: ${courseProgress.progressPercent?.toStringAsFixed(0) ?? '0'}%',
                                style: AppStyles.h5(color: AppColors.titleColor),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: (courseProgress.progressPercent ?? 0) / 100.0,
                                backgroundColor: Colors.grey[200],
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              if (courseProgress.progressPercent == 100)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber[600],
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      icon: const Icon(Icons.workspace_premium, color: Colors.white),
                                      label: const Text('View Certificate', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                      onPressed: () {
                                        Get.toNamed(AppRoutes.certificate.replaceAll(':id', course.id.toString()));
                                      },
                                    ),
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Complete all lessons and quizzes to earn your certificate!',
                                    style: AppStyles.h6(color: AppColors.subtitleColor),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),
                      Text('Course Content', style: AppStyles.h4(color: AppColors.titleColor)),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              if (course.chapters != null)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final chapter = course.chapters![index];
                      return Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: Text(chapter.title ?? '', style: AppStyles.h5(color: AppColors.titleColor)),
                          children: chapter.lessons?.map((lesson) {
                            return ListTile(
                              leading: Icon(
                                lesson.isVideo ? Icons.play_circle_fill : (lesson.isPdf ? Icons.picture_as_pdf : Icons.article),
                                color: AppColors.primaryColor,
                              ),
                              title: Text(lesson.title ?? '', style: AppStyles.h5(color: AppColors.titleColor)),
                              trailing: Text('${lesson.durationMinutes ?? 0} min', style: AppStyles.h6(color: AppColors.subtitleColor)),
                              onTap: () {
                                if (isEnrolled) {
                                  Get.toNamed('${AppRoutes.studentDashboard}/lesson/${lesson.id}', arguments: lesson);
                                } else {
                                  Get.snackbar('Access Denied', 'Please enroll in the course to view lessons.', backgroundColor: Colors.red, colorText: Colors.white);
                                }
                              },
                            );
                          }).toList() ?? [],
                        ),
                      );
                    },
                    childCount: course.chapters!.length,
                  ),
                ),
            ],
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
        child: Icon(Icons.menu_book_rounded, size: 64, color: AppColors.primaryColor),
      ),
    );
  }
}
