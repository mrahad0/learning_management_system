import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/controller/student_controller/student_controller.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';
import 'package:learning_management_system/helper/route_helper.dart';

class MyCertificatesScreen extends StatefulWidget {
  const MyCertificatesScreen({super.key});

  @override
  State<MyCertificatesScreen> createState() => _MyCertificatesScreenState();
}

class _MyCertificatesScreenState extends State<MyCertificatesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<StudentController>().getMyCertificates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Certificates', style: AppStyles.h3(color: AppColors.titleColor)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.titleColor),
      ),
      body: GetBuilder<StudentController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.myCertificates == null || controller.myCertificates!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.workspace_premium_outlined, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No Certificates Yet',
                      style: AppStyles.h3(color: AppColors.titleColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete courses to earn your certificates!',
                      textAlign: TextAlign.center,
                      style: AppStyles.h5(color: AppColors.subtitleColor),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.myCertificates!.length,
            itemBuilder: (context, index) {
              final cert = controller.myCertificates![index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.workspace_premium, color: Colors.amber[800], size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cert.courseTitle ?? 'Unknown Course', style: AppStyles.h5(color: AppColors.titleColor)),
                            const SizedBox(height: 4),
                            Text('Issued: ${cert.issuedAt?.split('T').first ?? 'N/A'}', style: AppStyles.h6(color: AppColors.subtitleColor)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.download, color: AppColors.primaryColor),
                        onPressed: () {
                          if (cert.course != null) {
                            Get.toNamed(AppRoutes.certificate.replaceAll(':id', cert.course.toString()));
                          }
                        },
                      )
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
