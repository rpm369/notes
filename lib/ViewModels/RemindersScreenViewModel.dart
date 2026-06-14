import 'package:flutter/material.dart';
import 'package:notes/Models/NotesModel.dart';
import 'package:notes/Services/NotesService.dart';
import 'package:notes/Services/ReminderService.dart';

class RemindersScreenViewModel extends ChangeNotifier {
  final NotesService _notesService;
  final ReminderService _reminderService;
  RemindersScreenViewModel({
    required this._notesService,
    required this._reminderService,
  });

  bool isLoading = false;
  String errorMessage = '';
  List<NotesModel> reminderNotes = [];

  // Initial Data loading
  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      reminderNotes = await _notesService.getReminderNotes();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  int get totalReminderCount => reminderNotes.length;

  Future<void> cancelReminder({required int notesId}) async {
    await _reminderService.cancelReminder(noteId: notesId);
    await loadData();
  }
}
