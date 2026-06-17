import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class SqlDatabaseProvider {
  static Database? _db;

  static Future<Database> getDatabase() async {
    _db ??= await _initialize();
    return _db!;
  }

  static Future<Database> _initialize() async {
    String dbFilePath = await _getDbFilePath();
    return await openDatabase(
      dbFilePath,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE blocks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            blockId INTEGER,
            title TEXT,
            content TEXT,
            createdAt INTEGER NOT NULL,
            updatedAt INTEGER NOT NULL,
            reminder INTEGER,
            deletedAt INTEGER,
            FOREIGN KEY (blockId) REFERENCES blocks (id)
          )
        ''');

        await db.execute('''
          CREATE TABLE content_images (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            noteId INTEGER NOT NULL,
            imagePath TEXT NOT NULL,
            FOREIGN KEY (noteId) REFERENCES notes (id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE todo_lists (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            listId INTEGER NOT NULL,
            name TEXT NOT NULL,
            completionStatus INTEGER NOT NULL,
            FOREIGN KEY (listId) REFERENCES todo_lists (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  static Future<String> _getDbFilePath() async {
    String docPath = (await getApplicationDocumentsDirectory()).path;
    String dbFilePath = path.join(docPath, DbConsts.DB_NAME.id);
    return dbFilePath;
  }
}

enum DbConsts {
  DB_NAME("notesDb.db");

  final String id;
  const DbConsts(this.id);
}
