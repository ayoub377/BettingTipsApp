import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/cupertino.dart';


import 'notification_controller.dart';


class Notifications{

  static Future<void> initializeRemoteNotifications({
    required bool debug
  }) async {
    await Firebase.initializeApp();

    await AwesomeNotificationsFcm().initialize(
        onFcmSilentDataHandle: NotificationController.mySilentDataHandle,
        onFcmTokenHandle: NotificationController.myFcmTokenHandle,
        onNativeTokenHandle: NotificationController.myNativeTokenHandle,
        // This license key is necessary only to remove the watermark for
        // push notifications in release mode. To know more about it, please
        // visit http://awesome-notifications.carda.me#prices
        licenseKeys: null,
        debug: debug);
  }

  static Future<void> initializeNotifications({required bool debug}) async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'basic_channel',
              channelName: 'basic_channel',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
          )
        ],
        debug: true);
  }

  // Request FCM token to Firebase
  static Future<String> getFirebaseMessagingToken() async {
    String firebaseAppToken = '';
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        firebaseAppToken = await AwesomeNotificationsFcm().requestFirebaseAppToken();
      }
      catch (exception){
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }
    return firebaseAppToken;
  }

}