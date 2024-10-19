// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mazilon/pages/notifications/notification_list.dart';
import 'package:mazilon/pages/notifications/notifications_service.dart'; // Assuming this now refers to NotificationsHelper
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.title});

  final String title;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _currentHour = 12;
  int _currentMinute = 0;
  TimeOfDay? scheduleTime;
  List<bool> checkedDays = List<bool>.filled(7, false);
  TimeOfDay calculateTime() {
    TimeOfDay time = TimeOfDay(hour: _currentHour, minute: _currentMinute);
    print(time);
    return TimeOfDay(hour: _currentHour, minute: _currentMinute);
  }

  @override
  void initState() {
    super.initState();
    NotificationsHelper.init(); // Initialize NotificationsHelper
  }

  void _scheduleNotifications(UserInformation userInformation) async {
    print(userInformation.age);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var notificationIds = prefs.getStringList('notifications') ?? [];
    print("got in here");
    TimeOfDay calculatedTime = calculateTime();
    var id =
        "${calculatedTime.hour < 10 ? "0${calculatedTime.hour}" : calculatedTime.hour}${calculatedTime.minute < 10 ? "0${calculatedTime.minute}" : calculatedTime.minute}99${DateTime.now().millisecond}";
    notificationIds.add(id);
    prefs.setStringList('notifications', notificationIds);
    //prefs.setStringList('notifications', []);
    userInformation.addNotification(id);
    // userInformation.updateNotifications([]);
    NotificationsHelper.schedulNotifications(calculateTime(), id);
  }

  @override
  Widget build(BuildContext context) {
    UserInformation userInformation = Provider.of<UserInformation>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 100),
                  Text(
                    'הוספת תזכורות לשימוש במצילון',
                  ),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.black,
                    height: 5, // Adjust the height as needed
                  ),
                  SizedBox(width: 15),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NumberPicker(
                          zeroPad: true,
                          infiniteLoop: true,
                          selectedTextStyle: TextStyle(fontSize: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black26),
                          ),
                          minValue: 0,
                          maxValue: 59,
                          value: _currentMinute,
                          onChanged: (value) =>
                              setState(() => _currentMinute = value),
                        ),
                        NumberPicker(
                          zeroPad: true,
                          infiniteLoop: true,
                          selectedTextStyle: TextStyle(fontSize: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black26),
                          ),
                          minValue: 0,
                          maxValue: 23,
                          value: _currentHour,
                          onChanged: (value) =>
                              setState(() => _currentHour = value),
                        ),
                      ]),
                  Center(
                    child: Column(
                      children: [
                        Divider(
                          color: Colors.black,
                          height: 5, // Adjust the height as needed
                        ),
                        SizedBox(height: 20),

                        const SizedBox(height: 5),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: TextButton(
                            onPressed: () =>
                                {_scheduleNotifications(userInformation)},
                            child: Text(
                              'קבע תזכורת לזמן שנבחר',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ImmediateNotificationButton(),
                        // const SizedBox(height: 20),
                        NotificationList()
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
