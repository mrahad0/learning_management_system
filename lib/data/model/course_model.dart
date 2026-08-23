import 'lesson_model.dart';

import '../api/api_constant.dart';

/// ─── Course (list view) ───────────────────────────────
class CourseModel {
  final int? id;
  final String? title;
  final String? description;
  final int? teacher;
  final String? teacherName;
  final String? thumbnail;
  final String? status; // "pending", "approved", "rejected"
  final bool? isPublished;
  final int? chaptersCount;
  final dynamic lessonsCount; // API returns string
  final String? createdAt;
  final String? updatedAt;

  CourseModel({
    this.id,
    this.title,
    this.description,
    this.teacher,
    this.teacherName,
    this.thumbnail,
    this.status,
    this.isPublished,
    this.chaptersCount,
    this.lessonsCount,
    this.createdAt,
    this.updatedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        teacher: json['teacher'],
        teacherName: json['teacher_name'],
        thumbnail: ApiConstant.resolveMediaUrl(json['thumbnail']),
        status: json['status'],
        isPublished: json['is_published'],
        chaptersCount: json['chapters_count'],
        lessonsCount: json['lessons_count'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };

  int get totalLessons => int.tryParse(lessonsCount?.toString() ?? '0') ?? 0;

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
}

/// ─── Course Detail (with chapters & lessons) ──────────
class CourseDetailModel {
  final int? id;
  final String? title;
  final String? description;
  final int? teacher;
  final String? teacherName;
  final String? thumbnail;
  final String? status;
  final bool? isPublished;
  final int? chaptersCount;
  final dynamic lessonsCount;
  final String? createdAt;
  final String? updatedAt;
  final List<ChapterModel>? chapters;

  CourseDetailModel({
    this.id,
    this.title,
    this.description,
    this.teacher,
    this.teacherName,
    this.thumbnail,
    this.status,
    this.isPublished,
    this.chaptersCount,
    this.lessonsCount,
    this.createdAt,
    this.updatedAt,
    this.chapters,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) =>
      CourseDetailModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        teacher: json['teacher'],
        teacherName: json['teacher_name'],
        thumbnail: ApiConstant.resolveMediaUrl(json['thumbnail']),
        status: json['status'],
        isPublished: json['is_published'],
        chaptersCount: json['chapters_count'],
        lessonsCount: json['lessons_count'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        chapters: json['chapters'] != null
            ? (json['chapters'] as List)
                .map((c) => ChapterModel.fromJson(c))
                .toList()
            : [],
      );

  int get totalLessons => int.tryParse(lessonsCount?.toString() ?? '0') ?? 0;
}

/// ─── Chapter ──────────────────────────────────────────
class ChapterModel {
  final int? id;
  final int? course;
  final String? title;
  final int? order;
  final String? createdAt;
  final List<LessonModel>? lessons;

  ChapterModel({
    this.id,
    this.course,
    this.title,
    this.order,
    this.createdAt,
    this.lessons,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) => ChapterModel(
        id: json['id'],
        course: json['course'],
        title: json['title'],
        order: json['order'],
        createdAt: json['created_at'],
        lessons: json['lessons'] != null
            ? (json['lessons'] as List)
                .map((l) => LessonModel.fromJson(l))
                .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        'course': course,
        'title': title,
        'order': order,
      };
}
