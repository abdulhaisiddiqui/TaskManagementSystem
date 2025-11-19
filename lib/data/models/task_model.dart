import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? id;
  final String userId;
  final String title;
  final String? description;

  final DateTime startTime;
  final DateTime endTime;

  final String priority;
  final String category;
  final String status;

  TaskModel({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.priority = 'Medium',
    this.category = 'Personal',
    this.status = 'To Do',
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'priority': priority,
      'category': category,
      'status': status,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String id) {
    return TaskModel(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      priority: map['priority'] ?? 'Medium',
      category: map['category'] ?? 'Personal',
      status: map['status'] ?? 'To Do',
    );
  }

  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? priority,
    String? category,
    String? status,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      status: status ?? this.status,
    );
  }
}
