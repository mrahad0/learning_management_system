import 'package:get/get.dart';
import '../api/api_client.dart';
import '../api/api_constant.dart';

class CourseRepo {

  Future<Response> getApprovedCourses({int page = 1}) async {
    return await ApiClient.getData('${ApiConstant.approvedCourses}?page=$page');
  }

  Future<Response> getCourseDetail(int id) async {
    return await ApiClient.getData(ApiConstant.courseDetail(id));
  }

  Future<Response> getMyCourses({int page = 1}) async {
    return await ApiClient.getData('${ApiConstant.myCourses}?page=$page');
  }
}
