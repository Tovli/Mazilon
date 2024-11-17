// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:mazilon/pages/notifications/set_notification_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  SetNotificationWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
