import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:notes/Databases/NotesDB.dart';
import 'package:notes/Models/Note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class NoteViewPageService {
  static Future<bool> saveNote(Note note) async {
    Directory tempDir = await getTemporaryDirectory();

    if (note.title!.isEmpty) note.title = "NoTitle";

    File tempFile = File('${tempDir.path}/${note.title}.txt');
    await tempFile.writeAsString(note.content);

    final params = SaveFileDialogParams(sourceFilePath: tempFile.path);
    final filePath = await FlutterFileDialog.saveFile(params: params);

    return (filePath == null) ? false : true;
  }

  static Future<void> saveAndExit({
    required BuildContext context,
    required Note? note,
    required String titlecontrollerText,
    required String contentControllerText,
  }) async {
    if (note == null) {
      if (contentControllerText.isNotEmpty) {
        String title = (titlecontrollerText.isNotEmpty)
            ? titlecontrollerText
            : "No Title";

        await context.read<NotesDB>().addNewNote(
          Note(title: title, content: contentControllerText),
        );
      }
    } else {
      if (note!.title != titlecontrollerText ||
          note!.content != contentControllerText) {
        note!.title = titlecontrollerText;
        note!.content = contentControllerText;

        await context.read<NotesDB>().updateNote(note);
      }
    }
  }
}
