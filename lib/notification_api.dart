import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mazilon/pages/notifications/notification_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationsService.init();
  print('Handling a background message: ${message.messageId}');
}

class Notification_api {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initn() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final token = await _firebaseMessaging.getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');
      await NotificationsService.init();
      await NotificationsService.showNotification(
          message.data["title"], message.data["body"]);
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    print(token);
    /* try {
    } catch (e) {
      print(e);
    }*/
  }
}
