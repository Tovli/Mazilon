import 'package:flutter/material.dart';

class NotificationListItem extends StatelessWidget {
  final String notification;
  final VoidCallback removeNotification;

  const NotificationListItem(
      {super.key,
      required this.notification,
      required this.removeNotification});

  Widget createNameForNotification() {
    return Text(
      "${notification.substring(0, 2)}:${notification.substring(2, 4)}",
      textAlign: TextAlign.left,
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        trailing: const Icon(Icons.notifications, color: Colors.blue),
        leading: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: removeNotification,
        ),
        title: Directionality(
          textDirection: TextDirection.ltr,
          child: createNameForNotification(),
        ),
      ),
    );
  }
}
