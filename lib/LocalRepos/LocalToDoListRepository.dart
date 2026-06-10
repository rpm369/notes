import 'package:notes/Models/ToDoListModel.dart';
import 'package:notes/Repos/ToDoListRepository.dart';
import 'package:sqflite/sqflite.dart';

class LocalToDoListRepository implements ToDoListRepository {
  final Database _db;
  LocalToDoListRepository({required this._db});

  @override
  Future<int> createToDoList({required ToDoListModel toDoList}) async {
    return await _db.insert('todo_lists', toDoList.toJson());
  }

  @override
  Future<void> deleteToDoList({required int listId}) async {
    await _db.delete('todo_lists', where: 'id = ?', whereArgs: [listId]);
  }

  @override
  Future<List<ToDoListModel>> getAllToDoLists() async {
    final List<Map<String, dynamic>> maps = await _db.query('todo_lists');
    return maps.map((json) => ToDoListModel.fromJson(json: json)).toList();
  }

  @override
  Future<void> updateToDoList({required ToDoListModel toDoList}) async {
    await _db.update(
      'todo_lists',
      toDoList.toJson(),
      where: 'id = ?',
      whereArgs: [toDoList.id],
    );
  }
}
