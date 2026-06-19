import 'package:notes/Models/NotesModel.dart';
import 'package:notes/Utils/NotificationCenter.dart';

class ReminderService {
  Future<void> scheduleReminder({required NotesModel note}) async {
    if (await NotificationCenter.isAlreadyScheduled(key: note.id!)) {
      await cancelReminder(noteId: note.id!);
    }

    await NotificationCenter.sheduleNotification(
      id: note.id!,
      title: note.title ?? "No Title",
      body: note.content ?? "No content",
      scheduledDateTime: note.reminder!,
    );
  }

  Future<void> cancelReminder({required int noteId}) async {
    await NotificationCenter.cancelNotificaion(id: noteId);
  }
}
