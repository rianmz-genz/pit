import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() async {
    // The first step is to create a new instance of the plugin class
    // then initialize it with the settings to use for each platform
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) {
        // if you have a data that is sent with the notification you can access it here
      },
    );
  }

  // this method will create the notification channel when run for the first time
  // you can use this to display notification while the app is in the foreground
  static void displayNotification(RemoteMessage message) async {
    try {
      // truncating division is division where a fractional result is converted to an integer by rounding towards zero
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      // the notification details is the one that is responsible for creating the notification channel
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            'high_importance_channel', // id
            'High Importance Notifications', // title
            channelDescription:
                'This channel is used for important notifications.',
            priority: Priority.high,
            importance: Importance.max,
            visibility: NotificationVisibility.public,
            showWhen: true),
      );
      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    } catch (_) {}
  }
}
