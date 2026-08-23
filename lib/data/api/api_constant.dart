class ApiConstant {
  static const String baseUrl = 'http://144.79.133.208:8000/api/';

  // ─── Auth ────────────────────────────────────────────
  static const String login = "auth/login/";
  static const String register = "auth/register/";
  static const String me = "auth/me/";
  static const String refreshToken = "auth/refresh/";

  // ─── Courses ─────────────────────────────────────────
  static const String courses = "courses/courses/";
  static const String approvedCourses = "courses/courses/approved/";
  static const String myCourses = "courses/courses/my-courses/";
  static String courseDetail(int id) => "courses/courses/$id/";
  static String courseUpdate(int id) => "courses/courses/$id/";
  static String courseDelete(int id) => "courses/courses/$id/";
  static String togglePublish(int id) => "courses/courses/$id/toggle-publish/";

  // ─── Chapters ────────────────────────────────────────
  static const String chapters = "courses/chapters/";
  static String chapterDetail(int id) => "courses/chapters/$id/";
  static String chapterUpdate(int id) => "courses/chapters/$id/";
  static String chapterDelete(int id) => "courses/chapters/$id/";

  // ─── Lessons ─────────────────────────────────────────
  static const String lessons = "courses/lessons/";
  static String lessonDetail(int id) => "courses/lessons/$id/";
  static String lessonUpdate(int id) => "courses/lessons/$id/";
  static String lessonDelete(int id) => "courses/lessons/$id/";

  // ─── Quizzes ─────────────────────────────────────────
  static const String quizzes = "quizzes/quizzes/";
  static String quizDetail(int id) => "quizzes/quizzes/$id/";
  static String quizTake(int id) => "quizzes/quizzes/$id/take/";
  static String quizSubmit(int id) => "quizzes/quizzes/$id/submit/";
  static String quizResults(int id) => "quizzes/quizzes/$id/results/";
  static const String myQuizResults = "quizzes/quizzes/my-results/";

  // ─── Questions ───────────────────────────────────────
  static const String questions = "quizzes/questions/";
  static String questionDetail(int id) => "quizzes/questions/$id/";

  // ─── Progress ────────────────────────────────────────
  static const String enroll = "progress/enroll/";
  static const String enrollments = "progress/enrollments/";
  static const String completeLesson = "progress/complete/";
  static const String completedLessons = "progress/completed/";
  static String courseProgress(int id) => "progress/course/$id/";
  static const String myProgress = "progress/my-progress/";
  static String generateCertificate(int id) => "progress/certificate/$id/";
  static const String certificates = "progress/certificates/";
  static String teacherCourseStudents(int courseId) =>
      "progress/teacher/course/$courseId/students/";

  // ─── Admin Panel ─────────────────────────────────────
  static const String adminDashboard = "admin-panel/dashboard/";
  static const String adminUsers = "admin-panel/users/";
  static String adminUserDetail(int id) => "admin-panel/users/$id/";
  static const String pendingTeachers = "admin-panel/teachers/pending/";
  static String approveTeacher(int userId) =>
      "admin-panel/teachers/$userId/approve/";
  static const String pendingCourses = "admin-panel/courses/pending/";
  static String approveCourse(int courseId) =>
      "admin-panel/courses/$courseId/approve/";
  static String rejectCourse(int courseId) =>
      "admin-panel/courses/$courseId/reject/";
  static const String topCourses = "admin-panel/top-courses/";

  // ─── Utilities ───────────────────────────────────────
  static String resolveMediaUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final host = baseUrl.replaceAll('/api/', '');
    if (path.startsWith('/')) return '$host$path';
    return '$host/$path';
  }
}