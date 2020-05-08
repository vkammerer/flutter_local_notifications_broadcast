import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/src/helpers.dart';

class FlutterLocalNotificationsBroadcast
    extends AndroidFlutterLocalNotificationsPlugin {
  MethodChannel _channel = MethodChannel(
      "com.vincentkammerer.flutter_local_notifications_broadcast/plugin_channel");

  Future<void> broadcast(
    int id,
    String title,
    String body,
    String broadcastTarget, {
    AndroidNotificationDetails notificationDetails,
    String payload,
  }) {
    validateId(id);
    return _channel.invokeMethod(
      'broadcast',
      <String, dynamic>{
        'id': id,
        'title': title,
        'body': body,
        'payload': payload ?? '',
        'platformSpecifics': notificationDetails?.toMap(),
        'broadcastTarget': broadcastTarget,
      },
    );
  }
}
