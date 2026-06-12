import 'package:notes/Models/BlockModel.dart';
import 'package:notes/Models/NotesModel.dart';
import 'package:notes/Repos/BlockRepository.dart';
import 'package:notes/Services/NotesService.dart';
import 'package:notes/Utils/NotificationCenter.dart';

class BlockService {
  final BlockRepository blockRepo;
  final NotesService notesService;
  BlockService({required this.blockRepo, required this.notesService});

  Future<void> createBlock({required BlockModel block}) async {
    await blockRepo.createBlock(block: block);
  }

  Future<List<BlockModel>> getAllBlocks() async {
    return await blockRepo.getAllBlocks();
  }

  Future<void> renameBlock({required BlockModel block}) async {
    await blockRepo.updateBlock(block: block);
  }

  Future<void> deleteBlockWithNotes({required int blockId}) async {
    List<NotesModel> notes = await notesService.getNotesForBlock(
      blockId: blockId,
    );

    List<int> notesId = [];
    for (NotesModel note in notes) {
      notesId.add(note.id!);
      if (note.reminder != null)
        await NotificationCenter.cancelNotificaion(id: note.id!);
    }

    await notesService.deleteNotesPermanently(noteIds: notesId);
    blockRepo.deleteBlock(blockId: blockId);
  }

  Future<void> deleteBlockWithoutNotes({required int blockId}) async {
    await notesService.removeBlockAssociations(blockId: blockId);
  }

  Future<int> getTotalNotesInBlock({required int blockId}) async {
    return await notesService.getTotalNotesInBlock(blockId: blockId);
  }
}
