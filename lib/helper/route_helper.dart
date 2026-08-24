
import 'package:get/get.dart';
import 'package:learning_management_system/views/screens/auth/login_screen.dart';
import 'package:learning_management_system/views/screens/auth/register_screen.dart';
import 'package:learning_management_system/views/screens/auth/splash_screen.dart';

import 'package:learning_management_system/views/screens/student/student_dashboard_screen.dart';
import 'package:learning_management_system/views/screens/teacher/teacher_dashboard_screen.dart';
import 'package:learning_management_system/views/screens/admin/admin_dashboard_screen.dart';
import 'package:learning_management_system/views/screens/student/course_detail_screen.dart';
import 'package:learning_management_system/views/screens/student/lesson_viewer_screen.dart';
import 'package:learning_management_system/views/screens/student/pdf_viewer_screen.dart';

import 'package:learning_management_system/views/screens/teacher/create_course_screen.dart';
import 'package:learning_management_system/views/screens/teacher/manage_course_screen.dart';
import 'package:learning_management_system/views/screens/teacher/create_quiz_screen.dart';
import 'package:learning_management_system/views/screens/student/take_quiz_screen.dart';
import 'package:learning_management_system/views/screens/student/certificate_screen.dart';
import 'package:learning_management_system/views/screens/student/my_certificates_screen.dart';
import 'package:learning_management_system/views/screens/admin/admin_dashboard_screen.dart';

class AppRoutes {
  static const String splashScreen = "/splash";
  static const String login = "/login";
  static const String register = "/register";
  static const String studentDashboard = "/student-home";
  static const String teacherDashboard = "/teacher-home";
  static const String adminDashboard = "/admin-home";
  static const String courseDetail = "/student-home/course/:id";
  static const String lessonViewer = "/student-home/lesson/:id";
  
  // Phase 3 Routes
  static const String createCourse = "/teacher-home/create-course";
  static const String manageCourse = "/teacher-home/manage-course/:id";
  static const String createQuiz = "/teacher-home/create-quiz/:lessonId";
  static const String takeQuiz = "/student-home/take-quiz/:id";
  static const String certificate = "/student-home/certificate/:id";
  static const String myCertificates = '/my-certificates';
  static const String pdfViewer = '/pdf-viewer';

  static List<GetPage> page = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => const RegisterScreen()),
    GetPage(name: studentDashboard, page: () => const StudentDashboardScreen()),
    GetPage(name: teacherDashboard, page: () => const TeacherDashboardScreen()),
    GetPage(name: adminDashboard, page: () => const AdminDashboardScreen()),
    GetPage(name: courseDetail, page: () => const CourseDetailScreen()),
    GetPage(name: lessonViewer, page: () => const LessonViewerScreen()),
    
    // Phase 3 Pages
    GetPage(name: createCourse, page: () => const CreateCourseScreen()),
    GetPage(name: manageCourse, page: () => const ManageCourseScreen()),
    GetPage(name: createQuiz, page: () => const CreateQuizScreen()),
    GetPage(name: takeQuiz, page: () => const TakeQuizScreen()),
    GetPage(name: certificate, page: () => const CertificateScreen()),
    GetPage(name: myCertificates, page: () => const MyCertificatesScreen()),
    GetPage(name: pdfViewer, page: () => const PdfViewerScreen()),
  ];
}