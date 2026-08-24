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
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Chapter',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1B2A3B)),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Chapter Title',
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Color(0xFF4785FF), fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  GetBuilder<TeacherController>(
                    builder: (controller) {
                      return InkWell(
                        onTap: controller.isLoading ? null : () async {
                          if (titleController.text.trim().isNotEmpty) {
                            final chaptersCount = controller.currentCourse?.chapters?.length ?? 0;
                            bool success = await controller.createChapter(
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
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4785FF), Color(0xFF2052D8)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: const Color(0xFF4785FF).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3)),
                            ],
                          ),
                          child: controller.isLoading
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Add', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ],
          ),
        ),
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
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Lesson',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1B2A3B)),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7FA),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          hintText: 'Lesson Title',
                          hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7FA),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: lessonType,
                        items: const [
                          DropdownMenuItem(value: 'video', child: Text('Video', style: TextStyle(fontSize: 15))),
                          DropdownMenuItem(value: 'pdf', child: Text('PDF', style: TextStyle(fontSize: 15))),
                        ],
                        onChanged: (val) {
                          setState(() {
                            lessonType = val!;
                            filePath = null;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Lesson Type',
                          labelStyle: TextStyle(color: Colors.black38, fontSize: 13),
                          border: InputBorder.none,
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: InkWell(
                        onTap: () async {
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
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                filePath == null ? Icons.attach_file : Icons.check_circle,
                                color: filePath == null ? const Color(0xFF4785FF) : const Color(0xFF66BB6A),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                filePath == null ? 'Select File' : 'File Selected ✓',
                                style: TextStyle(
                                  color: filePath == null ? const Color(0xFF1B2A3B) : const Color(0xFF66BB6A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: Color(0xFF4785FF), fontSize: 15, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        GetBuilder<TeacherController>(
                          builder: (controller) {
                            return InkWell(
                              onTap: controller.isLoading ? null : () async {
                                if (titleController.text.trim().isNotEmpty && filePath != null) {
                                  bool success = await controller.createLesson(
                                    chapterId: chapterId,
                                    title: titleController.text.trim(),
                                    lessonType: lessonType,
                                    order: 1,
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
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF4785FF), Color(0xFF2052D8)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(color: const Color(0xFF4785FF).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3)),
                                  ],
                                ),
                                child: controller.isLoading
                                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                    : const Text('Add', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
          backgroundColor: const Color(0xFFF9F8F3),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
              child: InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF1B2A3B), size: 20),
                ),
              ),
            ),
            title: Text(
              course?.title ?? 'Loading...',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1B2A3B)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              if (course != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: InkWell(
                    onTap: () => controller.togglePublish(course.id!),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: course.isPublished == true ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            course.isPublished == true ? Icons.public : Icons.public_off,
                            color: course.isPublished == true ? const Color(0xFF66BB6A) : Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            course.isPublished == true ? 'Live' : 'Draft',
                            style: TextStyle(
                              color: course.isPublished == true ? const Color(0xFF66BB6A) : Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: controller.isLoading && course == null
              ? const Center(child: CircularProgressIndicator())
              : course == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
                            ),
                            child: const Icon(Icons.search_off, size: 48, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          const Text('Course not found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1B2A3B))),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      children: [
                        // Course thumbnail & info card
                        if (course.thumbnail != null)
                          Container(
                            height: 180,
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              image: DecorationImage(
                                image: NetworkImage(course.thumbnail!),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                              ],
                            ),
                          ),

                        // Stats row
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(Icons.menu_book, '${course.chapters?.length ?? 0}', 'Chapters'),
                              Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.2)),
                              _buildStatItem(Icons.play_lesson, '${course.lessonsCount ?? 0}', 'Lessons'),
                              Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.2)),
                              _buildStatItem(
                                Icons.circle,
                                (course.status ?? 'pending').capitalize!,
                                'Status',
                                iconColor: course.status == 'approved' ? const Color(0xFF66BB6A) : Colors.orange,
                              ),
                            ],
                          ),
                        ),

                        // Chapters header
                        Row(
                          children: [
                            const Text('Chapters', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1B2A3B))),
                            const Spacer(),
                            InkWell(
                              onTap: _showAddChapterDialog,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF4785FF), Color(0xFF2052D8)],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(color: const Color(0xFF4785FF).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add, color: Colors.white, size: 18),
                                    SizedBox(width: 4),
                                    Text('Add Chapter', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        if (course.chapters == null || course.chapters!.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(40),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))],
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.folder_open_outlined, size: 48, color: Colors.grey),
                                SizedBox(height: 12),
                                Text('No chapters yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1B2A3B))),
                                SizedBox(height: 4),
                                Text('Add one to get started!', style: TextStyle(fontSize: 13, color: Colors.grey)),
                              ],
                            ),
                          )
                        else
                          ...course.chapters!.map((chapter) => _buildChapterCard(chapter)),
                      ],
                    ),
        );
      },
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, {Color? iconColor}) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? const Color(0xFF4785FF), size: 22),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B2A3B))),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildChapterCard(ChapterModel chapter) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.menu_book_rounded, color: Color(0xFF4785FF), size: 22),
            ),
          ),
          title: Text(
            chapter.title ?? 'Chapter',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1B2A3B)),
          ),
          subtitle: Text(
            '${chapter.lessons?.length ?? 0} lessons',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          children: [
            if (chapter.lessons != null)
              ...chapter.lessons!.map((lesson) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F8F3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lesson title row
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: lesson.lessonType == 'video' ? const Color(0xFFE3F2FD) : const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            lesson.lessonType == 'video' ? Icons.play_circle_fill : Icons.picture_as_pdf,
                            color: lesson.lessonType == 'video' ? const Color(0xFF42A5F5) : const Color(0xFFEF5350),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lesson.title ?? 'Lesson',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1B2A3B)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                lesson.lessonType == 'video' ? 'Video Lesson' : 'PDF Document',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Action buttons row
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutes.lessonViewer.replaceAll(':id', lesson.id.toString()), arguments: lesson);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF4785FF).withOpacity(0.3)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.visibility_outlined, color: Color(0xFF4785FF), size: 16),
                                  SizedBox(width: 6),
                                  Text('Preview', style: TextStyle(color: Color(0xFF4785FF), fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutes.createQuiz.replaceAll(':lessonId', lesson.id.toString()));
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFFB300), Color(0xFFFFA000)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(color: const Color(0xFFFFB300).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3)),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.quiz_outlined, color: Colors.white, size: 16),
                                  SizedBox(width: 6),
                                  Text('Create Quiz', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
            
            // Add lesson button for this chapter
            InkWell(
              onTap: () => _showAddLessonDialog(chapter.id!),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF4785FF).withOpacity(0.3), width: 1.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, color: Color(0xFF4785FF), size: 18),
                    SizedBox(width: 8),
                    Text('Add Lesson', style: TextStyle(color: Color(0xFF4785FF), fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
