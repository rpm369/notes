import 'package:notes/Models/ToDoListModel.dart';
import 'package:notes/Repos/ToDoListRepository.dart';

class ToDoListService {
  final ToDoListRepository listRepo;
  ToDoListService({required this.listRepo});

  Future<void> createList({required ToDoListModel list}) async {}
  Future<void> deleteList({required int listId}) async {}
  Future<List<ToDoListModel>> getAllLists() async {}
  Future<void> renameList({required ToDoListModel list}) async {}
}
