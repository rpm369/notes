import 'package:notes/Models/BlockModel.dart';

abstract class Blockrepository {
  Future<int> createBlock({required BlockModel block});
  Future<bool> updateBlock({required BlockModel block});
  Future<bool> deleteBlock({required BlockModel block});
  Future<int> getTotalNotesInBlock({required int blockId});
  Future<List<BlockModel>?> getAllBlocks();
}
