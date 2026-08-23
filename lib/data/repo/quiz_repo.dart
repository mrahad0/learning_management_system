import 'dart:convert';
import 'package:get/get.dart';
import 'package:learning_management_system/data/api/api_client.dart';
import 'package:learning_management_system/data/api/api_constant.dart';

class QuizRepo {

  // Get all quizzes
  Future<Response> getQuizzes() async {
    return await ApiClient.getData(ApiConstant.quizzes);
  }

  // Get single quiz detail
  Future<Response> getQuizDetail(int id) async {
    return await ApiClient.getData(ApiConstant.quizDetail(id));
  }

  // Get quiz for taking (might be same as detail or specific endpoint)
  Future<Response> getQuizForTake(int id) async {
    return await ApiClient.getData(ApiConstant.quizTake(id));
  }

  // Submit quiz answers
  Future<Response> submitQuiz(int id, Map<String, dynamic> body) async {
    return await ApiClient.postData(
      ApiConstant.quizSubmit(id),
      jsonEncode(body),
    );
  }

  // Get my quiz results (student)
  Future<Response> getMyQuizResults() async {
    return await ApiClient.getData(ApiConstant.myQuizResults);
  }

  // Get quiz results for a specific quiz (teacher)
  Future<Response> getQuizResults(int id) async {
    return await ApiClient.getData(ApiConstant.quizResults(id));
  }

  // Create quiz (teacher)
  Future<Response> createQuiz(Map<String, dynamic> body) async {
    return await ApiClient.postData(
      ApiConstant.quizzes,
      jsonEncode(body),
    );
  }

  // Create question (teacher)
  Future<Response> createQuestion(Map<String, dynamic> body) async {
    return await ApiClient.postData(
      ApiConstant.questions,
      jsonEncode(body),
    );
  }
}
