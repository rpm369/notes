import 'package:notes/Models/ToDoListModel.dart';
import 'package:notes/Repos/ToDoListRepository.dart';

class ToDoListService {
  final ToDoListRepository listRepo;
  ToDoListService({required this.listRepo});

  Future<void> createList({required ToDoListModel list}) async {
    await listRepo.createToDoList(toDoList: list);
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
