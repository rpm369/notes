import 'package:flutter/material.dart';
import 'package:notes/Models/NotesModel.dart';
import 'package:notes/Services/NotesService.dart';

class RemindersScreenViewModel extends ChangeNotifier {
  final NotesService _notesService;
  RemindersScreenViewModel({required this._notesService});

  bool isLoading = false;
  String errorMessage = '';
  List<NotesModel> _reminderNotes = [];

  List<NotesModel> get reminderNotes => _reminderNotes;

  // Initial Data loading
  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      _reminderNotes = await _notesService.getReminderNotes();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  int get totalReminderCount => _reminderNotes.length;

  Future<void> cancelReminder({required NotesModel note}) async {
    await _notesService.updateNote(
      note: note.copyWith(
        blockId: note.blockId,
        deletedAt: note.deletedAt,
        reminder: null,
      ),
      updateReminder: true,
      newImages: [],
      deletedImages: [],
    );

    await loadData();
  }
}
