import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static _notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id 13',
          'channel Name',
          'channel description',
          importance: Importance.max,
        ),
        iOS: IOSNotificationDetails());
  }

  static Future init({bool scheduled = false}) async {
    var initAndroidSetting =
        AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    final settings =
        InitializationSettings(android: initAndroidSetting, iOS: ios);
    await _notifications.initialize(settings);
  }

  static final _notifications = FlutterLocalNotificationsPlugin();
  static Future showScheduledNotification({
    int id = 0,
    String title,
    String body,
    String payload,
    DateTime scheduledDate,
  }) async {
    _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        await _notificationDetails(),
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  static Future showNotification({
    int id = 0,
    String title,
    String body,
    String payload,
  }) async {
    _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
    );
  }
}
