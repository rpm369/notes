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
  Map<int?, List<NotesModel>> _notesByBlock = {};
  List<BlockModel> _searchedBlocks = [];
  Map<int?, List<NotesModel>> _searchedNotesByBlock = {};
  Set<int?> expandedBlocks = {};
  String errorMessage = '';

  List<BlockModel> get blocks {
    return _searchedBlocks;
  }

  Map<int?, List<NotesModel>> get notesByBlock {
    return _searchedNotesByBlock;
  }

  //Initial Data Loading Methods

  Future<void> loadData() async {
    errorMessage = '';
    isLoading = true;
    notifyListeners();

    try {
      _blocks = await blockService.getAllBlocks();

      // Seed initial dummy data if database is empty to match the user's mockup.
      if (_blocks.isEmpty) {
        await _seedInitialData();
        _blocks = await blockService.getAllBlocks();
      }

      _notesByBlock.clear();

      for (BlockModel block in _blocks) {
        _notesByBlock[block.id] = await notesService.getNotesForBlock(
          blockId: block.id,
        );
      }

      _notesByBlock[null] = await notesService.getNotesForBlock(blockId: null);

      // Auto-expand all blocks by default on first load
      if (expandedBlocks.isEmpty) {
        for (BlockModel block in _blocks) {
          expandedBlocks.add(block.id!);
        }
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

  void toggleBlockExpansion({required int? blockId}) {
    if (expandedBlocks.contains(blockId)) {
      expandedBlocks.remove(blockId);
    } else {
      expandedBlocks.add(blockId);
    }
    notifyListeners();
  }

  bool isExpanded({required int? blockId}) {
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

    Map<int?, List<NotesModel>> tempNotesByBlock = {};
    List<BlockModel> tempBlocks = [];

    for (MapEntry<int?, List<NotesModel>> entry in _notesByBlock.entries) {
      tempNotesByBlock[entry.key] = [];

      query = query.toLowerCase();

      for (NotesModel note in entry.value) {
        if (note.title == null && note.content == null) continue;
        if ((note.title?.toLowerCase().contains(query) ?? false) ||
            (note.content?.toLowerCase().contains(query) ?? false))
          tempNotesByBlock[entry.key]!.add(note);
      }

      if (tempNotesByBlock[entry.key]!.isEmpty) {
        tempNotesByBlock.remove(entry.key);
      } else {
        if (entry.key != null) {
          tempBlocks.add(_blocks.firstWhere((block) => block.id! == entry.key));
        }
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
    required int? blockId,
  }) async {
    await notesService.moveNotesToBlock(noteIds: noteIds, blockId: blockId);
    await loadData();
  }

  // Seed Initial Dummy Data to Match Cloned UI Mockup
  Future<void> _seedInitialData() async {
    try {
      // Direct insertion using blockService
      await blockService.createBlock(block: const BlockModel(title: "BALLET"));
      await blockService.createBlock(block: const BlockModel(title: "IDEAS"));

      final dbBlocks = await blockService.getAllBlocks();
      final balletBlock = dbBlocks.firstWhere(
        (b) => b.title == "BALLET",
        orElse: () => dbBlocks.first,
      );
      final ideasBlock = dbBlocks.firstWhere(
        (b) => b.title == "IDEAS",
        orElse: () => dbBlocks.first,
      );

      // Notes in BALLET block
      final note1 = NotesModel(
        blockId: balletBlock.id!,
        title: "sample",
        content: "[Photo]This is a content in different font...",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await notesService.createNote(note: note1, images: []);

      // Notes in IDEAS block
      final note2 = NotesModel(
        blockId: ideasBlock.id!,
        title: "hopper",
        content: "Kinetic",
        createdAt: DateTime(2026, 6, 8, 10, 0),
        updatedAt: DateTime(2026, 6, 8, 10, 0),
      );
      await notesService.createNote(note: note2, images: []);

      final note3 = NotesModel(
        blockId: ideasBlock.id!,
        title: "Shopping List",
        content: "SHOPPING LIST\n...",
        createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 8)),
      );
      await notesService.createNote(note: note3, images: []);

      final note4 = NotesModel(
        blockId: ideasBlock.id!,
        title: "Fanta",
        content: "Soda recipe and branding ideas",
        createdAt: DateTime.now().subtract(const Duration(minutes: 7)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 7)),
      );
      await notesService.createNote(note: note4, images: []);

      // Note in OTHERS block (null blockId)
      final noteOthers = NotesModel(
        blockId: null,
        title: "Uncategorized Item",
        content: "This note has no block association and belongs to OTHERS.",
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
      );
      await notesService.createNote(note: noteOthers, images: []);
    } catch (e) {
      print("Seeding failed: $e");
    }
  }
}
