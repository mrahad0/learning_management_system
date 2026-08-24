import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:learning_management_system/data/model/lesson_model.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';
import 'package:learning_management_system/helper/route_helper.dart';
import 'package:learning_management_system/controller/quiz_controller/quiz_controller.dart';
import 'package:learning_management_system/controller/auth_controller/auth_controller.dart';

class LessonViewerScreen extends StatefulWidget {
  const LessonViewerScreen({super.key});

  @override
  State<LessonViewerScreen> createState() => _LessonViewerScreenState();
}

class _LessonViewerScreenState extends State<LessonViewerScreen> {
  late LessonModel lesson;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitializing = false;
  int? _quizId;

  @override
  void initState() {
    super.initState();
    lesson = Get.arguments as LessonModel;
    if (lesson.isVideo && lesson.videoFile != null) {
      _initializePlayer(lesson.videoFile!);
    }
    _checkQuiz();
  }

  Future<void> _checkQuiz() async {
    if (Get.isRegistered<QuizController>()) {
      _quizId = await Get.find<QuizController>().getQuizIdForLesson(lesson.id!);
      if (_quizId != null) {
        if (mounted) setState(() {});
      }
    }
  }

  Future<void> _initializePlayer(String url) async {
    setState(() => _isVideoInitializing = true);
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoPlayerController!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
      aspectRatio: _videoPlayerController!.value.aspectRatio,
      materialProgressColors: ChewieProgressColors(
        playedColor: const Color(0xFFC25E3E),
        handleColor: const Color(0xFFC25E3E),
        backgroundColor: Colors.grey,
        bufferedColor: Colors.grey[300]!,
      ),
    );
    setState(() => _isVideoInitializing = false);
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTeacher = Get.isRegistered<AuthController>() && 
                          Get.find<AuthController>().userRole == 'teacher';

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF7), // Cream background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDF7),
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
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
        title: Text(
          lesson.title ?? 'Lesson', 
          style: const TextStyle(
            color: Color(0xFF1B2A3B),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // padding for the bottom button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video Player Card
                if (lesson.isVideo)
                  Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 200,
                        color: Colors.black,
                        child: _isVideoInitializing
                            ? const Center(child: CircularProgressIndicator())
                            : _chewieController != null
                                ? Chewie(controller: _chewieController!)
                                : const Center(child: Text('Failed to load video', style: TextStyle(color: Colors.white))),
                      ),
                    ),
                  ),

                // Content Area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title ?? '', 
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1B2A3B),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Badges
                      Row(
                        children: [
                          if (lesson.durationMinutes != null) ...[
                            _buildBadge(
                              '${lesson.durationMinutes} mins', 
                              const Color(0xFFD8E6F5), // Light blue
                              const Color(0xFF2C64B5), // Dark blue
                            ),
                            const SizedBox(width: 12),
                          ],
                          _buildBadge(
                            lesson.isVideo ? 'Video' : (lesson.isPdf ? 'PDF' : 'Text'), 
                            const Color(0xFFD6EBE2), // Light mint
                            const Color(0xFF17684C), // Dark green
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Description / Content
                      Text(
                        lesson.textContent ?? 'prerequisites, Django environment configuration, etc.',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // PDF Button fallback if it's a PDF
                      if (lesson.isPdf)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
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
                            children: [
                              const Icon(Icons.picture_as_pdf, size: 48, color: Color(0xFFC25E3E)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1F2937),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  if (lesson.pdfFile != null && lesson.pdfFile!.isNotEmpty) {
                                    Get.toNamed(AppRoutes.pdfViewer, arguments: lesson.pdfFile!);
                                  } else {
                                    Get.snackbar('Error', 'PDF file URL is missing.');
                                  }
                                },
                                child: const Text('Open PDF Document', style: TextStyle(color: Colors.white)),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Quiz Button
          if (_quizId != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF37552).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF6A035), Color(0xFFF37552)],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      if (isTeacher) {
                        String route = AppRoutes.createQuiz.replaceAll(':lessonId', lesson.id.toString());
                        Get.toNamed(route);
                      } else {
                        String route = AppRoutes.takeQuiz.replaceAll(':id', _quizId.toString());
                        Get.toNamed(route);
                      }
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🎯', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(
                            isTeacher ? 'VIEW THE QUIZ!' : 'TAKE THE QUIZ!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
