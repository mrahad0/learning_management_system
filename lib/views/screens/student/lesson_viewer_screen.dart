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
        playedColor: AppColors.primaryColor,
        handleColor: AppColors.primaryColor,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title ?? 'Lesson', style: AppStyles.h4(color: AppColors.titleColor)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.titleColor),
      ),
      body: Column(
        children: [
          if (lesson.isVideo)
            Container(
              height: 250,
              color: Colors.black,
              child: _isVideoInitializing
                  ? const Center(child: CircularProgressIndicator())
                  : _chewieController != null
                      ? Chewie(controller: _chewieController!)
                      : const Center(child: Text('Failed to load video', style: TextStyle(color: Colors.white))),
            ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson.title ?? '', style: AppStyles.h3(color: AppColors.titleColor)),
                  const SizedBox(height: 16),
                  
                  if (lesson.isText)
                    Text(
                      lesson.textContent ?? 'No content available.',
                      style: AppStyles.h5(color: AppColors.subtitleColor),
                    ),

                  if (lesson.isPdf)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.picture_as_pdf, size: 48, color: AppColors.primaryColor),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Open PDF Viewer (Phase 3)
                              Get.snackbar('PDF Viewer', 'Coming Soon in next phase!');
                            },
                            child: const Text('Open PDF'),
                          )
                        ],
                      ),
                    ),
                    
                  const SizedBox(height: 24),
                  
                  if (_quizId != null)
                    Builder(
                      builder: (context) {
                        bool isTeacher = false;
                        if (Get.isRegistered<AuthController>()) {
                          isTeacher = Get.find<AuthController>().userRole == 'teacher';
                        }
                        
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              String route = AppRoutes.takeQuiz.replaceAll(':id', _quizId.toString());
                              if (isTeacher) {
                                route += '?preview=true';
                              }
                              Get.toNamed(route);
                            },
                            child: Text(isTeacher ? 'View Quiz' : 'Take Quiz', style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        );
                      }
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
