import 'package:notes/Databases/Constants.dart';
import 'package:notes/Models/Note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDB {
  NotesDB._();

  static Database? _db;
  static List<Note>? _dbCache;

  static Future<NotesDB> getDatabase() async {
    if (_db == null) await _initialize();
    return NotesDB._();
  }

  static Future<String> _getDatabasePath() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'myDb.db');
    return databasePath;
  }

  static Future<void> _initialize() async {
    String dbPath = await _getDatabasePath();
    _db = await openDatabase(
      version: 1,
      dbPath,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE ${NotesDBConst.TABLE_NAME.value} (${NotesDBConst.ID.value} INTEGER PRIMARY KEY AUTOINCREMENT, ${NotesDBConst.TITLE.value} TEXT, ${NotesDBConst.CONTENT.value} TEXT)''',
        );
        await db.insert(NotesDBConst.TABLE_NAME.value, _produceSampleData());
      },
      onOpen: (db) async {
        _dbCache = (await db.query(
          NotesDBConst.TABLE_NAME.value,
        )).map((entry) => Note.fromJson(entry)).toList();
      },
    );
  }

  List<Note> getAllNotes() {
    return _dbCache!;
  }

  int getDbSize() {
    return _dbCache!.length;
  }

  Future<int> addNewNote(Note note) async {
    int id = await _db!.insert(NotesDBConst.TABLE_NAME.value, note.toJson());
    note.setId = id;
    _dbCache!.add(note);
    return id;
  }

  Future<void> deleteNote(Note note) async {
    await _db!.delete(
      NotesDBConst.TABLE_NAME.value,
      where: "${NotesDBConst.ID.value} = ?",
      whereArgs: [note.id],
    );
    _dbCache!.removeWhere((listNote) => listNote.id == note.id);
  }

  Future<void> updateNote(Note note) async {
    Note lsNote = _dbCache!.singleWhere((listNote) => listNote.id == note.id);
    lsNote.title = note.title;
    lsNote.content = note.content;

    await _db!.update(
      NotesDBConst.TABLE_NAME.value,
      note.toJson(),
      where: "${NotesDBConst.ID.value} = ?",
      whereArgs: [note.id],
    );
  }
}

Map<String, dynamic> _produceSampleData() {
  return {
    NotesDBConst.TITLE.value: "Sample",
    NotesDBConst.CONTENT.value:
        "This is a sample note that will let you know that you can create such more",
  };
}
