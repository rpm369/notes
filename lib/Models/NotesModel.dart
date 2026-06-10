class NotesModel {
  final int? id;
  final int blockId;
  final String? title;
  final String? content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? reminder;
  final DateTime? deletedAt;

  const NotesModel({
    this.id,
    required this.blockId,
    this.title,
    this.content,
    required this.createdAt,
    required this.updatedAt,
    this.reminder,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'title': this.title,
      'blockId': this.blockId,
      'content': this.content,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'reminder': this.reminder,
      'deletedAt': this.deletedAt,
    };
  }

  factory NotesModel.fromJson({required Map<String, dynamic> json}) {
    return NotesModel(
      id: json['id'],
      blockId: json['blockId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      title: json['title'],
      content: json['content'],
      reminder: json['reminder'],
      deletedAt: json['deletedAt'],
    );
  }

  NotesModel copyWith({
    int? id,
    String? title,
    int? blockId,
    String? content,
    DateTime? createdAt,
    DateTime? deletedAt,
    DateTime? updatedAt,
    DateTime? reminder,
  }) {
    return NotesModel(
      id: id ?? this.id,
      blockId: blockId ?? this.blockId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminder: reminder ?? this.reminder,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
