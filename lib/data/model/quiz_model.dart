/// ─── Quiz (list view) ─────────────────────────────────
class QuizModel {
  final int? id;
  final int? lesson;
  final String? title;
  final String? description;
  final int? passScorePercent;
  final String? createdAt;

  QuizModel({
    this.id,
    this.lesson,
    this.title,
    this.description,
    this.passScorePercent,
    this.createdAt,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        id: json['id'],
        lesson: json['lesson'],
        title: json['title'],
        description: json['description'],
        passScorePercent: json['pass_score_percent'],
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'lesson': lesson,
        'title': title,
        'description': description,
        'pass_score_percent': passScorePercent,
      };
}

/// ─── Quiz Detail (with questions) ─────────────────────
class QuizDetailModel {
  final int? id;
  final int? lesson;
  final String? title;
  final String? description;
  final int? passScorePercent;
  final String? createdAt;
  final List<QuestionModel>? questions;

  QuizDetailModel({
    this.id,
    this.lesson,
    this.title,
    this.description,
    this.passScorePercent,
    this.createdAt,
    this.questions,
  });

  factory QuizDetailModel.fromJson(Map<String, dynamic> json) =>
      QuizDetailModel(
        id: json['id'],
        lesson: json['lesson'],
        title: json['title'],
        description: json['description'],
        passScorePercent: json['pass_score_percent'],
        createdAt: json['created_at'],
        questions: json['questions'] != null
            ? (json['questions'] as List)
                .map((q) => QuestionModel.fromJson(q))
                .toList()
            : [],
      );
}

/// ─── Question ─────────────────────────────────────────
class QuestionModel {
  final int? id;
  final int? quiz;
  final String? text;
  final int? order;
  final List<ChoiceModel>? choices;

  QuestionModel({
    this.id,
    this.quiz,
    this.text,
    this.order,
    this.choices,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        id: json['id'],
        quiz: json['quiz'],
        text: json['text'],
        order: json['order'],
        choices: json['choices'] != null
            ? (json['choices'] as List)
                .map((c) => ChoiceModel.fromJson(c))
                .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        'quiz': quiz,
        'text': text,
        'order': order,
        'choices': choices?.map((c) => c.toJson()).toList(),
      };
}

/// ─── Choice ───────────────────────────────────────────
class ChoiceModel {
  final int? id;
  final String? text;
  final bool? isCorrect;

  ChoiceModel({this.id, this.text, this.isCorrect});

  factory ChoiceModel.fromJson(Map<String, dynamic> json) => ChoiceModel(
        id: json['id'],
        text: json['text'],
        isCorrect: json['is_correct'],
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'is_correct': isCorrect,
      };
}

/// ─── Quiz Submit ──────────────────────────────────────
class QuizSubmitModel {
  final List<AnswerSubmitModel> answers;

  QuizSubmitModel({required this.answers});

  Map<String, dynamic> toJson() => {
        'answers': answers.map((a) => a.toJson()).toList(),
      };
}

class AnswerSubmitModel {
  final int questionId;
  final int choiceId;

  AnswerSubmitModel({required this.questionId, required this.choiceId});

  Map<String, dynamic> toJson() => {
        'question_id': questionId,
        'choice_id': choiceId,
      };
}

/// ─── Quiz Result ──────────────────────────────────────
class QuizResultModel {
  final int? id;
  final int? quiz;
  final int? student;
  final double? scorePercent;
  final bool? passed;
  final String? submittedAt;
  final List<AnswerResultModel>? answers;

  QuizResultModel({
    this.id,
    this.quiz,
    this.student,
    this.scorePercent,
    this.passed,
    this.submittedAt,
    this.answers,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) =>
      QuizResultModel(
        id: json['id'],
        quiz: json['quiz'],
        student: json['student'],
        scorePercent: json['score_percent']?.toDouble(),
        passed: json['passed'],
        submittedAt: json['submitted_at'],
        answers: json['answers'] != null
            ? (json['answers'] as List)
                .map((a) => AnswerResultModel.fromJson(a))
                .toList()
            : [],
      );
}

class AnswerResultModel {
  final dynamic questionId;
  final String? questionText;
  final String? selectedText;
  final bool? isCorrect;

  AnswerResultModel({
    this.questionId,
    this.questionText,
    this.selectedText,
    this.isCorrect,
  });

  factory AnswerResultModel.fromJson(Map<String, dynamic> json) =>
      AnswerResultModel(
        questionId: json['question_id'],
        questionText: json['question_text'],
        selectedText: json['selected_text'],
        isCorrect: json['is_correct'],
      );
}
