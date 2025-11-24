// lib/data/models/app_notification_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id;
  final String type;           // reminder, overdue, daily_summary, completion
  final String title;
  final String body;
  final DateTime scheduledTime;
  final String? taskId;        // ← YE FIELD ADD KAR DO (nullable)

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.scheduledTime,
    this.taskId,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map, String docId) {
    return AppNotification(
      id: docId,
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      scheduledTime: (map['scheduledTime'] as Timestamp).toDate(),
      taskId: map['taskId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'title': title,
      'body': body,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'taskId': taskId,                 // ← YE ADD KAR DO
    };
  }
}