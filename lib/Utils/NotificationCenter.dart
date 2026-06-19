import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:notes/Database/SqlDatabaseProvider.dart';
import 'package:notes/main.dart';

class NotificationCenter {
  static Future<void> initializeChannels() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'notesReminder',
        channelName: 'Note Reminder',
        channelDescription:
            'You create the note, and now you don\'t remember it yourself !',
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
    ]);

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: (action) async {
        await AwesomeNotifications().resetGlobalBadge();
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          '/',
          (route) => route.isFirst,
        );
      },
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification notification,
  ) async {
    final noteId = notification.id;
    if (noteId != null) {
      await _clearNoteReminder(noteId);
    }
  }

  static Future<void> _clearNoteReminder(int noteId) async {
    final db = await SqlDatabaseProvider.getDatabase();

    await db.update(
      'notes',
      {'reminder': null},
      where: 'id = ?',
      whereArgs: [noteId],
    );
  }

  static Future<bool> isAlreadyScheduled({required int key}) async {
    List<NotificationModel> notificationModels = await AwesomeNotifications()
        .listScheduledNotifications();

    for (NotificationModel model in notificationModels) {
      if (model.content!.id == key) return true;
    }
    return false;
  }

  static Future<void> sheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
  }) async {
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'notesReminder',
          title: title,
          body: body,
        ),
        schedule: NotificationCalendar(
          year: scheduledDateTime.year,
          month: scheduledDateTime.month,
          day: scheduledDateTime.day,
          hour: scheduledDateTime.hour,
          minute: scheduledDateTime.minute,
          second: 0,
          millisecond: 0,
        ),
      );
    } catch (e) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future<void> cancelNotificaion({required int id}) async {
    await AwesomeNotifications().cancelSchedule(id);
  }
}
