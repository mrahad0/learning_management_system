import 'package:get/get.dart';
import '../api/api_client.dart';
import '../api/api_constant.dart';

class ProgressRepo {

  Future<Response> enrollInCourse(int courseId) async {
    return await ApiClient.postData(ApiConstant.enroll, {"course_id": courseId});
  }

  Future<Response> getMyProgress() async {
    return await ApiClient.getData(ApiConstant.myProgress);
  }

  Future<Response> getMyCertificates() async {
    return await ApiClient.getData(ApiConstant.certificates);
  }
}
