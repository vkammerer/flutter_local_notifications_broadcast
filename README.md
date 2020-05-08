# flutter_local_notifications_broadcast

A Flutter plugin that adds Intent broadcast capability to flutter_local_notifications.   

For general usage of flutter_local_notifications, please see the [main plugin's repository](https://github.com/MaikuB/flutter_local_notifications/tree/master/flutter_local_notifications).

## Usage
#### In your Android project   
Create a [BroadcastReceiver](https://developer.android.com/reference/android/content/BroadcastReceiver) 
#### In your Flutter application   
Pass the class name to the `broadcast` method as in the example below:
```dart
String androidBroadcastReceiverClassName = "com.vincentkammerer.flutter_local_notifications_broadcast_example.ForegroundServiceBroadcastReceiver";

Future<void> _broadcastNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  await flutterLocalNotificationsBroadcast.broadcast(
    1,
    'plain title',
    'plain body',
    androidBroadcastReceiverClassName,
    notificationDetails: androidPlatformChannelSpecifics,
    payload: 'item x',
  );
}
```