import 'package:notes/Models/BlockModel.dart';
import 'package:notes/Repos/BlockRepository.dart';
import 'package:sqflite/sqlite_api.dart';

class LocalBlockRespository implements BlockRepository {
  final Database _db;

  LocalBlockRespository({required this._db});

  @override
  Future<int> createBlock({required BlockModel block}) async {
    return await _db.insert('blocks', block.toJson());
  }

  @override
  Future<void> deleteBlock({required int blockId}) async {
    await _db.delete('blocks', where: 'id = ?', whereArgs: [blockId]);
  }

  @override
  Future<List<BlockModel>> getAllBlocks() async {
    final List<Map<String, dynamic>> maps = await _db.query('blocks');
    return maps.map((json) => BlockModel.fromJson(json: json)).toList();
  }

  @override
  Future<void> updateBlock({required BlockModel block}) async {
    await _db.update(
      'blocks',
      block.toJson(),
      where: 'id = ?',
      whereArgs: [block.id],
    );
  }
}
