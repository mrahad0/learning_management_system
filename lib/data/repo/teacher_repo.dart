import 'dart:io';
import 'package:get/get.dart';
import 'package:learning_management_system/data/api/api_client.dart';
import 'package:learning_management_system/data/api/api_constant.dart';

class TeacherRepo {

  Future<Response> createCourse(Map<String, String> body, {String? imagePath}) async {
    return await ApiClient.postMultipartData(
      ApiConstant.courses,
      body,
      multipartBody: imagePath != null ? [MultipartBody('thumbnail', File(imagePath))] : [],
    );
  }

  Future<Response> updateCourse(int id, Map<String, String> body, {String? imagePath}) async {
    return await ApiClient.postMultipartData(
      ApiConstant.courseUpdate(id),
      body,
      multipartBody: imagePath != null ? [MultipartBody('thumbnail', File(imagePath))] : [],
    );
  }

  Future<Response> createChapter(Map<String, dynamic> body) async {
    return await ApiClient.postData(ApiConstant.chapters, body);
  }

  Future<Response> createLesson(Map<String, String> body, {String? filePath, String fileKey = 'video_file'}) async {
    return await ApiClient.postMultipartData(
      ApiConstant.lessons,
      body,
      multipartBody: filePath != null ? [MultipartBody(fileKey, File(filePath))] : [],
    );
  }

  Future<Response> toggleCoursePublish(int id) async {
    return await ApiClient.postData(ApiConstant.togglePublish(id), {});
  }
}
