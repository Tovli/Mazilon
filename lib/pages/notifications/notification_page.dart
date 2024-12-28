// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:mazilon/pages/notifications/set_notification_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';

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
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);
    final appLocale = AppLocalizations.of(context);
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
                Text(
                  appLocale!.notificationPageHeader(gender),
                ),
                SizedBox(height: 20),
                SetNotificationWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
