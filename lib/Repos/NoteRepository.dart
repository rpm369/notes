import 'package:notes/Models/NotesModel.dart';

abstract class NoteRepository {
  Future<int> createNote({
    NotesModel note,
  }); // Business Logic: Add Image and Shedule Reminders.
  Future<bool> updateNote({
    NotesModel note,
  }); // Business Logic: Remove/Add Images and Shedule/Revoke Reminders, Move to trash and restore from trash.
  Future<bool> deletePermanently({NotesModel note});
  Future<List<NotesModel>?> getNotesForBlock({
    int blockId,
  }); // Business Logic: Get image from disk.
  Future<List<NotesModel>?> getTrashNotes();
  Future<List<NotesModel>?> getReminderNotes();
  Future<NotesModel?> getNoteById({int noteId});
  Future<List<NotesModel>?> getAllNotes();
}
