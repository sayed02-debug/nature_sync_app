import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'alarm_model.dart';

class AlarmService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();


  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(initializationSettings);

    await _createNotificationChannel();
  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'alarm_channel',
      'Alarm Notifications',
      description: 'Channel for nature sync alarm notifications',
      importance: Importance.high,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }


  static Future<void> scheduleAlarmNotification(Alarm alarm) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      channelDescription: 'Channel for nature sync alarm notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);


    await _notificationsPlugin.show(
      alarm.id.hashCode,
      '🌿 Nature Sync Alarm',
      'Alarm for ${alarm.formattedTime} is ringing!',
      details,
    );
  }

  static Future<void> cancelAlarmNotification(Alarm alarm) async {
    await _notificationsPlugin.cancel(alarm.id.hashCode);
  }

  // Test notification
  static Future<void> testNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      channelDescription: 'Channel for nature sync alarm notifications',
      importance: Importance.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      999,
      'Nature Sync Test',
      'Test notification from your app!',
      details,
    );
  }
}