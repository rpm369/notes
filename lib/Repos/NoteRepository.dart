import 'package:notes/Models/NotesModel.dart';

abstract class NoteRepository {
  Future<int> createNote({required NotesModel note});
  Future<void> updateNote({required NotesModel note});
  Future<void> deletePermanently({required int noteId});
  Future<void> removeBlockAssociation({required int blockId});
  Future<List<NotesModel>> getNotesForBlock({required int? blockId});
  Future<List<NotesModel>> getTrashNotes();
  Future<List<NotesModel>> getReminderNotes();
  Future<NotesModel?> getNote({required int noteId});
  Future<void> changeBlockFor({required int noteId, required int? newBlockId});
}
