import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes/Databases/Constants.dart';
import 'package:notes/Databases/SystemDB.dart';
import 'package:notes/Models/Note.dart';

class NotesDB extends ChangeNotifier {
  NotesDB._();

  static Box<Note>? _db;

  static Future<NotesDB> initialize() async {
    if (_db != null) return NotesDB._();
    _db = await Hive.openBox<Note>(Constants.NOTES_BOX.value);

    if (await SystemDB.isFirstExecution()) {
      Note sampleData = _produceSampleData();
      _dbCache = [];

      _dbCache!.add(sampleData);
      await _db!.add(sampleData);
      return NotesDB._();
    }

    _dbCache = _db!.values.toList();

    return NotesDB._();
  }

  static List<Note>? _dbCache;

  List<Note> getAllNotes() {
    return _dbCache!;
  }

  int getDbSize() {
    return _db!.length;
  }

  Future<int> addNewNote(Note note) async {
    int key = await _db!.add(note);
    _dbCache!.add(note);
    return key;
  }

  Future<void> deleteNote(Note note) async {
    _dbCache!.removeWhere((listNote) => listNote.key == note.key);
    await note.delete();
  }

  Future<void> updateNote(Note note) async {
    Note lsNote = _dbCache!.singleWhere((listNote) => listNote.key == note.key);
    lsNote.title = note.title;
    lsNote.content = note.content;

    await note.save();
  }
}

Note _produceSampleData() {
  return Note(
    "Sample",
    "This is a sample note that will let you know that you can create such more",
  );
}
