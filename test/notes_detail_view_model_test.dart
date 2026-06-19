import 'package:flutter_test/flutter_test.dart';
import 'package:notes/Models/NotesModel.dart';
import 'package:notes/Models/BlockModel.dart';
import 'package:notes/Models/ContentImageModel.dart';
import 'package:notes/ViewModels/NotesDetailViewModel.dart';
import 'package:notes/Services/NotesService.dart';
import 'package:notes/Services/BlockService.dart';
import 'package:notes/Services/ReminderService.dart';
import 'package:notes/Services/ImageStorageService.dart';
import 'package:notes/Repos/NoteRepository.dart';
import 'package:notes/Repos/BlockRepository.dart';
import 'package:notes/Repos/ContentImageRepo.dart';

class FakeNoteRepository implements NoteRepository {
  final List<NotesModel> notes = [];

  @override
  Future<int> createNote({required NotesModel note}) async {
    final newId = notes.length + 1;
    notes.add(
      note.copyWith(
        id: newId,
        blockId: note.blockId,
        deletedAt: null,
        reminder: null,
      ),
    );
    return newId;
  }

  @override
  Future<void> updateNote({required NotesModel note}) async {
    final idx = notes.indexWhere((element) => element.id == note.id);
    if (idx != -1) {
      notes[idx] = note;
    }
  }

  @override
  Future<NotesModel?> getNote({required int noteId}) async {
    final matched = notes.where((element) => element.id == noteId);
    return matched.isNotEmpty ? matched.first : null;
  }

  @override
  Future<void> deletePermanently({required int noteId}) async {}
  @override
  Future<void> removeBlockAssociation({required int blockId}) async {}
  @override
  Future<List<NotesModel>> getNotesForBlock({required int? blockId}) async =>
      [];
  @override
  Future<List<NotesModel>> getTrashNotes() async => [];
  @override
  Future<List<NotesModel>> getReminderNotes() async => [];
  @override
  Future<void> changeBlockFor({
    required int noteId,
    required int? newBlockId,
  }) async {}
}

class FakeBlockRepository implements BlockRepository {
  @override
  Future<List<BlockModel>> getAllBlocks() async {
    return [
      const BlockModel(id: 1, title: "IDEAS"),
      const BlockModel(id: 2, title: "BALLET"),
    ];
  }

  @override
  Future<int> createBlock({required BlockModel block}) async => 0;
  @override
  Future<void> updateBlock({required BlockModel block}) async {}
  @override
  Future<void> deleteBlock({required int blockId}) async {}
}

class FakeReminderService extends ReminderService {
  @override
  Future<void> scheduleReminder({required NotesModel note}) async {}
  @override
  Future<void> cancelReminder({required int noteId}) async {}
}

class FakeContentImageRepo implements ContentImageRepo {
  @override
  Future<int> addImage({required ContentImageModel image}) async => 0;
  @override
  Future<void> deleteImage({required int id}) async {}
  @override
  Future<List<ContentImageModel>> getAllImagesFor({
    required int noteId,
  }) async => [];
  @override
  Future<void> deleteImageFor({required int notesId}) async {}
}

class FakeImageStorageService extends ImageStorageService {
  FakeImageStorageService() : super(imageRepo: FakeContentImageRepo());

  @override
  Future<void> saveImages({
    required List<ContentImageModel> imageList,
    required int noteId,
  }) async {}

  @override
  Future<void> deleteImage({required ContentImageModel image}) async {}

  @override
  Future<void> deleteImageFor({required int notesId}) async {}
}

void main() {
  late NotesDetailViewModel viewModel;
  late FakeNoteRepository fakeNotesRepo;
  late FakeBlockRepository fakeBlocksRepo;

  setUp(() {
    fakeNotesRepo = FakeNoteRepository();
    fakeBlocksRepo = FakeBlockRepository();

    final notesService = NotesService(
      notesRepo: fakeNotesRepo,
      reminderService: FakeReminderService(),
      imageService: FakeImageStorageService(),
    );

    final blockService = BlockService(
      blockRepo: fakeBlocksRepo,
      notesService: notesService,
    );

    viewModel = NotesDetailViewModel(
      notesService: notesService,
      blockService: blockService,
    );
  });

  group('NotesDetailViewModel State Tests', () {
    test(
      'initNote creates new note with default fields when no existing note provided',
      () async {
        await viewModel.initNote(null);

        expect(viewModel.currentNote, isNotNull);
        expect(viewModel.currentNote!.id, isNull);
        expect(viewModel.currentNote!.blockId, 5);
        expect(viewModel.currentNote!.title, "");
        expect(viewModel.currentNote!.content, "");
        expect(viewModel.blocks.length, 2);
        expect(viewModel.blocks.first.title, "IDEAS");
      },
    );

    test('initNote loads existing note info correctly', () async {
      final existingNote = NotesModel(
        id: 42,
        blockId: 1,
        title: "Existing",
        content: "Content",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      fakeNotesRepo.notes.add(existingNote);

      await viewModel.initNote(existingNote);

      expect(viewModel.currentNote, isNotNull);
      expect(viewModel.currentNote!.id, 42);
      expect(viewModel.currentNote!.title, "Existing");
      expect(viewModel.currentNote!.blockId, 1);
    });

    test('updateBlockAssociation updates blockId in state', () async {
      await viewModel.initNote(null);
      expect(viewModel.currentNote!.blockId, 1);

      await viewModel.updateBlockAssociation(2);
      expect(viewModel.currentNote!.blockId, 2);
    });

    test('updateReminder updates reminder datetime in state', () async {
      await viewModel.initNote(null);
      expect(viewModel.currentNote!.reminder, isNull);

      final now = DateTime.now();
      await viewModel.updateReminder(now);
      expect(viewModel.currentNote!.reminder, now);
    });
  });
}
