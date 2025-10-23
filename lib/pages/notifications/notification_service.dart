import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/util/SignIn/popup_toast.dart';
import 'package:mazilon/util/logger_service.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

class NotificationsService {
  static bool _isInitialized = false;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const InitializationSettings _initializationSettings =
      InitializationSettings(
    android: AndroidInitializationSettings(
        '@mipmap/ic_launcher'), // Replace with your actual icon name
    iOS: DarwinInitializationSettings(),
  );

  static Future<void> init() async {
    if (_isInitialized) {
      // Already initialized, no need to initialize again
      return;
    }

    tz_data.initializeTimeZones();
    // Get the device's current time zone
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      //  String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();

      // Set the local time zone
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      await _flutterLocalNotificationsPlugin
          .initialize(_initializationSettings);
      _isInitialized = true;
    } catch (error, stackTrace) {
      tz.setLocalLocation(tz.getLocation('Asia/Jerusalem'));
      await _flutterLocalNotificationsPlugin
          .initialize(_initializationSettings);
      _isInitialized = true;
      IncidentLoggerService loggerService =
          GetIt.instance<IncidentLoggerService>();
      await loggerService.captureLog(
        error,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> showNotification(String title, String body) async {
    debugPrint("trying to show notification");

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('exampleID', 'ShowExampleChannelTitle',
            channelDescription:
                'This is a channel for the user to show an example notification',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: 'item x');
  }

  static TimeOfDay calculateTime(int h, int m) {
    return TimeOfDay(hour: h, minute: m);
  }

  static initializeNotification(
      List<String> quotes, int hour, int minute, Function createText) async {
    final bool? grantedNotificationPermission;
    if (Platform.isAndroid) {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
    } else {
      grantedNotificationPermission = false;
    }
    if (grantedNotificationPermission != null &&
        grantedNotificationPermission == false) {
      showToast(message: "notifications permission denied");
    }
    TimeOfDay calculatedTime = calculateTime(hour, minute);
    String id = "${calculatedTime.hour}${calculatedTime.minute}";
    await cancelNotifications(null, cancelWorker: true);

    Workmanager().registerPeriodicTask(
      id,
      "simpleTask",
      inputData: {
        "text": quotes,
        "timeHour": hour,
        "timeMinute": minute,
        "id": id
      },
      frequency: Duration(hours: 10),
    );

    var message = createText(
        '${hour < 10 ? "0${hour}" : hour}:${minute < 10 ? "0${minute}" : minute}');
    showToast(message: message);
  }

  static Future<void> scheduleNotification(
      TimeOfDay timeOfDay, String id, String text) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, timeOfDay.hour, timeOfDay.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      matchDateTimeComponents: DateTimeComponents.time,
      (int.parse(id)), // Use a different ID for each notification if needed
      'Living Positively',
      text,
      scheduledDate,
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'LPNotificationServiceID', 'LP Notifications',
              channelDescription:
                  'LP Notifications allows you to receive daily reminders from the Mazilon app to keep track of your mental health')),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  // Cancel a specific notification
  static Future<void> cancelNotifications(int? id,
      {bool cancelWorker = false}) async {
    if (cancelWorker) {
      await Workmanager().cancelAll();
    }
    if (id == null) {
      await _flutterLocalNotificationsPlugin.cancelAll();
    } else {
      await _flutterLocalNotificationsPlugin.cancel(id);
    }
    debugPrint('Notification with ID $id cancelled');
  }

  // Cancel all notifications
}
