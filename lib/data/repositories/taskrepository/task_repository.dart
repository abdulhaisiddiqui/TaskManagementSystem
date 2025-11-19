import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/task_model.dart';

class TaskRepository {
  Stream<List<TaskModel>> fetchTasks(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => TaskModel.fromMap(doc.data(), doc.id)).toList());
  }

}
