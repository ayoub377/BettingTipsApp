import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bettingtipsapp/auth/auth_screen.dart';
import 'package:bettingtipsapp/providers/auth_provider.dart';
import 'package:bettingtipsapp/screens/home_screen.dart';
import 'package:bettingtipsapp/screens/edit_profile_screen.dart';
import 'package:bettingtipsapp/screens/tips_details_screen.dart';
import 'package:bettingtipsapp/screens/tips_list_screen.dart';
import 'package:bettingtipsapp/screens/wrapper.dart';
import 'package:bettingtipsapp/screens/reset_password_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'core/notifications.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';


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
            icon: "assets/images/logo.png",
            channelKey: 'basic_channel',
            title: message.notification?.title,
            body: message.notification?.body));
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

Future<void> notificationRequestPermission() async {}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    notificationRequestPermission();
     Notifications.initializeNotifications(debug: true);
     FirebaseMessaging.instance.getInitialMessage();
     FirebaseMessaging.instance.subscribeToTopic('all');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      if (message.notification != null &&
          message.notification?.android != null) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                icon: "assets/images/logo.png",
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
        StreamProvider<InternetConnectionStatus>(create: (_) {
          return InternetConnectionChecker().onStatusChange;
        }
        , initialData: InternetConnectionStatus.connected)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: MainScreen.routeName,
        routes: {
          MainScreen.routeName: (context) => const MainScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          AuthScreen.routeName: (context) => const AuthScreen(),
          TipsScreen.routeName: (context) => const TipsScreen(),
          EditProfileScreen.routeName: (context) => const EditProfileScreen(),
          TipDetails.routeName: (context) => const TipDetails(),
          ResetPasswordScreen.routeName: (context) => const ResetPasswordScreen(),
          RegisterScreen.routeName:(context)=> const RegisterScreen(),
          LoginScreen.routeName:(context)=> const LoginScreen()
        },
        builder:EasyLoading.init(),
      ),
    );
  }
}
