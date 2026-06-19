import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:notes/Models/BlockModel.dart';
import 'package:notes/Models/ContentImageModel.dart';
import 'package:notes/Models/NotesModel.dart';
import 'package:notes/Services/BlockService.dart';
import 'package:notes/Services/ImageStorageService.dart';
import 'package:notes/Services/NotesService.dart';

class NotesDetailViewModel extends ChangeNotifier {
  final NotesService _notesService;
  final BlockService _blockService;
  final ImageStorageService _imageService;

  NotesDetailViewModel({
    required this._imageService,
    required NotesService notesService,
    required BlockService blockService,
  }) : _notesService = notesService,
       _blockService = blockService;

  NotesModel? _currentNote;
  List<ContentImageModel> _existingImages = [];
  List<ContentImageModel> _deletedImages = [];
  List<ContentImageModel> _insertedImages = [];

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

      // Load existing images from db
      _existingImages = await _imageService.imageRepo.getAllImagesFor(
        noteId: existingNote.id!,
      );
      _insertedImages = [];
      _deletedImages = [];
    } else {
      _currentNote = NotesModel(
        blockId: null,
        title: "",
        content: "",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _existingImages = [];
      _insertedImages = [];
      _deletedImages = [];
    }

    _reminderChanged = false;
    _isLoading = false;
    notifyListeners();
  }

  void addInsertedImages(List<String> imagePaths) {
    for (final path in imagePaths) {
      final image = ContentImageModel(
        imagePath: path,
        noteId: _currentNote?.id,
      );
      _insertedImages.add(image);
    }
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

        final id = await _notesService.createNote(
          note: newNote,
          images: _insertedImages,
        );
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
          newImages: _insertedImages,
          deletedImages: _deletedImages,
        );
        _currentNote = updatedNote;
      }

      if (_currentNote!.id != null) {
        _existingImages = await _imageService.imageRepo.getAllImagesFor(
          noteId: _currentNote!.id!,
        );
        _insertedImages = [];
        _deletedImages = [];
      }

      _reminderChanged = false;
    } catch (e) {
      debugPrint("Failed to save note: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String resolveImagePathsInContent(String contentJsonStr) {
    if (_existingImages.isEmpty) return contentJsonStr;
    try {
      final List<dynamic> deltaJson = jsonDecode(contentJsonStr);
      int dbImageIndex = 0;
      for (var operation in deltaJson) {
        if (operation is Map) {
          final insert = operation['insert'];
          if (insert is Map && insert.containsKey('image')) {
            if (dbImageIndex < _existingImages.length) {
              insert['image'] = _existingImages[dbImageIndex].imagePath;
              dbImageIndex++;
            }
          }
        }
      }
      return jsonEncode(deltaJson);
    } catch (e) {
      return contentJsonStr;
    }
  }

  void syncImagesFromDelta(List<Map<String, dynamic>> deltaJson) {
    final List<String> currentImagePaths = [];
    for (var operation in deltaJson) {
      final insert = operation['insert'];
      if (insert is Map && insert.containsKey('image')) {
        final imagePath = insert['image'];
        if (imagePath is String) {
          currentImagePaths.add(imagePath);
        }
      }
    }

    bool changed = false;

    // Identify deleted images from existingImages
    final List<ContentImageModel> newlyDeleted = [];
    for (var img in _existingImages) {
      if (!currentImagePaths.contains(img.imagePath)) {
        newlyDeleted.add(img);
      }
    }

    if (newlyDeleted.isNotEmpty) {
      for (var img in newlyDeleted) {
        _existingImages.remove(img);
        _deletedImages.add(img);
      }
      changed = true;
    }

    // Identify deleted images from insertedImages
    final initialInsertedCount = _insertedImages.length;
    _insertedImages.removeWhere(
      (img) => !currentImagePaths.contains(img.imagePath),
    );
    if (_insertedImages.length != initialInsertedCount) {
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  List<ContentImageModel> get associatedImages => _existingImages;
  List<ContentImageModel> get insertedImages => _insertedImages;
  List<ContentImageModel> get deletedImages => _deletedImages;

  void addInsertedImage(String imagePath) {
    addInsertedImages([imagePath]);
  }

  void deleteImage(ContentImageModel image) {
    deleteImageByPath(image.imagePath);
  }

  void deleteImageByPath(String imagePath) {
    final existingIndex = _existingImages.indexWhere(
      (img) => img.imagePath == imagePath,
    );
    if (existingIndex != -1) {
      final img = _existingImages.removeAt(existingIndex);
      _deletedImages.add(img);
      notifyListeners();
      return;
    }

    final insertedIndex = _insertedImages.indexWhere(
      (img) => img.imagePath == imagePath,
    );
    if (insertedIndex != -1) {
      _insertedImages.removeAt(insertedIndex);
      notifyListeners();
    }
  }
}
