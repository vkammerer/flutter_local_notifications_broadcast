package com.vincentkammerer.flutter_local_notifications_broadcast;

import android.app.Notification;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import androidx.annotation.NonNull;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import com.dexterous.flutterlocalnotifications.models.NotificationDetails;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.Map;

/**
 * FlutterLocalNotificationsBroadcastPlugin
 */
public class FlutterLocalNotificationsBroadcastPlugin extends FlutterLocalNotificationsPlugin {

  private static final String CHANNEL_NAME = "com.vincentkammerer.flutter_local_notifications_broadcast/plugin_channel";
  private static final String BROADCAST_METHOD = "broadcast";
  private static final String BROADCAST_TARGET = "broadcastTarget";
  private static final String TAG = "FlutterLocalNBCP";
  private static final String INVALID_BROADCAST_TARGET_ERROR_CODE = "INVALID_BROADCAST_TARGET";
  private static final String INVALID_BROADCAST_TARGET_ERROR_MESSAGE = "The specified class name doesn't match any existing class in the project";

  private Context applicationContext;
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    initialize(flutterPluginBinding.getApplicationContext(),
        flutterPluginBinding.getBinaryMessenger());
  }

  public static void registerWith(Registrar registrar) {
    FlutterLocalNotificationsBroadcastPlugin instance = new FlutterLocalNotificationsBroadcastPlugin();
    instance.initialize(registrar.context(), registrar.messenger());
  }

  private void initialize(Context context, BinaryMessenger messenger) {
    this.applicationContext = context;
    this.channel = new MethodChannel(messenger, CHANNEL_NAME);
    this.channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    this.channel = null;
    this.applicationContext = null;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals(BROADCAST_METHOD)) {
      broadcast(call, result);
    } else {
      result.notImplemented();
    }
  }

  private void broadcast(MethodCall call, Result result) {
    Map<String, Object> arguments = call.arguments();
    NotificationDetails notificationDetails = extractNotificationDetails(result, arguments);
    String broadcastTarget = (String) arguments.get(BROADCAST_TARGET);
    if (notificationDetails != null && !hasInvalidTargetClass(result, broadcastTarget)) {
      broadcastNotification(this.applicationContext, notificationDetails, broadcastTarget);
      result.success(null);
    }
  }

  private void broadcastNotification(Context context, NotificationDetails notificationDetails,
      String broadcastTarget) {
    Notification notification = createNotification(context, notificationDetails);
    Class broadcastTargetClass;
    try {
      broadcastTargetClass = Class.forName(broadcastTarget);
    } catch (ClassNotFoundException e) {
      Log.w(TAG, INVALID_BROADCAST_TARGET_ERROR_CODE);
      return;
    }
    Intent intent = new Intent(context, broadcastTargetClass);
    intent.putExtra("notificationId", notificationDetails.id);
    intent.putExtra("notification", notification);
    context.sendBroadcast(intent);
  }

  private boolean hasInvalidTargetClass(Result result, String broadcastTarget) {
    try {
      Class.forName(broadcastTarget);
    } catch (ClassNotFoundException e) {
      result
          .error(INVALID_BROADCAST_TARGET_ERROR_CODE, INVALID_BROADCAST_TARGET_ERROR_MESSAGE, null);
      return true;
    }
    return false;
  }


}
