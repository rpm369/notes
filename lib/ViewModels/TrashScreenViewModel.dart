import 'package:flutter/material.dart';
import 'package:notes/Models/NotesModel.dart';
import 'package:notes/Services/NotesService.dart';

class TrashScreenViewModel extends ChangeNotifier {
  final NotesService _notesService;
  TrashScreenViewModel({required this._notesService});

  bool isLoading = false;
  String errorMessage = '';
  List<NotesModel> _notes = [];
  List<NotesModel> _searchedNotes = [];

  List<NotesModel> get allNotes => _searchedNotes;

  // Initial Data loading
  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      _notes = await _notesService.getTrashNotes();
      _searchedNotes = _notes;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateQuery({required String query}) async {
    if (query.isEmpty) {
      _searchedNotes = _notes;
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    query = query.toLowerCase();
    List<NotesModel> tempNotesList = [];

    for (NotesModel note in _notes) {
      if ((note.title?.isEmpty ?? false) && (note.content?.isEmpty ?? false))
        continue;

      if ((note.title?.toLowerCase().contains(query) ?? false) ||
          (note.content?.toLowerCase().contains(query) ?? false)) {
        tempNotesList.add(note);
      }
    }
    _searchedNotes = tempNotesList;

    isLoading = false;
    notifyListeners();
  }

  Future<void> restoreNote({required List<int> notesIds}) async {
    await _notesService.restoreTrashNotes(
      notesList: _notes.where((note) => notesIds.contains(note.id!)).toList(),
    );
    await loadData();
  }

  Future<void> deletePermanently({required List<int> noteIds}) async {
    await _notesService.deleteNotesPermanently(noteIds: noteIds);
    await loadData();
  }

  int get totalNotesInTrash => _notes.length;
}
