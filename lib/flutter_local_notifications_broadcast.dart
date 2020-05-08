import 'dart:async';

import 'package:flutter/services.dart';

class FlutterLocalNotificationsBroadcast {
  static const MethodChannel _channel =
      const MethodChannel('flutter_local_notifications_broadcast');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
