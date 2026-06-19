import 'package:flutter/material.dart';
import 'package:notes/Models/BlockModel.dart';
import 'package:notes/Models/NotesModel.dart';
import 'package:notes/Services/BlockService.dart';
import 'package:notes/Services/NotesService.dart';

class NotesDetailViewModel extends ChangeNotifier {
  final NotesService _notesService;
  final BlockService _blockService;

  NotesDetailViewModel({
    required NotesService notesService,
    required BlockService blockService,
  }) : _notesService = notesService,
       _blockService = blockService;

  NotesModel? _currentNote;
  List<BlockModel> _blocks = [];
  bool _isLoading = false;
  bool _reminderChanged = false;

  bool get hasReminder => this._currentNote?.reminder != null;
  NotesModel? get currentNote => _currentNote;
  List<BlockModel> get blocks => _blocks;
  bool get isLoading => _isLoading;

  Future<void> initNote(NotesModel? existingNote) async {
    _isLoading = true;
    notifyListeners();

    _blocks = await _blockService.getAllBlocks();

    if (existingNote != null) {
      // Reload from DB to ensure fresh state
      final fresh = await _notesService.notesRepo.getNote(
        noteId: existingNote.id!,
      );
      _currentNote = fresh ?? existingNote;
    } else {
      _currentNote = NotesModel(
        blockId: null,
        title: "",
        content: "",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    _reminderChanged = false;
    _isLoading = false;
    notifyListeners();
  }

  DateTime? getCurrentReminder() {
    return _currentNote!.reminder;
  }

  Future<void> updateBlockAssociation(int? newBlockId) async {
    if (_currentNote == null) return;

    _currentNote = NotesModel(
      id: _currentNote!.id,
      blockId: newBlockId,
      title: _currentNote!.title,
      content: _currentNote!.content,
      createdAt: _currentNote!.createdAt,
      updatedAt: DateTime.now(),
      reminder: _currentNote!.reminder,
      deletedAt: _currentNote!.deletedAt,
    );

    notifyListeners();
  }

  Future<void> updateReminder(DateTime? newReminder) async {
    if (_currentNote == null) return;

    _currentNote = NotesModel(
      id: _currentNote!.id,
      blockId: _currentNote!.blockId,
      title: _currentNote!.title,
      content: _currentNote!.content,
      createdAt: _currentNote!.createdAt,
      updatedAt: DateTime.now(),
      reminder: newReminder,
      deletedAt: _currentNote!.deletedAt,
    );

    _reminderChanged = true;
    notifyListeners();
  }

  Future<void> saveNote({
    required String title,
    required String content,
  }) async {
    if (_currentNote == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      if (_currentNote!.id == null) {
        final newNote = NotesModel(
          blockId: _currentNote!.blockId,
          title: title,
          content: content,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          reminder: _currentNote!.reminder,
        );

        final id = await _notesService.createNote(note: newNote, images: []);
        _currentNote = NotesModel(
          id: id,
          blockId: newNote.blockId,
          title: newNote.title,
          content: newNote.content,
          createdAt: newNote.createdAt,
          updatedAt: newNote.updatedAt,
          reminder: newNote.reminder,
          deletedAt: null,
        );
      } else {
        final updatedNote = NotesModel(
          id: _currentNote!.id,
          blockId: _currentNote!.blockId,
          title: title,
          content: content,
          createdAt: _currentNote!.createdAt,
          updatedAt: DateTime.now(),
          reminder: _currentNote!.reminder,
          deletedAt: _currentNote!.deletedAt,
        );

        await _notesService.updateNote(
          note: updatedNote,
          updateReminder: _reminderChanged,
          newImages: [],
          deletedImages: [],
        );
        _currentNote = updatedNote;
      }
      _reminderChanged = false;
    } catch (e) {
      debugPrint("Failed to save note: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
