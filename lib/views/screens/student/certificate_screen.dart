import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/controller/auth_controller/auth_controller.dart';
import 'package:learning_management_system/controller/student_controller/student_controller.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  late int courseId;

  @override
  void initState() {
    super.initState();
    courseId = int.parse(Get.parameters['id']!);
    // Assuming you have a method to fetch certificate details or course details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<StudentController>().getCourseDetails(courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Your Certificate'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.titleColor,
        elevation: 0,
      ),
      body: GetBuilder<StudentController>(
        builder: (controller) {
          final course = controller.courseDetail;
          final user = Get.find<AuthController>().userModel;

          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (course == null || user == null) {
            return const Center(child: Text('Failed to load certificate'));
          }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.primaryColor, width: 10),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 5),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium, size: 80, color: Colors.amber[700]),
                    const SizedBox(height: 16),
                    Text(
                      'CERTIFICATE OF COMPLETION',
                      style: AppStyles.h1(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Text('This is proudly presented to', style: AppStyles.h4(color: Colors.grey[600])),
                    const SizedBox(height: 16),
                    Text(
                      user.fullName.toUpperCase(),
                      style: AppStyles.customSize(size: 28, color: AppColors.titleColor, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(height: 2, width: 200, color: AppColors.primaryColor),
                    const SizedBox(height: 32),
                    Text(
                      'For successfully completing the course',
                      style: AppStyles.h5(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      course.title ?? 'Course Name',
                      style: AppStyles.h2(color: AppColors.titleColor, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(course.teacherName ?? 'Instructor', style: AppStyles.h4(fontWeight: FontWeight.bold)),
                            Container(height: 1, width: 100, color: Colors.black),
                            const SizedBox(height: 4),
                            Text('Course Instructor', style: AppStyles.h6()),
                          ],
                        ),
                        Column(
                          children: [
                            Text(DateTime.now().toString().split(' ')[0], style: AppStyles.h4(fontWeight: FontWeight.bold)),
                            Container(height: 1, width: 100, color: Colors.black),
                            const SizedBox(height: 4),
                            Text('Date Completed', style: AppStyles.h6()),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
