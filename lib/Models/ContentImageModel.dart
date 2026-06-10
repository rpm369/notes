class ContentImageModel {
  final int? id;
  final int noteId;
  final String imagePath;

  const ContentImageModel({
    this.id,
    required this.noteId,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {'id': this.id, 'noteId': this.noteId, 'imagePath': this.imagePath};
  }

  factory ContentImageModel.fromJson({required Map<String, dynamic> json}) {
    return ContentImageModel(
      id: json['id'],
      noteId: json['noteId'],
      imagePath: json['imagePath'],
    );
  }

  ContentImageModel copyWith({
    int? id,
    int? noteId,
    String? imagePath,
  }) {
    return ContentImageModel(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
