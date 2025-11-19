// lib/viewmodels/task_viewmodel.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../data/models/task_model.dart';
import '../data/repositories/taskrepository/task_repository.dart';
import '../data/repositories/notificationrepository/notification_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repo = TaskRepository();
  final NotificationRepository _notificationRepo = NotificationRepository();

  TaskModel _task = TaskModel(
    userId: FirebaseAuth.instance.currentUser?.uid ?? '',
    title: '',
    startTime: DateTime.now(),
    endTime: DateTime.now().add(const Duration(hours: 1)),
  );

  TaskModel get task => _task;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TaskViewModel() {
    tz.initializeTimeZones(); // Initialize timezone once
  }

  // ------------------ Task Operations ------------------
  Stream<List<TaskModel>> getTasks() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _repo.fetchTasks(uid);
  }

  void updateTitle(String title) {
    _task = _task.copyWith(title: title);
    notifyListeners();
  }

  void updateDescription(String? desc) {
    _task = _task.copyWith(description: desc);
    notifyListeners();
  }

  void updateStartTime(DateTime time) {
    _task = _task.copyWith(startTime: time);
    notifyListeners();
  }

  void updateEndTime(DateTime time) {
    _task = _task.copyWith(endTime: time);
    notifyListeners();
  }

  void updatePriority(String priority) {
    _task = _task.copyWith(priority: priority);
    notifyListeners();
  }

  void updateCategory(String category) {
    _task = _task.copyWith(category: category);
    notifyListeners();
  }

  void updateStatus(String status) {
    _task = _task.copyWith(status: status);
    notifyListeners();

    // Schedule completion celebration if marked complete
    if (status == "Completed") {
      _notificationRepo.scheduleCompletionCelebration(_task);
    }
  }

  void initializeTask(TaskModel? task) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    _task = task?.copyWith(userId: uid) ??
        TaskModel(userId: uid, title: '', startTime: DateTime.now(), endTime: DateTime.now());
    notifyListeners();
  }

  bool get isValid => _task.title.trim().isNotEmpty && _task.startTime.isBefore(_task.endTime);

  // ------------------ Save Task + Schedule Notifications ------------------
  Future<bool> saveTask() async {
    if (!isValid) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final taskRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks');

      Map<String, dynamic> data = _task.toMap();
      data['startTime'] = Timestamp.fromDate(_task.startTime);
      data['endTime'] = Timestamp.fromDate(_task.endTime);

      if (_task.id == null) {
        final doc = await taskRef.add(data);
        _task = _task.copyWith(id: doc.id);
      } else {
        await taskRef.doc(_task.id).update(data);
      }

      // Schedule task reminder & overdue alert
      await _notificationRepo.scheduleTaskReminder(_task);
      await _notificationRepo.scheduleOverdueAlert(_task);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("Error saving task: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
