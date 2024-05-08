import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  var rng = Random();
  // static final _notificationsLaunch =
  //     FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
  static final onNotifications = BehaviorSubject<String?>();
  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          channelDescription:
              'This channel is used for important notifications.',
          priority: Priority.high,
          importance: Importance.max,
          visibility: NotificationVisibility.public,
          showWhen: true),
      iOS: IOSNotificationDetails(),
    );
  }

  Future<bool> drainStream(String from) async {
    print("drain Stream was clear");
    print(from);
    if (onNotifications.hasValue) {
      onNotifications.value = null;
      print(onNotifications.value);
      return true;
    } else if (!onNotifications.hasValue) {
      return true;
    }

    return false;
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(settings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload);
    });
  }

  Future selectNotification(String payload) async {}

  static Future showNotification(
          {int id = 1,
          String? title,
          String? body,
          String? payload,
          dynamic data}) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload ?? "");
}
