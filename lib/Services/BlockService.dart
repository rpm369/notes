import 'package:notes/Models/BlockModel.dart';
import 'package:notes/Repos/BlockRepository.dart';
import 'package:notes/Repos/NoteRepository.dart';
import 'package:notes/Services/NotesService.dart';

class BlockService {
  final BlockRepository blockRepo;
  final NoteRepository notesRepo;
  BlockService({required this.blockRepo, required this.notesRepo});

  Future<void> createBlock({required BlockModel block}) async {}
  Future<List<BlockModel>> getAllBlocks() async {}
  Future<void> renameBlock({required BlockModel block}) async {}
  Future<void> deleteBlockWithNotes({required int blockId}) async {}
  Future<void> deleteBlockWithoutNotes({required int blockId}) async {}
  Future<int> getTotalNotesInBlock({required int blockId}) async {}
}
