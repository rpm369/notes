import 'package:notes/Models/ContentImageModel.dart';
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

  Future<int> createNote({
    required NotesModel note,
    required List<ContentImageModel> images,
  }) async {
    //storing the notes and getting their auto-generated id.
    int id = await notesRepo.createNote(note: note);

    imageService.saveImages(imageList: images, noteId: id);

    //modifying the note with new id for sheduling reminders.
    note = note.copyWith(
      id: id,
      blockId: note.blockId,
      deletedAt: note.deletedAt,
      reminder: note.reminder,
    );

    if (note.reminder != null)
      await reminderService.scheduleReminder(note: note);

    return id;
  }

  Future<List<NotesModel>> getNotesForBlock({required int blockId}) async {
    return await notesRepo.getNotesForBlock(blockId: blockId);
  }

  Future<List<NotesModel>> getReminderNotes() async {
    return await notesRepo.getReminderNotes();
  }

  Future<List<NotesModel>> getTrashNotes() async {
    return await notesRepo.getTrashNotes();
  }

  Future<void> moveNotesToTrash({required List<NotesModel> notesList}) async {
    for (NotesModel note in notesList) {
      note = note.copyWith(
        blockId: note.blockId,
        deletedAt: DateTime.now(),
        reminder: note.reminder,
      );

      if (note.reminder != null)
        await reminderService.cancelReminder(noteId: note.id!);

      await notesRepo.updateNote(note: note);
    }
  }

  Future<void> restoreTrashNotes({required List<NotesModel> notesList}) async {
    for (NotesModel note in notesList) {
      bool isOutDated = true;

      if (note.reminder != null)
        isOutDated = (note.reminder!.compareTo(DateTime.now()) <= 0);

      if (!isOutDated) await reminderService.scheduleReminder(note: note);

      note = note.copyWith(
        blockId: note.blockId,
        deletedAt: null,
        reminder: (isOutDated) ? null : note.reminder,
      );
      await notesRepo.updateNote(note: note);
    }
  }

  Future<void> deleteNotesPermanently({required List<int> noteIds}) async {
    for (int noteId in noteIds) {
      await imageService.deleteImageFor(notesId: noteId);
      await notesRepo.deletePermanently(noteId: noteId);
    }
  }

  Future<void> updateNote({
    required NotesModel note,
    required bool updateReminder,
    required List<ContentImageModel> newImages,
    required List<ContentImageModel> deletedImages,
  }) async {
    if (updateReminder) {
      if (note.reminder != null)
        await reminderService.scheduleReminder(note: note);
      else
        await reminderService.cancelReminder(noteId: note.id!);
    }

    for (ContentImageModel image in deletedImages) {
      await imageService.deleteImage(image: image);
    }
    await imageService.saveImages(imageList: newImages, noteId: note.id!);

    await notesRepo.updateNote(note: note);
  }

  Future<void> moveNotesToBlock({
    required List<int> noteIds,
    required int blockId,
  }) async {
    for (int noteId in noteIds) {
      await notesRepo.changeBlockFor(noteId: noteId, newBlockId: blockId);
    }
  }
}
