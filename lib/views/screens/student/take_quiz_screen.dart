import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/controller/quiz_controller/quiz_controller.dart';
import 'package:learning_management_system/data/model/quiz_model.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';

class TakeQuizScreen extends StatefulWidget {
  const TakeQuizScreen({super.key});

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  late int quizId;
  bool isPreview = false;
  int _currentIndex = 0;
  
  // Maps questionId -> choiceId
  final Map<int, int> _answers = {};

  @override
  void initState() {
    super.initState();
    quizId = int.parse(Get.parameters['id']!);
    isPreview = Get.parameters['preview'] == 'true';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<QuizController>().getQuizForTake(quizId);
    });
  }

  void _nextQuestion(int totalQuestions) {
    if (_currentIndex < totalQuestions - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _prevQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _submitQuiz(QuizDetailModel quiz) async {
    // Check if all answered
    if (_answers.length < (quiz.questions?.length ?? 0)) {
      Get.snackbar('Warning', 'Please answer all questions before submitting.');
      return;
    }

    final submitData = QuizSubmitModel(
      answers: _answers.entries
          .map((e) => AnswerSubmitModel(questionId: e.key, choiceId: e.value))
          .toList(),
    );

    final success = await Get.find<QuizController>().submitQuiz(quizId, submitData);
    if (success) {
      // Show success and go back
      Get.defaultDialog(
        title: 'Quiz Submitted!',
        middleText: 'Your answers have been recorded.',
        textConfirm: 'OK',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back(); // close dialog
          Get.back(); // go back from quiz
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
      builder: (controller) {
        final quiz = controller.currentQuiz;

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Text(quiz?.title ?? 'Quiz', style: AppStyles.h3(color: AppColors.titleColor)),
            backgroundColor: Colors.white,
            foregroundColor: AppColors.titleColor,
            elevation: 1,
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : quiz == null
                  ? const Center(child: Text('Failed to load quiz'))
                  : _buildQuizContent(quiz),
        );
      },
    );
  }

  Widget _buildQuizContent(QuizDetailModel quiz) {
    final questions = quiz.questions ?? [];
    if (questions.isEmpty) {
      return const Center(child: Text('No questions available in this quiz.'));
    }

    final currentQuestion = questions[_currentIndex];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Indicator
          Row(
            children: [
              Text('Question ${_currentIndex + 1} of ${questions.length}', style: AppStyles.h4(color: Colors.grey[600])),
              const SizedBox(width: 16),
              Expanded(
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / questions.length,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Question Text
          Text(
            currentQuestion.text ?? 'Untitled Question',
            style: AppStyles.h2(color: AppColors.titleColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),

          // Choices
          Expanded(
            child: ListView.builder(
              itemCount: currentQuestion.choices?.length ?? 0,
              itemBuilder: (context, index) {
                final choice = currentQuestion.choices![index];
                final isSelected = _answers[currentQuestion.id!] == choice.id;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _answers[currentQuestion.id!] = choice.id!;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.white,
                      border: Border.all(
                        color: isSelected ? AppColors.primaryColor : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: isSelected ? AppColors.primaryColor : Colors.grey[400],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            choice.text ?? '',
                            style: AppStyles.h4(color: AppColors.titleColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentIndex > 0)
                OutlinedButton(
                  onPressed: _prevQuestion,
                  child: const Text('Previous'),
                )
              else
                const SizedBox.shrink(),

              if (_currentIndex < questions.length - 1)
                ElevatedButton(
                  onPressed: () => _nextQuestion(questions.length),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                  child: const Text('Next', style: TextStyle(color: Colors.white)),
                )
              else if (isPreview)
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Close Preview', style: TextStyle(color: Colors.white)),
                )
              else
                ElevatedButton(
                  onPressed: () => _submitQuiz(quiz),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Submit Quiz', style: TextStyle(color: Colors.white)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
