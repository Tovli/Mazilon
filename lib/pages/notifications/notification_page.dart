// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:mazilon/l10n/app_localizations.dart';
import 'package:mazilon/pages/notifications/notification_service.dart';

import 'package:mazilon/pages/notifications/notification_toggle_card.dart';
import 'package:mazilon/util/Form/retrieveInformation.dart';
import 'package:mazilon/util/LP_extended_state.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends LPExtendedState<NotificationPage> {
  @override
  void initState() {
    NotificationsService.init();
    super.initState();
  }

  void _onToggle(bool value, UserInformation userInfo) {
    if (!value) {
      NotificationsService.cancelNotifications(100);
    }
    if (value) {
      userInfo.updateNotificationHour(8);
      userInfo.updateNotificationMinute(30);
    } else {
      NotificationsService.cancelNotifications(100);
      userInfo.updateNotificationHour(-1);
      userInfo.updateNotificationMinute(-1);
    }
  }

  void _onPickedTime(
    TimeOfDay picked,
    AppLocalizations appLocale,
    UserInformation userInfo,
  ) async {
    try {
      final random = Random();
      final allQuotes = retrieveInspirationalQuotes(appLocale, userInfo.gender);
      final twentyQuotes =
          List.generate(20, (_) => allQuotes[random.nextInt(allQuotes.length)]);
      userInfo.updateNotificationHour(picked.hour);
      userInfo.updateNotificationMinute(picked.minute);
      await NotificationsService.cancelNotifications(100);
      await NotificationsService.debugScheduleBatchNotifications(
          picked, twentyQuotes);
      debugPrint(
          "Scheduled notifications at ${picked.format(context)} with 20 quotes");
    } catch (e) {
      debugPrint("Error scheduling notifications: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);

    final gender = userInfoProvider.gender;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 100),
                Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                            text: 'Remind ',
                            style: TextStyle(color: primaryPurple)),
                        TextSpan(text: 'Me', style: TextStyle(color: appGreen)),
                      ],
                    ),
                  ),
                ),
                NotificationToggleCard(
                  emoji: "✨",
                  badgeText: "LP",
                  title: "מסר חיזוק יומי",
                  subtitle: "ניצוץ יומי עדין של תקווה ונחמה, להאיר את הדרך",
                  initialEnabled: userInfoProvider.notificationHour != -1,
                  initialTime: userInfoProvider.notificationHour == -1
                      ? null
                      : TimeOfDay(
                          hour: userInfoProvider.notificationHour,
                          minute: userInfoProvider.notificationMinute,
                        ),
                  onTimeSelected: (time) =>
                      _onPickedTime(time, appLocale, userInfoProvider),
                  onToggle: (value) => _onToggle(value, userInfoProvider),
                ),
                Text(
                  appLocale!.notificationPageHeader(gender),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
