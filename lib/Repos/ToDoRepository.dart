import 'package:notes/Models/ToDoModel.dart';

abstract class ToDoRepository {
  Future<int> createToDo({required ToDoModel toDo});
  Future<void> updateToDo({required ToDoModel toDo});
  Future<List<ToDoModel>> getAllToDosFor({required int listId});
  Future<ToDoModel?> getTodo({required int toDoId});
}
