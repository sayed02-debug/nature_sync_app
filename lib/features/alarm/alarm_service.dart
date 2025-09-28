import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'alarm_model.dart';

class AlarmService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _notifications.initialize(settings);
    await _createChannel();
  }

  static Future<void> _createChannel() async {
    const channel = AndroidNotificationChannel(
      'alarm_channel',
      'Alarm Notifications',
      importance: Importance.high,
    );

    await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  static Future<void> scheduleNotification(Alarm alarm) async {
    const android = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      importance: Importance.high,
    );

    const details = NotificationDetails(android: android);

    await _notifications.show(
      alarm.id.hashCode,
      'Nature Sync Alarm',
      'Alarm for ${alarm.formattedTime}',
      details,
    );
  }

  static Future<void> cancelNotification(Alarm alarm) async {
    await _notifications.cancel(alarm.id.hashCode);
  }

  static Future<void> testNotification() async {
    const android = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      importance: Importance.high,
    );

    const details = NotificationDetails(android: android);

    await _notifications.show(
      999,
      'Test Notification',
      'Nature Sync App is working!',
      details,
    );
  }
}