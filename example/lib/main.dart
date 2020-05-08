import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_broadcast/flutter_local_notifications_broadcast.dart';

final FlutterLocalNotificationsBroadcast flutterLocalNotificationsBroadcast =
    FlutterLocalNotificationsBroadcast();

NotificationAppLaunchDetails notificationAppLaunchDetails;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails = await flutterLocalNotificationsBroadcast
      .getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  await flutterLocalNotificationsBroadcast.initialize(
    initializationSettingsAndroid,
    onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
    },
  );
  runApp(MaterialApp(home: HomePage()));
}

class PaddedRaisedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const PaddedRaisedButton({
    @required this.buttonText,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      child: RaisedButton(child: Text(buttonText), onPressed: onPressed),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app'),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                PaddedRaisedButton(
                  buttonText: 'Show plain notification with payload',
                  onPressed: () async {
                    await _broadcastNotification();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _broadcastNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    await flutterLocalNotificationsBroadcast.broadcast(
        1,
        'plain title',
        'plain body',
        'com.vincentkammerer.flutter_local_notifications_broadcast_example.ForegroundServiceBroadcastReceiver',
        notificationDetails: androidPlatformChannelSpecifics,
        payload: 'item x');
  }
}
