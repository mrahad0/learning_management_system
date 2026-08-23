import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:learning_management_system/controller/teacher_controller/teacher_controller.dart';
import 'package:learning_management_system/data/model/course_model.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';
import 'package:learning_management_system/helper/route_helper.dart';
import 'package:learning_management_system/views/base/custom_snackbar.dart';

class ManageCourseScreen extends StatefulWidget {
  const ManageCourseScreen({super.key});

  @override
  State<ManageCourseScreen> createState() => _ManageCourseScreenState();
}

class _ManageCourseScreenState extends State<ManageCourseScreen> {
  late int courseId;

  @override
  void initState() {
    super.initState();
    courseId = int.parse(Get.parameters['id']!);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<TeacherController>().getCourseDetail(courseId);
    });
  }

  void _showAddChapterDialog() {
    final titleController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Add Chapter'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: 'Chapter Title'),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isNotEmpty) {
                final chaptersCount = Get.find<TeacherController>().currentCourse?.chapters?.length ?? 0;
                bool success = await Get.find<TeacherController>().createChapter(
                  courseId: courseId,
                  title: titleController.text.trim(),
                  order: chaptersCount + 1,
                );
                if (success) {
                  Get.back();
                  showCustomSnackBar('Chapter created successfully!', isError: false);
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddLessonDialog(int chapterId) {
    final titleController = TextEditingController();
    String lessonType = 'video';
    String? filePath;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Lesson'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(hintText: 'Lesson Title'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: lessonType,
                    items: const [
                      DropdownMenuItem(value: 'video', child: Text('Video')),
                      DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        lessonType = val!;
                        filePath = null; // reset file when type changes
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Lesson Type'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.attach_file),
                    label: Text(filePath == null ? 'Select File' : 'File Selected'),
                    onPressed: () async {
                      PlatformFile? result = await FilePicker.pickFile(
                        type: FileType.custom,
                        allowedExtensions: lessonType == 'video' ? ['mp4', 'mkv', 'avi'] : ['pdf'],
                      );
                      if (result != null && result.path != null) {
                        setState(() {
                          filePath = result.path;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.trim().isNotEmpty && filePath != null) {
                    bool success = await Get.find<TeacherController>().createLesson(
                      chapterId: chapterId,
                      title: titleController.text.trim(),
                      lessonType: lessonType,
                      order: 1, // backend or controller can handle ordering
                      filePath: filePath,
                    );
                    if (success) {
                      Get.back();
                      showCustomSnackBar('Lesson created successfully!', isError: false);
                    }
                  } else {
                    Get.snackbar('Error', 'Please enter title and select a file');
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TeacherController>(
      builder: (controller) {
        final course = controller.currentCourse;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(course?.title ?? 'Loading...', style: AppStyles.h3(color: AppColors.titleColor)),
            backgroundColor: Colors.white,
            foregroundColor: AppColors.titleColor,
            elevation: 0,
            actions: [
              if (course != null)
                IconButton(
                  icon: Icon(
                    course.isPublished == true ? Icons.public : Icons.public_off,
                    color: course.isPublished == true ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    controller.togglePublish(course.id!);
                  },
                  tooltip: 'Toggle Publish Status',
                ),
            ],
          ),
          body: controller.isLoading && course == null
              ? const Center(child: CircularProgressIndicator())
              : course == null
                  ? const Center(child: Text('Course not found'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Course Header info
                        Row(
                          children: [
                            Text('Chapters', style: AppStyles.h2(color: AppColors.titleColor)),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: _showAddChapterDialog,
                              icon: const Icon(Icons.add),
                              label: const Text('Add Chapter'),
                            )
                          ],
                        ),
                        const Divider(),
                        
                        if (course.chapters == null || course.chapters!.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Center(child: Text('No chapters yet. Add one to get started.')),
                          )
                        else
                          ...course.chapters!.map((chapter) => _buildChapterCard(chapter)),
                      ],
                    ),
        );
      },
    );
  }

  Widget _buildChapterCard(ChapterModel chapter) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ExpansionTile(
        title: Text(chapter.title ?? 'Chapter', style: AppStyles.h4(color: AppColors.titleColor)),
        children: [
          if (chapter.lessons != null)
            ...chapter.lessons!.map((lesson) => ListTile(
                  leading: Icon(
                    lesson.lessonType == 'video' ? Icons.play_circle_outline : Icons.picture_as_pdf,
                    color: AppColors.primaryColor,
                  ),
                  title: Text(lesson.title ?? 'Lesson'),
                  onTap: () {
                    // Let the teacher preview the lesson
                    Get.toNamed(AppRoutes.lessonViewer.replaceAll(':id', lesson.id.toString()), arguments: lesson);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Add Quiz Button inside lesson row
                      IconButton(
                        icon: const Icon(Icons.quiz_outlined, color: Colors.orange),
                        tooltip: 'Add Quiz to Lesson',
                        onPressed: () {
                           Get.toNamed(AppRoutes.createQuiz.replaceAll(':lessonId', lesson.id.toString()));
                        },
                      ),
                    ],
                  ),
                )),
          
          // Add lesson button for this chapter
          ListTile(
            leading: const Icon(Icons.add_circle_outline, color: Colors.blue),
            title: const Text('Add Lesson', style: TextStyle(color: Colors.blue)),
            onTap: () => _showAddLessonDialog(chapter.id!),
          ),
        ],
      ),
    );
  }
}
