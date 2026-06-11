import 'package:notes/Models/ContentImageModel.dart';
import 'package:notes/Repos/ContentImageRepo.dart';
import 'package:sqflite/sqflite.dart';

class ContentImageLocalRepository implements ContentImageRepo {
  final Database _db;
  ContentImageLocalRepository({required this._db});

  @override
  Future<int> addImage({required ContentImageModel image}) async {
    return await _db.insert('content_images', image.toJson());
  }

  @override
  Future<void> deleteImage({required int id}) async {
    await _db.delete('content_images', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteImageFor({required int notesId}) async {
    await _db.delete(
      'content_images',
      where: 'noteId = ?',
      whereArgs: [notesId],
    );
  }

  @override
  Future<List<ContentImageModel>> getAllImagesFor({required int noteId}) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'content_images',
      where: 'noteId = ?',
      whereArgs: [noteId],
    );
    return maps.map((json) => ContentImageModel.fromJson(json: json)).toList();
  }
}
