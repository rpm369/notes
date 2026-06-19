import 'dart:io';

import 'package:notes/Models/ContentImageModel.dart';
import 'package:notes/Repos/ContentImageRepo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class ImageStorageService {
  final ContentImageRepo imageRepo;
  String? _docDirPath;
  ImageStorageService({required this.imageRepo});

  Future<void> saveImages({
    required List<ContentImageModel> imageList,
    required int noteId,
  }) async {
    for (ContentImageModel image in imageList) {
      String newPath = await storeImage(image: image);
      image = image.copyWith(noteId: noteId, imagePath: newPath);
      await imageRepo.addImage(image: image);
    }
  }

  Future<List<ContentImageModel>> getAllImagesForNote({
    required int noteId,
  }) async {
    return await imageRepo.getAllImagesFor(noteId: noteId);
  }

  Future<void> deleteImage({required ContentImageModel image}) async {
    await deleteImageFromDisk(imagePath: image.imagePath);
    await imageRepo.deleteImage(id: image.id!);
  }

  //No requirement to delete from db as images are cascade on delete operation with their notes.
  Future<void> deleteImageFor({required int notesId}) async {
    List<ContentImageModel> images = await imageRepo.getAllImagesFor(
      noteId: notesId,
    );
    for (ContentImageModel image in images) {
      await deleteImageFromDisk(imagePath: image.imagePath);
    }
  }

  Future<void> deleteImageFromDisk({required String imagePath}) async {
    await File(imagePath).delete();
  }

  Future<String> storeImage({required ContentImageModel image}) async {
    _docDirPath ??= (await getApplicationDocumentsDirectory()).path;
    String imageDirPath = path.join(_docDirPath!, "contentImages/");

    Directory imageDir = Directory(imageDirPath);

    if (!(await imageDir.exists())) {
      await imageDir.create(recursive: true);
    }

    String imageId = Uuid().v4();
    String imageLabel = imageId + path.extension(image.imagePath);

    String targetImagePath = path.join(imageDirPath, imageLabel);

    await File(image.imagePath).copy(targetImagePath);
    return targetImagePath;
  }
}
