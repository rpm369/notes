import 'package:notes/Models/BlockModel.dart';

abstract class Blockrepository {
  Future<int> createBlock({required BlockModel block});
  Future<void> updateBlock({required BlockModel block});
  Future<void> deleteBlock({required int blockId});
  Future<int> getTotalNotesInBlock({required int blockId});
  Future<List<BlockModel>> getAllBlocks();
}
