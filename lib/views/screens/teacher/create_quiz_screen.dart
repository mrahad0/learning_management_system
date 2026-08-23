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

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _passScoreController = TextEditingController(text: '80');

  @override
  void initState() {
    super.initState();
    lessonId = int.parse(Get.parameters['lessonId']!);
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
    int correctIndex = 0; // 0, 1, 2, 3

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Question'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: textController, decoration: const InputDecoration(labelText: 'Question Text')),
                  const SizedBox(height: 16),
                  const Text('Options (Select the correct one):'),
                  _buildOptionRow(0, opt1Controller, correctIndex, (val) => setState(() => correctIndex = val!)),
                  _buildOptionRow(1, opt2Controller, correctIndex, (val) => setState(() => correctIndex = val!)),
                  _buildOptionRow(2, opt3Controller, correctIndex, (val) => setState(() => correctIndex = val!)),
                  _buildOptionRow(3, opt4Controller, correctIndex, (val) => setState(() => correctIndex = val!)),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
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
                    order: 1, // backend can handle ordering
                    choices: choices,
                  );

                  if (success) {
                    Get.back();
                    Get.snackbar('Success', 'Question added!');
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildOptionRow(int index, TextEditingController controller, int groupValue, ValueChanged<int?> onChanged) {
    return Row(
      children: [
        Radio<int>(
          value: index,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Option ${index + 1}'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quiz'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.titleColor,
        elevation: 0,
      ),
      body: GetBuilder<QuizController>(
        builder: (controller) {
          if (createdQuizId == null) {
            return _buildCreateQuizForm(controller);
          } else {
            return _buildAddQuestionsView();
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
          Text('Quiz Title', style: AppStyles.h5()),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'e.g. Chapter 1 Quiz'),
          ),
          const SizedBox(height: 24),
          Text('Description', style: AppStyles.h5()),
          const SizedBox(height: 8),
          TextField(
            controller: _descController,
            maxLines: 3,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'What is this quiz about?'),
          ),
          const SizedBox(height: 24),
          Text('Passing Score (%)', style: AppStyles.h5()),
          const SizedBox(height: 8),
          TextField(
            controller: _passScoreController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
              onPressed: controller.isLoading ? null : _createQuiz,
              child: controller.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Create Quiz', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddQuestionsView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            Text('Quiz Created!', style: AppStyles.h2(color: AppColors.titleColor)),
            const SizedBox(height: 16),
            const Text('Now you can add questions to this quiz.', textAlign: TextAlign.center),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _showAddQuestionDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Question'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                Get.back(); // return to manage course
              },
              style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
              child: const Text('Done'),
            )
          ],
        ),
      ),
    );
  }
}
