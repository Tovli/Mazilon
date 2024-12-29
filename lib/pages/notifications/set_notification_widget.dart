// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mazilon/pages/notifications/notification_service.dart';
import 'package:mazilon/pages/notifications/time_picker.dart';
import 'package:mazilon/util/Form/retrieveInformation.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetNotificationWidget extends StatefulWidget {
  const SetNotificationWidget({super.key});

  @override
  State<SetNotificationWidget> createState() => _SetNotificationWidgetState();
}

class _SetNotificationWidgetState extends State<SetNotificationWidget> {
  int _currentHour = 12;
  int _currentMinute = 0;
  void setTime(int minute, int hour) {
    setState(() {
      _currentHour = hour;
      _currentMinute = minute;
    });
  }

  void saveNotificationTime(
      int hour, int minute, UserInformation userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notificationHour', hour);
    await prefs.setInt('notificationMinute', minute);
    userInfo.updateNotificationHour(hour);
    userInfo.updateNotificationMinute(minute);

    setState(() {
      _currentHour = hour;
      _currentMinute = minute;
    });
  }

  void initializeNotification(
      List<String> quotes, UserInformation userInfo, Function createText) {
    NotificationsService.initializeNotification(
        quotes, _currentHour, _currentMinute, createText);
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
    final appLocale = AppLocalizations.of(context);
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
                    appLocale!.notifyOnscheduledNotification)
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
      ],
    );
  }
}
