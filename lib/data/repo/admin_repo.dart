import 'package:get/get.dart';
import '../api/api_client.dart';
import '../api/api_constant.dart';

class AdminRepo {
  Future<Response> getDashboardStats() async {
    return await ApiClient.getData(ApiConstant.adminDashboard);
  }

  Future<Response> getUsers() async {
    return await ApiClient.getData(ApiConstant.adminUsers);
  }

  Future<Response> getPendingTeachers() async {
    return await ApiClient.getData(ApiConstant.pendingTeachers);
  }

  Future<Response> approveTeacher(int userId) async {
    return await ApiClient.postData(ApiConstant.approveTeacher(userId), {});
  }

  Future<Response> getPendingCourses() async {
    return await ApiClient.getData(ApiConstant.pendingCourses);
  }

  Future<Response> approveCourse(int courseId) async {
    return await ApiClient.postData(ApiConstant.approveCourse(courseId), {});
  }

  Future<Response> rejectCourse(int courseId) async {
    return await ApiClient.postData(ApiConstant.rejectCourse(courseId), {});
  }
}
