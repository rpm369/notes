class NotesModel {
  int id;
  int blockId;
  String? title;
  String? content;
  DateTime creationTimeStamp;
  DateTime modificationTimeStamp;
  DateTime? reminder;
  DateTime? deletedAt;

  NotesModel({
    required this.id,
    required this.blockId,
    this.title,
    this.content,
    required this.creationTimeStamp,
    required this.modificationTimeStamp,
    this.reminder,
    this.deletedAt,
  });
}
