// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/global_enums.dart';
import 'package:mazilon/l10n/app_localizations.dart';
import 'package:mazilon/pages/notifications/notification_service.dart';
import 'package:mazilon/pages/notifications/time_picker.dart';
import 'package:mazilon/util/Form/retrieveInformation.dart';
import 'package:mazilon/util/LP_extended_state.dart';

import 'package:mazilon/util/persistent_memory_service.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetNotificationWidget extends StatefulWidget {
  const SetNotificationWidget({super.key});

  @override
  State<SetNotificationWidget> createState() => _SetNotificationWidgetState();
}

class _SetNotificationWidgetState
    extends LPExtendedState<SetNotificationWidget> {
  int _currentHour = 12;
  int _currentMinute = 0;
  Map<String, String> _debugInfo = {};

  void setTime(int minute, int hour) {
    setState(() {
      _currentHour = hour;
      _currentMinute = minute;
    });
  }

  Future<void> _loadDebugInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _debugInfo = {
        'run_count': prefs.getInt('wm_run_count')?.toString() ?? 'never',
        'last_attempt': prefs.getString('wm_last_attempt') ?? 'never',
        'last_task': prefs.getString('wm_last_task_name') ?? 'n/a',
        'dotenv_ok': prefs.getString('wm_dotenv_ok') ?? 'never',
        'init_ok': prefs.getString('wm_init_ok') ?? 'never',
        'schedule_ok': prefs.getString('wm_schedule_ok') ?? 'never',
        'scheduled_text': prefs.getString('wm_scheduled_text') ?? 'n/a',
        'last_error': prefs.getString('wm_last_error') ?? 'none',
      };
    });
  }

  void saveNotificationTime(
      int hour, int minute, UserInformation userInfo) async {
    userInfo.updateNotificationHour(hour);
    userInfo.updateNotificationMinute(minute);
    setState(() {
      _currentHour = hour;
      _currentMinute = minute;
    });
  }

  void initializeNotification(List<String> quotes, UserInformation userInfo,
      Function createText, AppLocalizations appLocale) {
    NotificationsService.initializeNotification(
        quotes, _currentHour, _currentMinute, createText, appLocale);
    saveNotificationTime(_currentHour, _currentMinute, userInfo);
  }

  @override
  void initState() {
    super.initState();
    NotificationsService.init(); // Initialize NotificationsHelper
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var userInfo = context.read<UserInformation>();
      setState(() {
        _currentHour = userInfo.notificationHour;
        _currentMinute = userInfo.notificationMinute;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider = Provider.of<UserInformation>(context);

    var gender = userInfoProvider.gender;

    final quotes = retrieveInspirationalQuotes(appLocale, gender);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(
          color: Colors.black,
          height: 5, // Adjust the height as needed
        ),
        TimePicker(
          setTime: setTime,
          currentHour: _currentHour,
          currentMinute: _currentMinute,
        ),
        SizedBox(width: 15),
        Divider(
          color: Colors.black,
          height: 5, // Adjust the height as needed
        ),
        SizedBox(height: 25),
        Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 96, 139, 103).withOpacity(0.7),
              borderRadius: BorderRadius.circular(7),
            ),
            child: TextButton(
              onPressed: () => {
                initializeNotification(quotes, userInfoProvider,
                    appLocale!.notifyOnscheduledNotification, appLocale)
              },
              child: Text(
                appLocale!.notificationSetTimeText(gender),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(height: 25),
        Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 138, 139, 96).withOpacity(0.7),
              borderRadius: BorderRadius.circular(7),
            ),
            child: TextButton(
              onPressed: () => {
                NotificationsService.showNotification('Living Positively',
                    quotes[Random().nextInt(quotes.length)]),
              },
              child: Text(
                appLocale!.notificationShowExampleNotification(gender),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(height: 25),
        Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 139, 96, 96).withOpacity(0.7),
              borderRadius: BorderRadius.circular(7),
            ),
            child: TextButton(
              onPressed: () => {
                NotificationsService.cancelNotifications(null,
                    cancelWorker: true)
              },
              child: Text(
                appLocale!.notificationCancelNotification(gender),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
        Divider(color: Colors.grey),
        SizedBox(height: 10),
        Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.7),
              borderRadius: BorderRadius.circular(7),
            ),
            child: TextButton(
              onPressed: _loadDebugInfo,
              child: Text(
                'DEBUG: Load WorkManager Status',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        if (_debugInfo.isNotEmpty) ...[
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Colors.grey),
            ),
            child: SelectableText(
              _debugInfo.entries
                  .map((e) => '${e.key}: ${e.value}')
                  .join('\n'),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
