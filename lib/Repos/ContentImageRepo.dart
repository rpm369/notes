import 'package:notes/Models/ContentImageModel.dart';

abstract class ContentImageRepo {
  Future<int> addImage({required ContentImageModel image});
  Future<void> deleteImage({required int id});
  Future<List<ContentImageModel>> getAllImagesFor({required int noteId});
  Future<void> deleteImageFor({required int notesId});
}
