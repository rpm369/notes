import 'package:flutter/material.dart';
import 'package:notes/Models/BlockModel.dart';
import 'package:notes/Models/NotesModel.dart';
import 'package:notes/Services/BlockService.dart';
import 'package:notes/Services/NotesService.dart';

class NotesPageViewModel extends ChangeNotifier {
  late NotesService notesService;
  late BlockService blockService;

  NotesPageViewModel({required this.notesService, required this.blockService});

  bool isLoading = false;
  List<BlockModel> _blocks = [];
  Map<int, List<NotesModel>> _notesByBlock = {};
  List<BlockModel> _searchedBlocks = [];
  Map<int, List<NotesModel>> _searchedNotesByBlock = {};
  Set<int> expandedBlocks = {};
  String errorMessage = '';

  List<BlockModel> get blocks {
    return _searchedBlocks;
  }

  Map<int, List<NotesModel>> get notesByBlock {
    return _searchedNotesByBlock;
  }

  //Initial Data Loading Methods

  Future<void> loadData() async {
    errorMessage = '';
    isLoading = true;
    notifyListeners();

    try {
      _blocks = await blockService.getAllBlocks();
      _notesByBlock.clear();

      for (BlockModel block in _blocks) {
        _notesByBlock[block.id!] = await notesService.getNotesForBlock(
          blockId: block.id!,
        );
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    _searchedBlocks = _blocks;
    _searchedNotesByBlock = _notesByBlock;

    isLoading = false;
    notifyListeners();
  }

  //UI related Operations

  void toggleBlockExpansion({required int blockId}) {
    if (expandedBlocks.contains(blockId)) {
      expandedBlocks.remove(blockId);
    } else {
      expandedBlocks.add(blockId);
    }
    notifyListeners();
  }

  bool isExpanded({required int blockId}) {
    return expandedBlocks.contains(blockId);
  }

  void updateSearchQuery({required String query}) {
    if (query.isEmpty) {
      _searchedBlocks = _blocks;
      _searchedNotesByBlock = _notesByBlock;
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    Map<int, List<NotesModel>> tempNotesByBlock = {};
    List<BlockModel> tempBlocks = [];

    for (MapEntry<int, List<NotesModel>> entry in _notesByBlock.entries) {
      tempNotesByBlock[entry.key] = [];

      for (NotesModel note in entry.value) {
        if (note.title == null && note.content == null) continue;
        if ((note.title?.contains(query) ?? false) ||
            (note.content?.contains(query) ?? false))
          tempNotesByBlock[entry.key]!.add(note);
      }

      if (tempNotesByBlock[entry.key]!.isEmpty)
        tempNotesByBlock.remove(entry.key);
      else {
        tempBlocks.add(_blocks.firstWhere((block) => block.id! == entry.key));
      }

      _searchedBlocks = tempBlocks;
      _searchedNotesByBlock = tempNotesByBlock;
    }

    isLoading = false;
    notifyListeners();
  }

  // Block related Operations

  Future<void> createBlock({required BlockModel block}) async {
    await blockService.createBlock(block: block);
    loadData();
  }

  Future<void> deleteBlockWithNotes({required int blockId}) async {
    await blockService.deleteBlockWithNotes(blockId: blockId);
    loadData();
  }

  Future<void> deleteBlockWithoutNotes({required int blockId}) async {
    await blockService.deleteBlockWithoutNotes(blockId: blockId);

    loadData();
  }

  Future<void> renameBlock({required BlockModel block}) async {
    await blockService.renameBlock(block: block);
    loadData();
  }

  // Notes Operations

  Future<void> moveNotesToTrash({required List<NotesModel> notes}) async {
    await notesService.moveNotesToTrash(notesList: notes);
    loadData();
  }

  Future<void> moveNotesToBlock({
    required List<int> noteIds,
    required int blockId,
  }) async {
    await notesService.moveNotesToBlock(noteIds: noteIds, blockId: blockId);
    loadData();
  }
}
