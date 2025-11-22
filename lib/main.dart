import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/viewmodels/auth_viewmodel.dart';
import 'package:taskapp/viewmodels/notification_viewmodel.dart';
import 'package:taskapp/viewmodels/profile_viewmodel.dart';
import 'package:taskapp/viewmodels/task_viewmodel.dart';
import 'package:taskapp/views/screens/bottomnav/bottomnav_screen.dart';
import 'package:taskapp/views/screens/loginsignup/login_screen.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest_all.dart' as tz;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background FCM: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Init
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Timezone Init
  tz.initializeTimeZones();

  // Local Notifications Init
  const AndroidInitializationSettings androidInit =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
  InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (response) {
      print('Notification tapped: ${response.payload}');
    },
  );


  await _createNotificationChannels();

  // Request Permissions
  await _requestPermissions();

  // FCM Setup
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(alert: true, badge: true, sound: true);
  String? token = await messaging.getToken();
  print('FCM Token: $token');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  FirebaseMessaging.onMessage.listen((RemoteMessage message) {

    flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'fcm_channel',
          'General',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _createNotificationChannels() async {
  final androidPlugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  const AndroidNotificationChannel taskChannel = AndroidNotificationChannel(
    'task_channel',
    'Task Reminders',
    description: 'Notifications for task reminders and overdue alerts',
    importance: Importance.max,
    playSound: true,
  );

  const AndroidNotificationChannel welcomeChannel = AndroidNotificationChannel(
    'welcome_channel_id',
    'Welcome Notifications',
    importance: Importance.high,
  );

  await androidPlugin?.createNotificationChannel(taskChannel);
  await androidPlugin?.createNotificationChannel(welcomeChannel);
}


Future<void> _requestPermissions() async {

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }


  final androidImpl = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  if (androidImpl != null && !(await androidImpl.areNotificationsEnabled() ?? true)) {
    await androidImpl.requestNotificationsPermission();
  }


  if (!(await androidImpl?.canScheduleExactNotifications() ?? true)) {
    await androidImpl?.requestExactAlarmsPermission();
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const BottomNavScreen(),
    );
  }
}


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const BottomNavScreen(); // Logged in
        } else {
          return const LoginScreen(); // Not logged in
        }
      },
    );
  }
}
