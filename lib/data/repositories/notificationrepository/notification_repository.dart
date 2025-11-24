// lib/data/repositories/notificationrepository/notification_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskapp/main.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../models/app_notification_model.dart';
import '../../models/task_model.dart';

class NotificationRepository {
  final FlutterLocalNotificationsPlugin _plugin = flutterLocalNotificationsPlugin;

  // Welcome Notification (Login ke baad)
  Future<void> showWelcomeNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'welcome_channel_id',
      'Welcome',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(0, 'Welcome!', 'We’re happy to have you on board.', details);
  }

  // Main Schedule Function
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String type, // reminder, overdue, daily_summary, completion
    String? taskId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final DateTime finalTime = scheduledTime.isBefore(DateTime.now().add(Duration(seconds: 5)))
        ? DateTime.now().add(Duration(seconds: 10))
        : scheduledTime;

    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Reminders',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const details = NotificationDetails(android: androidDetails);

    final int id = DateTime.now().millisecondsSinceEpoch % 1000000;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(finalTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    // Save to Firebase
    final notification = AppNotification(
      id: '${type}_$id',
      type: type,
      title: title,
      body: body,
      scheduledTime: finalTime,
      taskId: taskId,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .doc('${type}_$id')
        .set(notification.toMap());
  }

  // 1. Task Reminder (1 hour before)
  Future<void> scheduleTaskReminder(TaskModel task) async {
    final reminderTime = task.endTime.subtract(const Duration(hours: 1));
    if (reminderTime.isBefore(DateTime.now())) return;

    await scheduleNotification(
      title: "Task Reminder",
      body: 'Your task "${task.title}" is due in 1 hour',
      scheduledTime: reminderTime,
      type: "reminder",
      taskId: task.id,
    );
  }

  // 2. Overdue Alert
  Future<void> scheduleOverdueAlert(TaskModel task) async {
    if (task.endTime.isAfter(DateTime.now())) return;

    await scheduleNotification(
      title: "Task Overdue!",
      body: ' task "${task.title}" is now overdue!',
      scheduledTime: DateTime.now().add(Duration(seconds: 5)),
      type: "overdue",
      taskId: task.id,
    );
  }

  // 3. Completion Celebration
  Future<void> scheduleCompletionCelebration(TaskModel task) async {
    await scheduleNotification(
      title: "Task Completed!",
      body: 'Great job completing "${task.title}"',
      scheduledTime: DateTime.now().add(Duration(seconds: 3)),
      type: "completion",
      taskId: task.id,
    );
  }

  // 4. Daily Summary (Every day 9 AM)
  Future<void> scheduleDailySummary() async {
    final tomorrow9AM = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day + 1,
      9,
      0,
    );

    await scheduleNotification(
      title: "Good Morning!",
      body: "You have tasks waiting for today!",
      scheduledTime: tomorrow9AM,
      type: "daily_summary",
    );
  }

  // Get All Notifications (for Notification Screen)
  Stream<List<AppNotification>> getNotifications() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value([]);

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

  // FCM Listener Setup (Call in main or login)
  void setupFirebaseMessagingListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        _plugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'task_channel',
              'Task Reminders',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );
      }
    });
  }
}