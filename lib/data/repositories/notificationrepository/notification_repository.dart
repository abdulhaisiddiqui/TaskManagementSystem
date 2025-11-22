import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../main.dart';
import '../../models/app_notification_model.dart';
import '../../models/task_model.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationRepository extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _localNotifications =
      flutterLocalNotificationsPlugin;

  NotificationRepository() {
    initLocalNotifications();
  }

  /// Initialize local notifications & timezone
  Future<void> initLocalNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification tapped: ${response.payload}');
      },
    );
  }

  // ------------------ Welcome Notification ------------------
  Future<void> showWelcomeNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'welcome_channel_id',
      'Welcome Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,
      'Welcome!',
      'We’re happy to have you on board.',
      details,
    );
  }

  // ------------------ Show Local Notification ------------------
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // Prevent scheduling in the past
    final schedule = scheduledTime.isAfter(DateTime.now())
        ? scheduledTime
        : DateTime.now().add(const Duration(seconds: 5));

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'task_channel',
        'Task Notifications',
        channelDescription: 'Reminders and alerts for tasks',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(schedule, tz.local), // timezone-safe
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // REMOVE old uiLocalNotificationDateInterpretation
      // REMOVE old matchDateTimeComponents
    );
  }

  // ------------------ Save Notification to Firebase ------------------
  Future<void> saveNotificationToFirebase(AppNotification notification) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .doc(notification.id);

    await docRef.set(notification.toMap());
  }

  // ------------------ Stream Notifications ------------------
  Stream<List<AppNotification>> getNotifications() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('scheduledTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => AppNotification.fromMap(doc.data(), doc.id))
        .toList());
  }

  // ------------------ Schedule Task Reminder ------------------
  Future<void> scheduleTaskReminder(TaskModel task) async {
    final reminderTime = task.endTime.subtract(const Duration(hours: 1));
    final notification = AppNotification(
      id: task.id.hashCode.toString(),
      type: "Task Reminder",
      title: "Task Reminder",
      body: 'Your task "${task.title}" is due in 1 hour',
      scheduledTime: reminderTime.isAfter(DateTime.now())
          ? reminderTime
          : DateTime.now().add(const Duration(seconds: 5)),
    );

    await showNotification(
      id: int.parse(notification.id),
      title: notification.title,
      body: notification.body,
      scheduledTime: notification.scheduledTime,
    );

    await saveNotificationToFirebase(notification);
  }

  // ------------------ Schedule Overdue Alert ------------------
  Future<void> scheduleOverdueAlert(TaskModel task) async {
    final scheduledTime =
    task.endTime.isAfter(DateTime.now()) ? task.endTime : DateTime.now();

    final notification = AppNotification(
      id: (task.id.hashCode + 1).toString(),
      type: "Overdue Alert",
      title: "Task Overdue!",
      body: 'Your task "${task.title}" is now overdue!',
      scheduledTime: scheduledTime,
    );

    // Local notification
    await showNotification(
      id: int.parse(notification.id),
      title: notification.title,
      body: notification.body,
      scheduledTime: notification.scheduledTime,
    );

    // Save to Firestore
    await saveNotificationToFirebase(notification);

    // Subscribe user to "overdue_tasks" topic
    await FirebaseMessaging.instance.subscribeToTopic("overdue_tasks");
  }


  // ------------------ Schedule Completion Celebration ------------------
  Future<void> scheduleCompletionCelebration(TaskModel task) async {
    final notification = AppNotification(
      id: (task.id.hashCode + 2).toString(),
      type: "Completion Celebration",
      title: "Task Completed!",
      body: 'Congratulations on completing "${task.title}" 🎉',
      scheduledTime: DateTime.now(),
    );

    await showNotification(
      id: int.parse(notification.id),
      title: notification.title,
      body: notification.body,
      scheduledTime: notification.scheduledTime,
    );

    await saveNotificationToFirebase(notification);
  }

  // ------------------ Schedule Daily Summary ------------------
  Future<void> scheduleDailySummary(DateTime scheduledTime) async {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: "Daily Summary",
      title: "Today's Tasks",
      body: "Check your tasks for today!",
      scheduledTime:
      scheduledTime.isAfter(DateTime.now()) ? scheduledTime : DateTime.now(),
    );

    await showNotification(
      id: int.parse(notification.id),
      title: notification.title,
      body: notification.body,
      scheduledTime: notification.scheduledTime,
    );

    await saveNotificationToFirebase(notification);
  }

  // ------------------ Firebase Messaging Listener ------------------
  void setupFirebaseMessagingListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel',
              'Default Notifications',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });
  }
}
