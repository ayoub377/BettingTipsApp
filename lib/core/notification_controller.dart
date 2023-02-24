import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/foundation.dart';

class NotificationController{
  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {


    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {

    } else {
      if (kDebugMode) {
        print("FOREGROUND");
      }
    }

    if (kDebugMode) {
      print("starting long task");
    }
    await Future.delayed(const Duration(seconds: 4));
    if (kDebugMode) {
      print("long task done");
    }
  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    debugPrint('FCM Token:"$token"');
  }

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    debugPrint('Native Token:"$token"');
  }
}