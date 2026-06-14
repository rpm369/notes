import 'package:notes/Models/ToDoListModel.dart';
import 'package:notes/Models/ToDoModel.dart';
import 'package:notes/Repos/ToDoListRepository.dart';
import 'package:notes/Services/ToDoService.dart';

class ToDoListService {
  final ToDoListRepository listRepo;
  final ToDoService toDoService;
  ToDoListService({required this.listRepo, required this.toDoService});

  Future<void> createList({
    required ToDoListModel list,
    required List<ToDoModel> toDos,
  }) async {
    int id = await listRepo.createToDoList(toDoList: list);

    toDos = toDos.map((toDo) => toDo.copyWith(listId: id)).toList();
    await toDoService.createToDo(toDos: toDos);
  }

  Future<void> deleteList({required int listId}) async {
    await listRepo.deleteToDoList(listId: listId);
  }

  Future<List<ToDoListModel>> getAllLists() async {
    return await listRepo.getAllToDoLists();
  }

  Future<void> renameList({required ToDoListModel list}) async {
    await listRepo.updateToDoList(toDoList: list);
  }
}
