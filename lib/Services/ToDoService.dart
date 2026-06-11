import 'package:notes/Models/ToDoModel.dart';
import 'package:notes/Repos/ToDoRepository.dart';

class ToDoService {
  final ToDoRepository toDoRepo;
  ToDoService({required this.toDoRepo});

  Future<List<ToDoModel>> getToDosForList({required int listId}) async {
    return await toDoRepo.getAllToDosFor(listId: listId);
  }

  Future<void> createToDo({required ToDoModel todo}) async {
    await toDoRepo.createToDo(toDo: todo);
  }

  Future<void> toggleCompletion({required int toDoId}) async {
    ToDoModel todo = (await toDoRepo.getTodo(toDoId: toDoId))!;
    todo = todo.copyWith(completionStatus: !todo.completionStatus);
    await toDoRepo.updateToDo(toDo: todo);
  }
}
