import 'package:flutter/material.dart';
import 'package:notes/Models/ToDoListModel.dart';
import 'package:notes/Models/ToDoModel.dart';
import 'package:notes/Services/ToDoListService.dart';
import 'package:notes/Services/ToDoService.dart';

class ToDoListPageViewModel extends ChangeNotifier {
  final ToDoListService _listService;
  final ToDoService _toDoService;

  ToDoListPageViewModel({
    required ToDoListService listService,
    required ToDoService toDoService,
  }) : _listService = listService,
       _toDoService = toDoService;

  bool isLoading = false;
  String errorMessage = '';
  Set<int> expandedLists = {};
  List<ToDoListModel> toDoLists = [];
  Map<int, List<ToDoModel>> toDosByList = {};

  //Initial Data Loading

  Future<void> loadData() async {
    errorMessage = '';
    isLoading = true;
    notifyListeners();

    toDosByList.clear();

    try {
      toDoLists = await _listService.getAllLists();
      for (ToDoListModel list in toDoLists) {
        toDosByList[list.id!] = await _toDoService.getToDosForList(
          listId: list.id!,
        );
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // UI related Operations

  void toggleListExpansion({required int listId}) {
    if (expandedLists.contains(listId)) {
      expandedLists.remove(listId);
    } else {
      expandedLists.add(listId);
    }

    notifyListeners();
  }

  bool isListExpanded({required int listId}) {
    return expandedLists.contains(listId);
  }

  // List related Operations

  Future<void> deleteToDoList({required int listId}) async {
    await _listService.deleteList(listId: listId);
    await loadData();
  }

  Future<void> renameList({
    required int listId,
    required String newTitle,
  }) async {
    await _listService.renameList(
      list: ToDoListModel(id: listId, title: newTitle),
    );
    await loadData();
  }

  Future<void> createToDoList({
    required String title,
    required List<String> toDoNames,
  }) async {
    await _listService.createList(
      list: ToDoListModel(title: title),
      toDos: toDoNames.map((name) => ToDoModel(listId: 0, name: name)).toList(),
    );

    await loadData();
  }

  // ToDo related Operations

  Future<void> toggleToDoCompletion({required int toDoId}) async {
    await _toDoService.toggleCompletion(toDoId: toDoId);
    await loadData();
  }
}
