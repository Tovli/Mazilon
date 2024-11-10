// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mazilon/pages/notifications/notification_service.dart';
import 'package:mazilon/pages/notifications/time_picker.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    NotificationsService.init(); // Initialize NotificationsHelper
  }

  @override
  Widget build(BuildContext context) {
    final appInfoProvider = Provider.of<AppInformation>(context);
    final userInfoProvider = Provider.of<UserInformation>(context);
    var quotes = appInfoProvider
        .homePageInspirationalQuotes['quotes-${userInfoProvider.gender}']!;

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
              color: Colors.blueGrey.withOpacity(0.7),
              borderRadius: BorderRadius.circular(7),
            ),
            child: TextButton(
              onPressed: () => {
                NotificationsService.initializeNotification(
                    quotes, _currentHour, _currentMinute)
              },
              child: Text(
                'קבע תזכורת לזמן שנבחר',
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
