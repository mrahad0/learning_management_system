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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Create New Course',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1B2A3B)),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1B2A3B),
        elevation: 0,
      ),
      body: GetBuilder<TeacherController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Course Title', style: TextStyle(color: Color(0xFF4A5568), fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Flutter for Beginners',
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                const Text('Description', style: TextStyle(color: Color(0xFF4A5568), fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _descController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'What will students learn?',
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                const Text('Thumbnail (Optional)', style: TextStyle(color: Color(0xFF4A5568), fontSize: 14)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickImage,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFB0C4DE), width: 1.5, style: BorderStyle.solid), // Solid border since dotted isn't built-in
                      ),
                      child: _thumbnailPath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(File(_thumbnailPath!), fit: BoxFit.cover),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(color: const Color(0xFF4A89FF).withOpacity(0.3), blurRadius: 20, spreadRadius: -5)
                                    ],
                                  ),
                                  child: const Icon(Icons.cloud_upload_rounded, size: 54, color: Color(0xFF6B9CFF)),
                                ),
                                const SizedBox(height: 12),
                                const Text('Tap to select image', style: TextStyle(color: Colors.black54, fontSize: 14)),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4785FF), Color(0xFF2052D8)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF4785FF).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: controller.isLoading ? null : _submit,
                    child: controller.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Create Course', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 120), // Added padding for floating bottom nav bar
              ],
            ),
          );
        },
      ),
    );
  }
}
