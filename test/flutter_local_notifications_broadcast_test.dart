import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications_broadcast/flutter_local_notifications_broadcast.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_local_notifications_broadcast');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterLocalNotificationsBroadcast.platformVersion, '42');
  });
}
