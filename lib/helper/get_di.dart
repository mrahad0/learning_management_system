import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/api/api_client.dart';
import 'package:learning_management_system/data/repo/auth_repo.dart';
import 'package:learning_management_system/controller/auth_controller/auth_controller.dart';
import 'package:learning_management_system/data/repo/course_repo.dart';
import 'package:learning_management_system/data/repo/progress_repo.dart';
import 'package:learning_management_system/controller/student_controller/student_controller.dart';
import 'package:learning_management_system/controller/teacher_controller/teacher_controller.dart';
import 'package:learning_management_system/controller/quiz_controller/quiz_controller.dart';
import 'package:learning_management_system/data/repo/teacher_repo.dart';
import 'package:learning_management_system/data/repo/quiz_repo.dart';
import 'package:learning_management_system/data/repo/admin_repo.dart';
import 'package:learning_management_system/controller/admin_controller/admin_controller.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put(sharedPreferences, permanent: true);
  Get.put(ApiClient(), permanent: true);

  // Auth
  Get.put(AuthRepo(), permanent: true);
  Get.put(AuthController(authRepo: Get.find()), permanent: true);

  // Student Portal
  Get.put(CourseRepo(), permanent: true);
  Get.put(ProgressRepo(), permanent: true);
  Get.put(TeacherRepo(), permanent: true);
  Get.put(QuizRepo(), permanent: true);
  Get.put(AdminRepo(), permanent: true);
  Get.put(TeacherController(teacherRepo: Get.find(), courseRepo: Get.find()), permanent: true);
  Get.put(QuizController(quizRepo: Get.find()), permanent: true);
  Get.put(AdminController(adminRepo: Get.find()), permanent: true);
  Get.put(StudentController(courseRepo: Get.find(), progressRepo: Get.find()), permanent: true);
}