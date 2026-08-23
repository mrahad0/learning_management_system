/// ─── Enrollment ───────────────────────────────────────
class EnrollmentModel {
  final int? id;
  final int? student;
  final int? course;
  final String? courseTitle;
  final String? enrolledAt;

  EnrollmentModel({
    this.id,
    this.student,
    this.course,
    this.courseTitle,
    this.enrolledAt,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) =>
      EnrollmentModel(
        id: json['id'],
        student: json['student'],
        course: json['course'],
        courseTitle: json['course_title'],
        enrolledAt: json['enrolled_at'],
      );
}

/// ─── Completed Lesson ─────────────────────────────────
class CompletedLessonModel {
  final int? id;
  final int? student;
  final int? lesson;
  final String? lessonTitle;
  final int? courseId;
  final String? courseTitle;
  final String? completedAt;

  CompletedLessonModel({
    this.id,
    this.student,
    this.lesson,
    this.lessonTitle,
    this.courseId,
    this.courseTitle,
    this.completedAt,
  });

  factory CompletedLessonModel.fromJson(Map<String, dynamic> json) =>
      CompletedLessonModel(
        id: json['id'],
        student: json['student'],
        lesson: json['lesson'],
        lessonTitle: json['lesson_title'],
        courseId: json['course_id'],
        courseTitle: json['course_title'],
        completedAt: json['completed_at'],
      );
}

/// ─── Certificate ──────────────────────────────────────
class CertificateModel {
  final int? id;
  final String? certificateId;
  final int? student;
  final String? studentName;
  final int? course;
  final String? courseTitle;
  final double? progressPercent;
  final String? issuedAt;

  CertificateModel({
    this.id,
    this.certificateId,
    this.student,
    this.studentName,
    this.course,
    this.courseTitle,
    this.progressPercent,
    this.issuedAt,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) =>
      CertificateModel(
        id: json['id'],
        certificateId: json['certificate_id'],
        student: json['student'],
        studentName: json['student_name'],
        course: json['course'],
        courseTitle: json['course_title'],
        progressPercent: json['progress_percent']?.toDouble(),
        issuedAt: json['issued_at'],
      );
}

class ProgressModel {
  final int? courseId;
  final String? courseTitle;
  final double? progressPercent;

  ProgressModel({this.courseId, this.courseTitle, this.progressPercent});

  factory ProgressModel.fromJson(Map<String, dynamic> json) => ProgressModel(
        courseId: json['course_id'] ?? json['course'],
        courseTitle: json['course_title'],
        progressPercent: json['progress_percent']?.toDouble() ?? 0.0,
      );
}
