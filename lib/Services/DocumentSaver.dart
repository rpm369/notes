import 'dart:io';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:notes/Models/Note.dart';
import 'package:path_provider/path_provider.dart';

class DocumentSaver {
  static Future<bool> saveNote(Note note) async {
    Directory tempDir = await getTemporaryDirectory();

    if (note.title!.isEmpty) note.title = "NoTitle";

    File tempFile = File('${tempDir.path}/${note.title}.txt');
    await tempFile.writeAsString(note.content);

    final params = SaveFileDialogParams(sourceFilePath: tempFile.path);
    final filePath = await FlutterFileDialog.saveFile(params: params);

    return (filePath == null) ? false : true;
  }
}
