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

  Widget _buildTopHeader(String? thumbnail) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFDECD8), // Peach top
            Color(0xFFFDE4CD), // Slightly darker peach bottom
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Course Full Background Image
          if (thumbnail != null && thumbnail.isNotEmpty)
            Positioned.fill(
              child: Image.network(
                thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.menu_book_rounded, size: 100, color: Color(0xFFC25E3E)),
                ),
              ),
            )
          else
            const Center(
              child: Icon(Icons.menu_book_rounded, size: 100, color: Color(0xFFC25E3E)),
            ),
            
          // Custom Back Button
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(double percent) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Progress: ${percent.toInt()}%',
                style: const TextStyle(fontSize: 16, color: Color(0xFF212F3D), fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF4EE), // Light orange
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.emoji_events_outlined, color: Color(0xFFC25E3E), size: 18),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5), // Light grey background
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: (percent / 100.0).clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF6A035), Color(0xFFF37552)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.extension, color: Colors.grey, size: 24),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF7), // Matching cream background
      body: GetBuilder<StudentController>(
        builder: (controller) {
          if (controller.isLoading || controller.courseDetail == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final course = controller.courseDetail!;
          // check if enrolled
          bool isEnrolled = controller.myProgress?.any((p) => p.courseId == course.id) ?? false;
          final courseProgress = isEnrolled ? controller.myProgress!.firstWhere((p) => p.courseId == course.id) : null;
          final percent = courseProgress?.progressPercent ?? 0.0;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopHeader(course.thumbnail),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        course.title ?? 'Course Title',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1B2A3B),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'By ${course.teacherName ?? 'Teacher'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      // Progress Card or Enroll Button
                      if (isEnrolled) ...[
                        _buildProgressCard(percent),
                        if (percent < 100)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 24),
                            child: Text(
                              'Complete all lessons and quizzes to earn your certificate!',
                              style: TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC25E3E),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                icon: const Icon(Icons.workspace_premium, color: Colors.white),
                                label: const Text('View Certificate', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  Get.toNamed(AppRoutes.certificate.replaceAll(':id', course.id.toString()));
                                },
                              ),
                            ),
                          )
                      ] else ...[
                         const SizedBox(height: 24),
                         SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC25E3E),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        const SizedBox(height: 24),
                      ],

                      // Course Content Header
                      const Text(
                        'Course Content',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1B2A3B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Chapters List
                      if (course.chapters != null)
                        ...course.chapters!.map((chapter) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFDECD8), // Peach background for icon
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.folder, color: Color(0xFFA66C3E), size: 24),
                                ),
                                title: Text(
                                  chapter.title ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                                children: chapter.lessons?.map((lesson) {
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                                    leading: Icon(
                                      lesson.isVideo ? Icons.play_circle_fill : (lesson.isPdf ? Icons.picture_as_pdf : Icons.article),
                                      color: const Color(0xFFC25E3E),
                                      size: 20,
                                    ),
                                    title: Text(
                                      lesson.title ?? '', 
                                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                                    ),
                                    trailing: Text(
                                      '${lesson.durationMinutes ?? 0} min', 
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
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
                            ),
                          );
                        }).toList()
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
