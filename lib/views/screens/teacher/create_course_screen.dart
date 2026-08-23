import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:learning_management_system/controller/teacher_controller/teacher_controller.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';
import 'package:learning_management_system/views/base/custom_snackbar.dart';

class CreateCourseScreen extends StatefulWidget {
  final bool isTab;
  const CreateCourseScreen({super.key, this.isTab = false});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String? _thumbnailPath;

  void _pickImage() async {
    PlatformFile? result = await FilePicker.pickFile(
      type: FileType.image,
    );

    if (result != null && result.path != null) {
      setState(() {
        _thumbnailPath = result.path;
      });
    }
  }

  void _submit() async {
    if (_titleController.text.trim().isEmpty || _descController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    final success = await Get.find<TeacherController>().createCourse(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      thumbnailPath: _thumbnailPath,
    );

    if (success) {
      if (widget.isTab) {
        Get.offAllNamed('/teacher-home'); // Reset to teacher home
      } else {
        Get.back(); // return to dashboard
      }
      showCustomSnackBar('Course created successfully!', isError: false, getXSnackBar: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Course'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.titleColor,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: GetBuilder<TeacherController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Course Title', style: AppStyles.h5()),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Flutter for Beginners',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                
                Text('Description', style: AppStyles.h5()),
                const SizedBox(height: 8),
                TextField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'What will students learn?',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                
                Text('Thumbnail (Optional)', style: AppStyles.h5()),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickImage,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                    ),
                    child: _thumbnailPath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(File(_thumbnailPath!), fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text('Tap to select image', style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 40),
                
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: controller.isLoading ? null : _submit,
                    child: controller.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Create Course', style: TextStyle(fontSize: 16, color: Colors.white)),
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
