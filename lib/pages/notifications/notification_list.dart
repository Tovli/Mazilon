import 'package:flutter/material.dart';
import 'package:mazilon/pages/notifications/notifications_service.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'notification_list_item.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  void _removeNotification(String notification, userInformation) {
    print("this is the notifications");
    print(notification);
    setState(() {
      userInformation.notifications.remove(notification);
      NotificationsHelper.cancelNotification(int.parse(notification));
    });
  }

  @override
  Widget build(BuildContext context) {
    UserInformation userInformation = Provider.of<UserInformation>(context);

    return Column(
        children: userInformation.notifications.map((notification) {
      return NotificationListItem(
        key: ValueKey(notification),
        notification: notification,
        removeNotification: () =>
            _removeNotification(notification, userInformation),
      );
    }).toList());
  }
}
