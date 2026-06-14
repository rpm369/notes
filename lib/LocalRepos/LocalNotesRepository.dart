import 'package:notes/Models/NotesModel.dart';
import 'package:notes/Repos/NoteRepository.dart';
import 'package:sqflite/sqflite.dart';

class LocalNotesRepository implements NoteRepository {
  final Database _db;
  LocalNotesRepository({required this._db});

  @override
  Future<int> createNote({required NotesModel note}) async {
    return await _db.insert('notes', note.toJson());
  }

  @override
  Future<void> deletePermanently({required int noteId}) async {
    await _db.delete('notes', where: 'id = ?', whereArgs: [noteId]);
  }

  @override
  Future<NotesModel?> getNote({required int noteId}) async {
    List<Map<String, dynamic>> notesMap = await _db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [noteId],
    );

    if (notesMap.isNotEmpty) return NotesModel.fromJson(json: notesMap.first);
    return null;
  }

  @override
  Future<List<NotesModel>> getNotesForBlock({required int blockId}) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'notes',
      where: 'blockId = ? AND deletedAt IS NULL',
      whereArgs: [blockId],
    );
    // return List.generate(maps.length, (i) => NotesModel.fromJson(json: maps[i]));
    return maps.map((json) => NotesModel.fromJson(json: json)).toList();
  }

  @override
  Future<List<NotesModel>> getReminderNotes() async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'notes',
      where: 'reminder IS NOT NULL AND deletedAt IS NULL',
    );
    return List.generate(
      maps.length,
      (i) => NotesModel.fromJson(json: maps[i]),
    );
  }

  @override
  Future<List<NotesModel>> getTrashNotes() async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'notes',
      where: 'deletedAt IS NOT NULL',
    );
    return List.generate(
      maps.length,
      (i) => NotesModel.fromJson(json: maps[i]),
    );
  }

  @override
  Future<void> removeBlockAssociation({required int blockId}) async {
    await _db.update(
      'notes',
      {'blockId': null},
      where: 'blockId = ?',
      whereArgs: [blockId],
    );
  }

  @override
  Future<void> updateNote({required NotesModel note}) async {
    await _db.update(
      'notes',
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  @override
  Future<void> changeBlockFor({
    required int noteId,
    required int newBlockId,
  }) async {
    await _db.update(
      'notes',
      {'blockId': newBlockId},
      where: "id = ?",
      whereArgs: [noteId],
    );
  }
}
