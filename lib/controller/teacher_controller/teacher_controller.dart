import 'package:get/get.dart';
import 'package:learning_management_system/data/model/course_model.dart';
import 'package:learning_management_system/data/repo/teacher_repo.dart';
import 'package:learning_management_system/data/repo/course_repo.dart';
import 'package:learning_management_system/views/base/custom_snackbar.dart';

class TeacherController extends GetxController {
  final TeacherRepo teacherRepo;
  final CourseRepo courseRepo;

  TeacherController({required this.teacherRepo, required this.courseRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CourseModel> _myCourses = [];
  List<CourseModel> get myCourses => _myCourses;

  CourseDetailModel? _currentCourse;
  CourseDetailModel? get currentCourse => _currentCourse;

  // ─── Get Courses ─────────────────────────────────────
  Future<void> getMyCourses() async {
    _isLoading = true;
    update();

    Response response = await courseRepo.getMyCourses();
    if (response.statusCode == 200) {
      _myCourses = [];
      if (response.body != null) {
        final dataList = response.body is List ? response.body : response.body['results'];
        if (dataList != null) {
          dataList.forEach((data) {
            _myCourses.add(CourseModel.fromJson(data));
          });
        }
      }
    } else {
      showCustomSnackBar(response.statusText ?? 'Failed to get courses', getXSnackBar: true);
    }

    _isLoading = false;
    update();
  }

  // ─── Create Course ───────────────────────────────────
  Future<bool> createCourse({
    required String title,
    required String description,
    String? thumbnailPath,
  }) async {
    _isLoading = true;
    update();

    Map<String, String> body = {
      'title': title,
      'description': description,
    };

    Response response = await teacherRepo.createCourse(body, imagePath: thumbnailPath);

    _isLoading = false;
    update();

    if (response.statusCode == 201 || response.statusCode == 200) {
      getMyCourses();
      return true;
    } else {
      showCustomSnackBar(response.statusText ?? 'Failed to create course', getXSnackBar: true);
      return false;
    }
  }

  // ─── Get Course Detail ───────────────────────────────
  Future<void> getCourseDetail(int id) async {
    _isLoading = true;
    update();

    Response response = await courseRepo.getCourseDetail(id);
    if (response.statusCode == 200) {
      _currentCourse = CourseDetailModel.fromJson(response.body);
    } else {
      showCustomSnackBar(response.statusText ?? 'Failed to get course details', getXSnackBar: true);
    }

    _isLoading = false;
    update();
  }

  // ─── Create Chapter ──────────────────────────────────
  Future<bool> createChapter({
    required int courseId,
    required String title,
    required int order,
  }) async {
    _isLoading = true;
    update();

    Map<String, dynamic> body = {
      'course': courseId,
      'title': title,
      'order': order,
    };

    Response response = await teacherRepo.createChapter(body);

    _isLoading = false;
    update();

    if (response.statusCode == 201 || response.statusCode == 200) {
      getCourseDetail(courseId); // refresh
      return true;
    } else {
      showCustomSnackBar(response.statusText ?? 'Failed to create chapter', getXSnackBar: true);
      return false;
    }
  }

  // ─── Create Lesson ───────────────────────────────────
  Future<bool> createLesson({
    required int chapterId,
    required String title,
    required String lessonType,
    required int order,
    String? textContent,
    String? filePath,
  }) async {
    _isLoading = true;
    update();

    Map<String, String> body = {
      'chapter': chapterId.toString(),
      'title': title,
      'lesson_type': lessonType,
      'order': order.toString(),
    };
    if (textContent != null && textContent.isNotEmpty) {
      body['text_content'] = textContent;
    }

    String fileKey = lessonType == 'video' ? 'video_file' : 'pdf_file';
    
    Response response = await teacherRepo.createLesson(body, filePath: filePath, fileKey: fileKey);

    _isLoading = false;
    update();

    if (response.statusCode == 201 || response.statusCode == 200) {
      if (_currentCourse != null) {
        getCourseDetail(_currentCourse!.id!);
      }
      return true;
    } else {
      showCustomSnackBar(response.statusText ?? 'Failed to create lesson', getXSnackBar: true);
      return false;
    }
  }

  // ─── Toggle Publish ──────────────────────────────────
  Future<bool> togglePublish(int id) async {
    _isLoading = true;
    update();

    Response response = await teacherRepo.toggleCoursePublish(id);

    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      showCustomSnackBar('Course publish status updated!', isError: false, getXSnackBar: true);
      getCourseDetail(id);
      getMyCourses();
      return true;
    } else {
      showCustomSnackBar(response.statusText ?? 'Failed to update publish status', getXSnackBar: true);
      return false;
    }
  }
}
