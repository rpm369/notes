import 'package:notes/Models/ToDoModel.dart';
import 'package:notes/Repos/ToDoRepository.dart';
import 'package:sqflite/sqflite.dart';

class LocalToDoRepository implements ToDoRepository {
  final Database _db;
  LocalToDoRepository({required this._db});

  @override
  Future<int> createToDo({required ToDoModel toDo}) async {
    return await _db.insert('todos', toDo.toJson());
  }

  @override
  Future<List<ToDoModel>> getAllToDosFor({required int listId}) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'todos',
      where: 'listId = ?',
      whereArgs: [listId],
    );
    return maps.map((json) => ToDoModel.fromJson(json: json)).toList();
  }

  @override
  Future<ToDoModel?> getTodo({required toDoId}) async {
    List<Map<String, dynamic>> entry = await _db.query(
      'todos',
      where: 'id = ?',
      whereArgs: [toDoId],
    );

    if (entry.isNotEmpty) return ToDoModel.fromJson(json: entry.first);
    return null;
  }

  @override
  Future<void> updateToDo({required ToDoModel toDo}) async {
    await _db.update(
      'todos',
      toDo.toJson(),
      where: 'id = ?',
      whereArgs: [toDo.id],
    );
  }
}
