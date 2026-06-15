import 'package:flutter_test/flutter_test.dart';
import 'package:notes/Models/BlockModel.dart';
import 'package:notes/Models/NotesModel.dart';

void main() {
  group('BlockModel Tests', () {
    test('toJson and fromJson should be symmetric', () {
      const block = BlockModel(id: 42, title: "Test Block");
      final json = block.toJson();
      
      expect(json['id'], 42);
      expect(json['title'], "Test Block");

      final parsedBlock = BlockModel.fromJson(json: json);
      expect(parsedBlock.id, 42);
      expect(parsedBlock.title, "Test Block");
    });

    test('copyWith should copy and update fields correctly', () {
      const block = BlockModel(id: 1, title: "Original Title");
      final updatedBlock = block.copyWith(title: "New Title");

      expect(updatedBlock.id, 1);
      expect(updatedBlock.title, "New Title");
    });
  });

  group('NotesModel Tests', () {
    test('toJson and fromJson should be symmetric', () {
      final now = DateTime.now();
      final note = NotesModel(
        id: 99,
        blockId: 2,
        title: "Model Test Note",
        content: "Model Test Content",
        createdAt: now,
        updatedAt: now,
      );

      final json = note.toJson();
      expect(json['id'], 99);
      expect(json['blockId'], 2);
      expect(json['title'], "Model Test Note");
      expect(json['content'], "Model Test Content");
      expect(json['createdAt'], now.millisecondsSinceEpoch);

      final parsedNote = NotesModel.fromJson(json: json);
      expect(parsedNote.id, 99);
      expect(parsedNote.blockId, 2);
      expect(parsedNote.title, "Model Test Note");
      expect(parsedNote.content, "Model Test Content");
      // Allow minor differences in precision when parsing milliseconds
      expect(parsedNote.createdAt.millisecondsSinceEpoch, now.millisecondsSinceEpoch);
    });

    test('copyWith should update fields correctly', () {
      final now = DateTime.now();
      final note = NotesModel(
        id: 10,
        blockId: 5,
        title: "Old Title",
        content: "Old Content",
        createdAt: now,
        updatedAt: now,
      );

      final updatedNote = note.copyWith(
        blockId: 6,
        title: "New Title",
        content: "New Content",
        deletedAt: null,
        reminder: null,
      );

      expect(updatedNote.id, 10);
      expect(updatedNote.blockId, 6);
      expect(updatedNote.title, "New Title");
      expect(updatedNote.content, "New Content");
      expect(updatedNote.deletedAt, isNull);
    });
  });
}
