import 'package:notes/Databases/Constants.dart';

class Note {
  int? id;

  String? title;

  late String content;

  Note({this.id, required this.title, required this.content});

  set setId(int i) => this.id = i;

  Map<String, Object?> toJson() {
    return {
      NotesDBConst.TITLE.value: this.title,
      NotesDBConst.CONTENT.value: this.content,
    };
  }

  static Note fromJson(Map<String, Object?> map) {
    return Note(
      id: map[NotesDBConst.ID.value] as int,
      title: map[NotesDBConst.TITLE.value] as String,
      content: map[NotesDBConst.CONTENT.value] as String,
    );
  }
}
