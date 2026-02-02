import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/l10n/app_localizations.dart';
import 'package:mazilon/util/Form/retrieveInformation.dart';
import 'package:mazilon/util/SignIn/popup_toast.dart';
import 'package:mazilon/util/logger_service.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'package:mazilon/l10n/app_localizations.dart';

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
      final TimezoneInfo timeZoneName =
          await FlutterTimezone.getLocalTimezone();
      //  String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();

      // Set the local time zone

      tz.setLocalLocation(
          tz.getLocation(timeZoneName.identifier ?? "Asia/Jerusalem"));
      await _flutterLocalNotificationsPlugin
          .initialize(_initializationSettings);
      _isInitialized = true;
    } catch (error, stackTrace) {
      tz.setLocalLocation(tz.getLocation('Asia/Jerusalem'));
      await _flutterLocalNotificationsPlugin
          .initialize(_initializationSettings);
      _isInitialized = true;
      try {
        IncidentLoggerService loggerService =
            GetIt.instance<IncidentLoggerService>();
        await loggerService.captureLog(
          error,
          stackTrace: stackTrace,
        );
      } catch (e) {
        debugPrint("Failed to log the error: $e");
      }
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

  static Future<void> initializeNotification(List<String> quotes, int hour,
      int minute, Function createText, AppLocalizations appLocale) async {
    if (!kIsWeb) {
      final bool? grantedNotificationPermission;
      if (Platform.isAndroid) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>();

        grantedNotificationPermission =
            await androidImplementation?.requestNotificationsPermission();
      } else {
        grantedNotificationPermission = false;
      }
      if (grantedNotificationPermission != null &&
          grantedNotificationPermission == false) {
        showToast(message: appLocale.noPermissionAllowedText);
        //if there are no permissions granted, or no permissions, the rest of the function should not run
        return;
      }
      TimeOfDay calculatedTime = calculateTime(hour, minute);
      String id = "${calculatedTime.hour}${calculatedTime.minute}";

      await cancelNotifications(null, cancelWorker: true);
      Workmanager().registerOneOffTask(
        id,
        "NotificationWorker${calculatedTime.hour}${calculatedTime.minute}",
        inputData: {
          "text": quotes,
          "timeHour": hour,
          "timeMinute": minute,
          "id": id
        },
      );
      Workmanager().registerPeriodicTask(
        id,
        "NotificationWorker${calculatedTime.hour}${calculatedTime.minute}Periodic",
        inputData: {
          "text": quotes,
          "timeHour": hour,
          "timeMinute": minute,
          "id": id
        },
        frequency: Duration(days: 1),
      );

      // Only use Workmanager on mobile platforms (not web)
    } else {
      // For web, we can show an immediate notification or handle differently
      // Since workmanager doesn't work on web, we could implement alternative logic here
      debugPrint(
          "Workmanager not supported on web - notifications scheduled for mobile only");
    }

    var message = createText(
        '${hour < 10 ? "0$hour" : hour}:${minute < 10 ? "0$minute" : minute}');
    showToast(message: message);
  }

  static Future<void> updateNotification(
      UserInformation userInfo, AppLocalizations appLocale) async {
    var hour = userInfo.notificationHour;
    var minute = userInfo.notificationMinute;
    var newQuotes = retrieveInspirationalQuotes(appLocale, userInfo.gender);
    initializeNotification(newQuotes, hour, minute,
        appLocale.notifyOnscheduledNotification, appLocale);
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
    if (cancelWorker && !kIsWeb) {
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
