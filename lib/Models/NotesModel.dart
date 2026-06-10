class NotesModel {
  final int? id;
  final int? blockId;
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
      'createdAt': this.createdAt.millisecondsSinceEpoch,
      'updatedAt': this.updatedAt.millisecondsSinceEpoch,
      'reminder': this.reminder?.millisecondsSinceEpoch,
      'deletedAt': this.deletedAt?.millisecondsSinceEpoch,
    };
  }

  factory NotesModel.fromJson({required Map<String, dynamic> json}) {
    return NotesModel(
      id: json['id'],
      blockId: json['blockId'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      title: json['title'],
      content: json['content'],
      reminder: (json['reminder'] != null)
          ? DateTime.fromMillisecondsSinceEpoch(json['reminder'])
          : null,
      deletedAt: (json['deletedAt'] != null)
          ? DateTime.fromMillisecondsSinceEpoch(json['deletedAt'])
          : null,
    );
  }

  NotesModel copyWith({
    int? id,
    String? title,
    required int? blockId,
    String? content,
    DateTime? createdAt,
    required DateTime? deletedAt,
    DateTime? updatedAt,
    required DateTime? reminder,
  }) {
    return NotesModel(
      id: id ?? this.id,
      blockId: blockId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminder: reminder,
      deletedAt: deletedAt,
    );
  }
}
