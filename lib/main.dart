import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bettingtipsapp/auth/auth_screen.dart';
import 'package:bettingtipsapp/providers/auth_provider.dart';
import 'package:bettingtipsapp/providers/bottomnavbarprovider.dart';
import 'package:bettingtipsapp/screens/HomeScreen.dart';
import 'package:bettingtipsapp/screens/EditProfile.dart';
import 'package:bettingtipsapp/screens/SubscriptionScreen.dart';
import 'package:bettingtipsapp/screens/TipDetails.dart';
import 'package:bettingtipsapp/screens/TipsScreen.dart';
import 'package:bettingtipsapp/screens/Wrapper.dart';
import 'package:bettingtipsapp/screens/reset_password.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';



@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Got a message whilst in the foreground!');
  if (message.notification != null &&
      message.notification?.android != null) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: message.notification?.title,
            body: message.notification?.body));
  }

  print("Handling a background message: ${message.messageId}");
}




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("token is:$fcmToken");
  await FirebaseMessaging.instance.subscribeToTopic('all');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

Future<void> NotificationRequestPermission()
async {
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationRequestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      if (message.notification != null &&
          message.notification?.android != null) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                title: message.notification?.title,
                body: message.notification?.body));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavBarProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Wrapper.routeName,
        routes: {
          Wrapper.routeName: (context) => Wrapper(),
          HomeScreen.routeName: (context) => HomeScreen(),
          AuthScreen.routeName: (context) => AuthScreen(),
          TipsScreen.routeName: (context) => TipsScreen(),
          SubscriptionScreen.routeName: (context) => SubscriptionScreen(),
          EditProfileScreen.routeName: (context) => EditProfileScreen(),
          TipDetails.routeName: (context) => TipDetails(),
          ResetPasswordScreen.routeName: (context) => ResetPasswordScreen(),
        },
      ),
    );
  }
}
