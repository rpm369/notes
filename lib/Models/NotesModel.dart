class NotesModel {
  int id;
  int blockId;
  String? title;
  String? content;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? reminder;
  DateTime? deletedAt;

  NotesModel({
    required this.id,
    required this.blockId,
    this.title,
    this.content,
    required this.createdAt,
    required this.updatedAt,
    this.reminder,
    this.deletedAt,
  });
}
