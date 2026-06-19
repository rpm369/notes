import 'package:notes/Models/NotesModel.dart';
import 'package:notes/Utils/NotificationCenter.dart';
import 'package:notes/Utils/DeltaParser.dart';

class ReminderService {
  Future<void> scheduleReminder({required NotesModel note}) async {
    if (await NotificationCenter.isAlreadyScheduled(key: note.id!)) {
      await cancelReminder(noteId: note.id!);
    }

    final cleanBody = DeltaParser.parseToPlainText(note.content);

    await NotificationCenter.sheduleNotification(
      id: note.id!,
      title: note.title ?? "No Title",
      body: cleanBody.isNotEmpty ? cleanBody : "No content",
      scheduledDateTime: note.reminder!,
    );
  }

  Future<void> cancelReminder({required int noteId}) async {
    await NotificationCenter.cancelNotificaion(id: noteId);
  }
}
