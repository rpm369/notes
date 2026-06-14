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

      query = query.toLowerCase();

      for (NotesModel note in entry.value) {
        if (note.title == null && note.content == null) continue;
        if ((note.title?.toLowerCase().contains(query) ?? false) ||
            (note.content?.toLowerCase().contains(query) ?? false))
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

  Future<void> createBlock({required String title}) async {
    await blockService.createBlock(block: BlockModel(title: title));
    await loadData();
  }

  Future<void> deleteBlockWithNotes({required int blockId}) async {
    await blockService.deleteBlockWithNotes(blockId: blockId);
    await loadData();
  }

  Future<void> deleteBlockWithoutNotes({required int blockId}) async {
    await blockService.deleteBlockWithoutNotes(blockId: blockId);
    await loadData();
  }

  Future<void> renameBlock({
    required int blockId,
    required String newTitle,
  }) async {
    await blockService.renameBlock(
      block: BlockModel(id: blockId, title: newTitle),
    );
    await loadData();
  }

  // Notes Operations

  Future<void> moveNotesToTrash({required List<int> noteIds}) async {
    List<NotesModel> notesToTrash = [];
    for (List<NotesModel> notes in _notesByBlock.values) {
      for (NotesModel note in notes) {
        if (noteIds.contains(note.id)) {
          notesToTrash.add(note);
        }
      }
    }
    await notesService.moveNotesToTrash(notesList: notesToTrash);
    await loadData();
  }

  Future<void> moveNotesToBlock({
    required List<int> noteIds,
    required int blockId,
  }) async {
    await notesService.moveNotesToBlock(noteIds: noteIds, blockId: blockId);
    await loadData();
  }
}
