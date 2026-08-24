import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
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
  
  Timer? _timer;
  int _secondsRemaining = 60; // Count down from 1 min
  
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
    
    // Start dynamic timer (Count down)
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _timer?.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _nextQuestion(int totalQuestions) {
    if (_currentIndex < totalQuestions - 1) {
      setState(() {
        _currentIndex++;
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
      // Show custom success dialog
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 60), // Space for floating trophy
                padding: const EdgeInsets.fromLTRB(24, 70, 24, 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Quiz Submitted!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E3A8A), // Deep blue
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your answers have been recorded.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A), // Deep blue button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                        elevation: 8,
                        shadowColor: const Color(0xFF1E3A8A).withOpacity(0.5),
                      ),
                      onPressed: () {
                        Get.back(); // close dialog
                        Get.back(); // go back from quiz
                      },
                      child: const Text('OK', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              // Floating Trophy Emoji (since asset images aren't present)
              Positioned(
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFBBF24).withOpacity(0.4), // Golden glow
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Text('🏆', style: TextStyle(fontSize: 60)),
                ),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  Widget _buildTopHeader(String title) {
    // Splits title if possible, else just use the string.
    // e.g. "Quiz 1: Setup" -> bold "Setup"
    String prefix = 'Quiz: ';
    String boldPart = title;
    
    if (title.contains(':')) {
      final parts = title.split(':');
      prefix = '${parts[0]}: ';
      boldPart = parts.sublist(1).join(':').trim();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F9), // Light blue-grey background
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Color(0xFF1B2A3B), size: 20),
            ),
          ),
          
          // Title
          Expanded(
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: prefix,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF1B2A3B),
                  ),
                  children: [
                    TextSpan(
                      text: boldPart,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          
          // Placeholder for symmetry
          const SizedBox(width: 45),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(QuizDetailModel quiz, int totalQuestions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Progress Bar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Question ${_currentIndex + 1} of $totalQuestions (Django)',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1B2A3B)),
                  ),
                  const SizedBox(height: 8),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double progress = (_currentIndex + 1) / totalQuestions;
                      return Stack(
                        alignment: Alignment.centerLeft,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: progress,
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6), // Blue
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Positioned(
                            left: (constraints.maxWidth * progress) - 12, // Center the thumb
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '${_currentIndex + 1}',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                ],
              ),
            ),
          ),

          // Timer
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Row(
                children: [
                  Icon(Icons.timer_outlined, size: 14, color: Colors.black87),
                  SizedBox(width: 4),
                  Text('Timer:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              Text(_formatTime(_secondsRemaining), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B2A3B))),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
      builder: (controller) {
        final quiz = controller.currentQuiz;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC), // Very light soft blue/grey background
          body: SafeArea(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : quiz == null
                    ? const Center(child: Text('Failed to load quiz'))
                    : _buildQuizContent(quiz),
          ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopHeader(quiz.title ?? 'Quiz'),
        _buildMetadataRow(quiz, questions.length),
        
        const SizedBox(height: 24),
        
        // Question Text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            currentQuestion.text ?? 'Untitled Question',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B2A3B),
            ),
          ),
        ),
        
        const SizedBox(height: 24),

        // Choices
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFEEF2FF) : Colors.white, // Light blue or white
                    border: Border.all(
                      color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent, // Blue or none
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (!isSelected)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8),
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          choice.text ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1B2A3B),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Bottom Action Area
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Tap to select your answer',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              
              GestureDetector(
                onTap: () {
                  if (_currentIndex < questions.length - 1) {
                    _nextQuestion(questions.length);
                  } else if (isPreview) {
                    Get.back();
                  } else {
                    _submitQuiz(quiz);
                  }
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF60A5FA), Color(0xFF2563EB)], // Light to deep blue
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      (_currentIndex < questions.length - 1) ? 'Next' : (isPreview ? 'Close' : 'Submit'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
