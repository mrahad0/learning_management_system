import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_management_system/controller/quiz_controller/quiz_controller.dart';
import 'package:learning_management_system/utils/app_colors.dart';
import 'package:learning_management_system/utils/style.dart';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  late int lessonId;
  int? createdQuizId;
  bool _checkingExisting = true;

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _passScoreController = TextEditingController(text: '80');

  @override
  void initState() {
    super.initState();
    lessonId = int.parse(Get.parameters['lessonId']!);
    _checkExistingQuiz();
  }

  Future<void> _checkExistingQuiz() async {
    final existingId = await Get.find<QuizController>().getQuizIdForLesson(lessonId);
    if (existingId != null) {
      await Get.find<QuizController>().getQuizForTake(existingId);
      setState(() {
        createdQuizId = existingId;
        _checkingExisting = false;
      });
    } else {
      setState(() {
        _checkingExisting = false;
      });
    }
  }

  void _createQuiz() async {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    final score = int.tryParse(_passScoreController.text.trim()) ?? 80;

    if (title.isEmpty || desc.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    final quizId = await Get.find<QuizController>().createQuiz(
      lessonId: lessonId,
      title: title,
      description: desc,
      passScorePercent: score,
    );

    if (quizId != null) {
      await Get.find<QuizController>().getQuizForTake(quizId);
      setState(() {
        createdQuizId = quizId;
      });
    }
  }

  void _showAddQuestionDialog() {
    final textController = TextEditingController();
    final opt1Controller = TextEditingController();
    final opt2Controller = TextEditingController();
    final opt3Controller = TextEditingController();
    final opt4Controller = TextEditingController();
    int correctIndex = 0;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Question',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1B2A3B)),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7FA),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          hintText: 'Question Text',
                          hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Options (select the correct one):', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    _buildOptionRow(0, opt1Controller, correctIndex, (val) => setState(() => correctIndex = val!)),
                    _buildOptionRow(1, opt2Controller, correctIndex, (val) => setState(() => correctIndex = val!)),
                    _buildOptionRow(2, opt3Controller, correctIndex, (val) => setState(() => correctIndex = val!)),
                    _buildOptionRow(3, opt4Controller, correctIndex, (val) => setState(() => correctIndex = val!)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: Color(0xFF4785FF), fontSize: 15, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
                            if (textController.text.trim().isEmpty || opt1Controller.text.trim().isEmpty || opt2Controller.text.trim().isEmpty) {
                              Get.snackbar('Error', 'Question and at least 2 options required');
                              return;
                            }

                            List<Map<String, dynamic>> choices = [];
                            if (opt1Controller.text.trim().isNotEmpty) choices.add({'text': opt1Controller.text.trim(), 'is_correct': correctIndex == 0});
                            if (opt2Controller.text.trim().isNotEmpty) choices.add({'text': opt2Controller.text.trim(), 'is_correct': correctIndex == 1});
                            if (opt3Controller.text.trim().isNotEmpty) choices.add({'text': opt3Controller.text.trim(), 'is_correct': correctIndex == 2});
                            if (opt4Controller.text.trim().isNotEmpty) choices.add({'text': opt4Controller.text.trim(), 'is_correct': correctIndex == 3});

                            bool success = await Get.find<QuizController>().createQuestion(
                              quizId: createdQuizId!,
                              text: textController.text.trim(),
                              order: 1,
                              choices: choices,
                            );

                            if (success) {
                              Get.back();
                              Get.snackbar('Success', 'Question added!');
                              Get.find<QuizController>().getQuizForTake(createdQuizId!);
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF4785FF), Color(0xFF2052D8)]),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(color: const Color(0xFF4785FF).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3)),
                              ],
                            ),
                            child: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildOptionRow(int index, TextEditingController controller, int groupValue, ValueChanged<int?> onChanged) {
    final isSelected = groupValue == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEEF2FF) : const Color(0xFFF4F7FA),
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: const Color(0xFF4785FF), width: 1.5) : null,
      ),
      child: Row(
        children: [
          Radio<int>(
            value: index,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: const Color(0xFF4785FF),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Option ${index + 1}',
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
          child: InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: Color(0xFF1B2A3B), size: 20),
            ),
          ),
        ),
        title: const Text(
          'Create Quiz',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFF1B2A3B)),
        ),
      ),
      body: _checkingExisting
          ? const Center(child: CircularProgressIndicator())
          : GetBuilder<QuizController>(
              builder: (controller) {
                if (createdQuizId == null) {
                  return _buildCreateQuizForm(controller);
                } else {
                  return _buildQuizManagementView(controller);
                }
              },
            ),
    );
  }

  Widget _buildCreateQuizForm(QuizController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quiz Title', style: TextStyle(color: Color(0xFF4A5568), fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'e.g. Chapter 1 Quiz',
                hintStyle: TextStyle(color: Colors.black54),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Description', style: TextStyle(color: Color(0xFF4A5568), fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'What is this quiz about?',
                hintStyle: TextStyle(color: Colors.black54),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Passing Score (%)', style: TextStyle(color: Color(0xFF4A5568), fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _passScoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF4785FF), Color(0xFF2052D8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(color: const Color(0xFF4785FF).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: controller.isLoading ? null : _createQuiz,
              child: controller.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Create Quiz', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizManagementView(QuizController controller) {
    final quiz = controller.currentQuiz;
    if (quiz == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final questions = quiz.questions ?? [];

    return Column(
      children: [
        // Quiz Header Info
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            border: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quiz.title ?? 'Untitled Quiz',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B2A3B)),
              ),
              if (quiz.description != null && quiz.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  quiz.description!,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF64748B)),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E7FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Passing Score: ${quiz.passScorePercent ?? 0}%',
                      style: const TextStyle(color: Color(0xFF4338CA), fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${questions.length} Questions',
                      style: const TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Questions List
        Expanded(
          child: questions.isEmpty
              ? _buildEmptyQuestionsView()
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: questions.length + 1, // +1 for the Add button at the bottom
                  itemBuilder: (context, index) {
                    if (index == questions.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                        child: _buildAddQuestionButton(),
                      );
                    }

                    final question = questions[index];
                    return _buildQuestionCard(question, index + 1);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(dynamic question, int number) {
    final choices = question.choices ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFF4785FF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question.text ?? 'Untitled Question',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1B2A3B)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...choices.map<Widget>((choice) {
            final isCorrect = choice.isCorrect ?? false;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isCorrect ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isCorrect ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isCorrect ? const Color(0xFF22C55E) : const Color(0xFF94A3B8),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      choice.text ?? '',
                      style: TextStyle(
                        color: isCorrect ? const Color(0xFF166534) : const Color(0xFF475569),
                        fontWeight: isCorrect ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildEmptyQuestionsView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Icon(Icons.help_outline, color: Color(0xFF94A3B8), size: 48),
            ),
            const SizedBox(height: 24),
            const Text('No Questions Yet', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1B2A3B))),
            const SizedBox(height: 12),
            const Text(
              'This quiz doesn\'t have any questions. Add your first question to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            _buildAddQuestionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddQuestionButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF4785FF), Color(0xFF2052D8)],
        ),
        boxShadow: [
          BoxShadow(color: const Color(0xFF4785FF).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _showAddQuestionDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Question', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
