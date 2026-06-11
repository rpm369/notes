import 'package:awesome_notifications/awesome_notifications.dart';
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

    if (!(await AwesomeNotifications().isNotificationAllowed()))
      await AwesomeNotifications().requestPermissionToSendNotifications();

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: (action) async {
        await AwesomeNotifications().resetGlobalBadge();
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          '/',
          (route) => route.isFirst,
        );
      },
      onNotificationDisplayedMethod: (notification) async {},
    );
  }

  static Future<bool> isAlreadyScheduled({required int key}) async {
    List<NotificationModel> notificationModels = await AwesomeNotifications()
        .listScheduledNotifications();

    return notificationModels.contains((models) => models.content!.id == key);
  }

  static Future<void> sheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
  }) async {
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
  }

  static Future<void> cancelNotificaion({required int id}) async {
    await AwesomeNotifications().cancelSchedule(id);
  }
}
