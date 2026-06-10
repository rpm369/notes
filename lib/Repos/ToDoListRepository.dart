import 'package:notes/Models/ToDoListModel.dart';

abstract class ToDoListRepository {
  Future<int> createToDoList({required ToDoListModel toDoList});
  Future<void> updateToDoList({required ToDoListModel toDoList});
  Future<void> deleteToDoList({required int listId});
  Future<List<ToDoListModel>> getAllToDoLists();
}
