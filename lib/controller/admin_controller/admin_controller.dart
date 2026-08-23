import 'package:get/get.dart';
import '../../data/model/user_model.dart';
import '../../data/model/course_model.dart';
import '../../data/repo/admin_repo.dart';
import '../../views/base/custom_snackbar.dart';

class AdminController extends GetxController implements GetxService {
  final AdminRepo adminRepo;

  AdminController({required this.adminRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _dashboardStats;
  Map<String, dynamic>? get dashboardStats => _dashboardStats;

  List<UserModel>? _pendingTeachers;
  List<UserModel>? get pendingTeachers => _pendingTeachers;

  List<CourseModel>? _pendingCourses;
  List<CourseModel>? get pendingCourses => _pendingCourses;

  List<UserModel>? _allUsers;
  List<UserModel>? get allUsers => _allUsers;

  Future<void> getDashboardStats() async {
    _isLoading = true;
    update();

    Response response = await adminRepo.getDashboardStats();
    if (response.statusCode == 200 && response.body != null) {
      _dashboardStats = response.body;
    }

    _isLoading = false;
    update();
  }

  Future<void> getPendingApprovals() async {
    _isLoading = true;
    update();

    // Fetch Teachers
    Response teacherRes = await adminRepo.getPendingTeachers();
    if (teacherRes.statusCode == 200 && teacherRes.body != null) {
      _pendingTeachers = [];
      final dataList = teacherRes.body is List ? teacherRes.body : teacherRes.body['results'];
      if (dataList != null) {
        dataList.forEach((t) => _pendingTeachers!.add(UserModel.fromJson(t)));
      }
    }

    // Fetch Courses
    Response courseRes = await adminRepo.getPendingCourses();
    if (courseRes.statusCode == 200 && courseRes.body != null) {
      _pendingCourses = [];
      final dataList = courseRes.body is List ? courseRes.body : courseRes.body['results'];
      if (dataList != null) {
        dataList.forEach((c) => _pendingCourses!.add(CourseModel.fromJson(c)));
      }
    }

    _isLoading = false;
    update();
  }

  Future<void> approveTeacher(int userId) async {
    Response response = await adminRepo.approveTeacher(userId);
    if (response.statusCode == 200) {
      showCustomSnackBar('Teacher approved successfully!', isError: false);
      getPendingApprovals();
      getDashboardStats();
    } else {
      showCustomSnackBar('Failed to approve teacher.', isError: true);
    }
  }

  Future<void> approveCourse(int courseId) async {
    Response response = await adminRepo.approveCourse(courseId);
    if (response.statusCode == 200) {
      showCustomSnackBar('Course approved successfully!', isError: false);
      getPendingApprovals();
      getDashboardStats();
    } else {
      showCustomSnackBar('Failed to approve course.', isError: true);
    }
  }

  Future<void> rejectCourse(int courseId) async {
    Response response = await adminRepo.rejectCourse(courseId);
    if (response.statusCode == 200) {
      showCustomSnackBar('Course rejected.', isError: false);
      getPendingApprovals();
      getDashboardStats();
    } else {
      showCustomSnackBar('Failed to reject course.', isError: true);
    }
  }

  Future<void> getAllUsers() async {
    _isLoading = true;
    update();

    Response response = await adminRepo.getUsers();
    if (response.statusCode == 200 && response.body != null) {
      _allUsers = [];
      final dataList = response.body is List ? response.body : response.body['results'];
      if (dataList != null) {
        dataList.forEach((u) => _allUsers!.add(UserModel.fromJson(u)));
      }
    }

    _isLoading = false;
    update();
  }
}
