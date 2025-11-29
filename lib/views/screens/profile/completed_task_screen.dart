// lib/views/screens/profile/completed_tasks_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskapp/core/theme/theme.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        title: const Text("Completed Tasks"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('tasks')
            .where('status', isEqualTo: 'Completed')
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.celebration, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No completed tasks yet!",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text("Start completing tasks to see them here "),
                ],
              ),
            );
          }

          final completedTasks = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              final taskData = completedTasks[index].data() as Map<String, dynamic>;
              final title = taskData['title'] ?? 'No Title';
              final endTime = (taskData['endTime'] as Timestamp).toDate();
              final category = taskData['category'] ?? 'Other';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getCategoryColor(category).withOpacity(0.2),
                    child: Icon(_getCategoryIcon(category), color: _getCategoryColor(category)),
                  ),
                  title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text("Completed on ${DateFormat('dd MMM yyyy • hh:mm a').format(endTime)}"),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Personal': return Colors.purple;
      case 'Work': return Colors.blue;
      case 'Study': return Colors.orange;
      default: return Colors.green;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Personal': return Icons.person;
      case 'Work': return Icons.work;
      case 'Study': return Icons.school;
      default: return Icons.category;
    }
  }
}