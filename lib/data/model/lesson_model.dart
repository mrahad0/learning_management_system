class LessonModel {
  final int? id;
  final int? chapter;
  final String? title;
  final String? lessonType; // "video", "pdf", "text"
  final String? videoFile;
  final String? pdfFile;
  final String? textContent;
  final int? durationMinutes;
  final int? order;
  final String? createdAt;

  LessonModel({
    this.id,
    this.chapter,
    this.title,
    this.lessonType,
    this.videoFile,
    this.pdfFile,
    this.textContent,
    this.durationMinutes,
    this.order,
    this.createdAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
        id: json['id'],
        chapter: json['chapter'],
        title: json['title'],
        lessonType: json['lesson_type'],
        videoFile: json['video_file'],
        pdfFile: json['pdf_file'],
        textContent: json['text_content'],
        durationMinutes: json['duration_minutes'],
        order: json['order'],
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'chapter': chapter,
        'title': title,
        'lesson_type': lessonType,
        'text_content': textContent,
        'duration_minutes': durationMinutes,
        'order': order,
      };

  bool get isVideo => lessonType == 'video';
  bool get isPdf => lessonType == 'pdf';
  bool get isText => lessonType == 'text';
}
