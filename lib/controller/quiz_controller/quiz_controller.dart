import 'package:get/get.dart';
import 'package:learning_management_system/data/model/quiz_model.dart';
import 'package:learning_management_system/data/repo/quiz_repo.dart';
import 'package:learning_management_system/views/base/custom_snackbar.dart';

class QuizController extends GetxController {
  final QuizRepo quizRepo;

  QuizController({required this.quizRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  QuizDetailModel? _currentQuiz;
  QuizDetailModel? get currentQuiz => _currentQuiz;

  List<QuizResultModel> _myResults = [];
  List<QuizResultModel> get myResults => _myResults;

  List<QuizResultModel> _teacherResults = [];
  List<QuizResultModel> get teacherResults => _teacherResults;

  // ─── Get Quiz Details (For Taking or Viewing) ────────
  Future<void> getQuizForTake(int id) async {
    _isLoading = true;
    update();

    Response response = await quizRepo.getQuizForTake(id);
    if (response.statusCode == 200) {
      _currentQuiz = QuizDetailModel.fromJson(response.body);
    } else {
      _currentQuiz = null;
      showCustomSnackBar(response.statusText ?? 'Failed to load quiz', getXSnackBar: true);
    }

    _isLoading = false;
    update();
  }

  // ─── Get Quiz by Lesson ID ───────────────────────────
  Future<int?> getQuizIdForLesson(int lessonId) async {
    Response response = await quizRepo.getQuizzes();
    if (response.statusCode == 200) {
      final dataList = response.body is List ? response.body : response.body['results'];
      if (dataList != null) {
        for (var quiz in dataList) {
          if (quiz['lesson'] == lessonId) {
            return quiz['id'];
          }
        }
      }
    }
    return null;
  }

  // ─── Submit Quiz ─────────────────────────────────────
  Future<bool> submitQuiz(int quizId, QuizSubmitModel submitData) async {
    _isLoading = true;
    update();

    Response response = await quizRepo.submitQuiz(quizId, submitData.toJson());

    _isLoading = false;
    update();

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar('Quiz submitted successfully!', isError: false, getXSnackBar: true);
      // Optional: Store the result returned in response
      return true;
    } else {
      showCustomSnackBar(response.statusText ?? 'Failed to submit quiz', getXSnackBar: true);
      return false;
    }
  }

  // ─── Get My Results (Student) ────────────────────────
  Future<void> getMyQuizResults() async {
    _isLoading = true;
    update();

    Response response = await quizRepo.getMyQuizResults();
    if (response.statusCode == 200) {
      _myResults = [];
      if (response.body != null) {
        // Assume it returns a list directly or in a results key
        final dataList = response.body is List ? response.body : response.body['results'];
        if (dataList != null) {
          dataList.forEach((data) {
            _myResults.add(QuizResultModel.fromJson(data));
          });
        }
      }
    } else {
      showCustomSnackBar(response.statusText ?? 'Failed to load quiz results', getXSnackBar: true);
    }

    _isLoading = false;
    update();
  }

  // ─── Get Quiz Results (Teacher) ──────────────────────
  Future<void> getTeacherQuizResults(int quizId) async {
    _isLoading = true;
    update();

    Response response = await quizRepo.getQuizResults(quizId);
    if (response.statusCode == 200) {
      _teacherResults = [];
      if (response.body != null) {
        final dataList = response.body is List ? response.body : response.body['results'];
        if (dataList != null) {
          dataList.forEach((data) {
            _teacherResults.add(QuizResultModel.fromJson(data));
          });
        }
      }
    } else {
      showCustomSnackBar(response.statusText ?? 'Failed to load quiz results', getXSnackBar: true);
    }

    _isLoading = false;
    update();
  }

  // ─── Create Quiz (Teacher) ───────────────────────────
  Future<int?> createQuiz({
    required int lessonId,
    required String title,
    required String description,
    required int passScorePercent,
  }) async {
    _isLoading = true;
    update();

    Map<String, dynamic> body = {
      'lesson': lessonId,
      'title': title,
      'description': description,
      'pass_score_percent': passScorePercent,
    };

    Response response = await quizRepo.createQuiz(body);

    _isLoading = false;
    update();

    if (response.statusCode == 201 || response.statusCode == 200) {
      showCustomSnackBar('Quiz created successfully!', isError: false, getXSnackBar: true);
      return response.body['id']; // Returns the new Quiz ID
    } else {
      showCustomSnackBar(response.statusText ?? 'Failed to create quiz', getXSnackBar: true);
      return null;
    }
  }

  // ─── Create Question (Teacher) ───────────────────────
  Future<bool> createQuestion({
    required int quizId,
    required String text,
    required int order,
    required List<Map<String, dynamic>> choices, // {text: str, is_correct: bool}
  }) async {
    _isLoading = true;
    update();

    Map<String, dynamic> body = {
      'quiz': quizId,
      'text': text,
      'order': order,
      'choices': choices,
    };

    Response response = await quizRepo.createQuestion(body);

    _isLoading = false;
    update();

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      showCustomSnackBar(response.statusText ?? 'Failed to create question', getXSnackBar: true);
      return false;
    }
  }
}
