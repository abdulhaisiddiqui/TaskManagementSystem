// lib/providers/task_provider.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../data/models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  DateTime? _accountCreatedDate;
  List<TaskModel> _allTasks = [];
  bool _isLoading = true;

  DateTime get selectedDate => _selectedDate;
  DateTime? get accountCreatedDate => _accountCreatedDate;
  List<TaskModel> get allTasks => _allTasks;
  bool get isLoading => _isLoading;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Call this once when user logs in
  Future<void> initializeUserData(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Get account creation date
      final userDoc = await _firestore.collection('users').doc(uid).get();
      final Timestamp? createdAt = userDoc.data()?['createdAt'] as Timestamp?;

      _accountCreatedDate = createdAt?.toDate() ?? DateTime.now();

      // 2. Listen to real-time tasks
      _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .orderBy('startTime', descending: false)
          .snapshots()
          .listen((snapshot) {
        _allTasks = snapshot.docs
            .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
            .toList();

        // Auto select today if no task on current selected date
        if (_allTasks.isNotEmpty) {
          final todayTasks = tasksForSelectedDate;
          if (todayTasks.isEmpty && isSameDay(_selectedDate, DateTime.now())) {
            // Stay on today
          }
        }

        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint("Error initializing user data: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  // Available dates from account creation to today
  List<DateTime> get availableDates {
    if (_accountCreatedDate == null) return [];

    final List<DateTime> dates = [];
    DateTime current = _accountCreatedDate!;

    while (!current.isAfter(DateTime.now())) {
      dates.add(DateTime(current.year, current.month, current.day));
      current = current.add(const Duration(days: 1));
    }
    return dates.reversed.toList(); // Today first
  }

  List<TaskModel> get tasksForSelectedDate {
    if (_allTasks.isEmpty) return [];

    return _allTasks.where((task) {
      final taskDate = DateTime(task.startTime.year, task.startTime.month, task.startTime.day);
      return taskDate.year == _selectedDate.year &&
          taskDate.month == _selectedDate.month &&
          taskDate.day == _selectedDate.day;
    }).toList();
  }

  void selectDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    if (_selectedDate != normalized &&
        _accountCreatedDate != null &&
        !normalized.isBefore(_accountCreatedDate!) &&
        !normalized.isAfter(DateTime.now())) {
      _selectedDate = normalized;
      notifyListeners();
    }
  }

  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time).toLowerCase();
  }

  String getTimeRange(TaskModel task) {
    return "${formatTime(task.startTime)} - ${formatTime(task.endTime)}";
  }
}