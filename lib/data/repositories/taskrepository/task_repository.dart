// lib/data/repositories/taskrepository/task_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch tasks
  Stream<List<TaskModel>> fetchTasks(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Add new task + update stats
  Future<String> addTask(String uid, TaskModel task) async {
    await _firestore.runTransaction((transaction) async {
      final userRef = _firestore.collection('users').doc(uid);
      final tasksRef = userRef.collection('tasks').doc();

      // 1. Add task
      transaction.set(tasksRef, task.toMap());

      // 2. Update stats
      transaction.update(userRef, {
        'stats.totalTasks': FieldValue.increment(1),
        'stats.pendingTasks': FieldValue.increment(1),
      });
    });

    return "Task added";
  }

  // task_repository.dart mein
  Future<void> updateTask(String uid, TaskModel task, {required bool oldCompletionStatus}) async {
    await _firestore.runTransaction((transaction) async {
      final taskRef = _firestore.collection('users').doc(uid).collection('tasks').doc(task.id);
      final userRef = _firestore.collection('users').doc(uid);

      final bool isNowCompleted = task.status == 'Completed';

      transaction.update(taskRef, task.toMap());

      if (oldCompletionStatus != isNowCompleted) {
        final increment = isNowCompleted ? 1 : -1;
        transaction.update(userRef, {
          'stats.completedTasks': FieldValue.increment(increment),
          'stats.pendingTasks': FieldValue.increment(-increment),
        });
      }
    });
  }



}