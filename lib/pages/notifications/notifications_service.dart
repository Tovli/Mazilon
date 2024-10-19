import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsHelper {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const InitializationSettings _initializationSettings =
      InitializationSettings(
    android: AndroidInitializationSettings(
        '@mipmap/ic_launcher'), // Replace with your actual icon name
    iOS: DarwinInitializationSettings(),
  );

  static Future<void> init() async {
    tz.initializeTimeZones();
    // Get the device's current time zone
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    //  String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();

    // Set the local time zone
    tz.setLocalLocation(tz.getLocation(timeZoneName ?? 'Asia/Jerusalem'));
    await _flutterLocalNotificationsPlugin.initialize(_initializationSettings);
  }

  static Future<void> schedulNotifications(
      TimeOfDay timeOfDay, String id) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate2 = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, timeOfDay.hour, timeOfDay.minute);
    print("scheduled for: ");
    if (scheduledDate2.isBefore(now)) {
      scheduledDate2 = scheduledDate2.add(const Duration(days: 1));
    }
    print(scheduledDate2);

    print("this is the time of day");
    print(scheduledDate2);
    print("this is the id");
    print(int.parse(id));
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        matchDateTimeComponents: DateTimeComponents.time,
        (int.parse(id)), // Use a different ID for each notification if needed
        'מצילון',
        'שלום ממצילון, מה שלומך היום?',
        scheduledDate2,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    /*await _flutterLocalNotificationsPlugin.periodicallyShow(
      (id), // Use a different ID for each notification if needed
      'מצילון',
      'שלום ממצילון, מה שלומך היום?',
      RepeatInterval.everyMinute,

      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id', // Channel ID
          'channel_name', // Channel name
          importance: Importance.max,
          priority: Priority.high,
          enableVibration: true, // Ensure it works even if the device is idle
          playSound: true, // Ensure it works even if the device is idle
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );*/
  }

  // Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
    print('Notification with ID $id cancelled');
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
