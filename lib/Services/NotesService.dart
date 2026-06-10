import 'package:notes/Models/NotesModel.dart';
import 'package:notes/Repos/NoteRepository.dart';
import 'package:notes/Services/ImageStorageService.dart';
import 'package:notes/Services/ReminderService.dart';

class NotesService {
  final NoteRepository notesRepo;
  final ReminderService reminderService;
  final ImageStorageService imageService;

  NotesService({
    required this.notesRepo,
    required this.reminderService,
    required this.imageService,
  });

  Future<void> createNote({required NotesModel note}) async {}
  Future<List<NotesModel>> getNotesForBlock({required int blockId}) async {}
  Future<List<NotesModel>> getReminderNotes() async {}
  Future<List<NotesModel>> getTrashNotes() async {}
  Future<void> moveNotesToTrash({required List<int> noteIds}) async {}
  Future<void> restoreTrashNotes({required List<int> noteIds}) async {}
  Future<void> deleteNotesPermanently({required List<int> noteIds}) async {}
  Future<void> updateNote({required NotesModel note}) async {}
  Future<void> moveNotesToBlock({
    required List<int> noteIds,
    required int blockId,
  }) async {}
}
