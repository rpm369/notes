import 'package:notes/Models/ToDoModel.dart';
import 'package:notes/Repos/ToDoRepository.dart';

class ToDoService {
  final ToDoRepository toDoRepo;
  ToDoService({required this.toDoRepo});

  Future<List<ToDoModel>> getToDosForList({required int listId}) async {}
  Future<void> createToDo({required ToDoModel todo}) async {}
  Future<void> toggleCompletion({required int toDoId}) async {}
}
