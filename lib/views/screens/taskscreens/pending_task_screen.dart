// lib/views/screens/taskscreens/pending_tasks_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:taskapp/core/theme/app_color.dart';
import 'package:taskapp/data/models/task_model.dart';
import '../../../core/utils/widgets/homewidgets/task_filter_bar.dart';
import '../../../core/utils/widgets/custom_snackbar.dart';
import '../../../viewmodels/task_viewmodel.dart';

class PendingTasksScreen extends StatefulWidget {
  const PendingTasksScreen({Key? key}) : super(key: key);

  @override
  State<PendingTasksScreen> createState() => _PendingTasksScreenState();
}

class _PendingTasksScreenState extends State<PendingTasksScreen> {
  String _searchQuery = '';
  TaskSortBy _selectedSort = TaskSortBy.priority;

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF5D5DA8)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Pending Tasks",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D5DA8),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
              decoration: InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),



          // Tasks List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('tasks')
                  .orderBy('startTime')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var tasks = snapshot.data!.docs
                    .map((e) => TaskModel.fromMap(e.data() as Map<String, dynamic>, e.id))
                    .where((t) => t.status != 'Completed')
                    .toList();

                // Search
                if (_searchQuery.isNotEmpty) {
                  tasks = tasks.where((t) =>
                  t.title.toLowerCase().contains(_searchQuery) ||
                      (t.description?.toLowerCase().contains(_searchQuery) ?? false))
                      .toList();
                }

                // Sort
                tasks.sort((a, b) {
                  switch (_selectedSort) {
                    case TaskSortBy.priority:
                      const order = {'High': 0, 'Medium': 1, 'Low': 2};
                      return order[a.priority]!.compareTo(order[b.priority]!);
                    case TaskSortBy.status:
                      return a.status.compareTo(b.status);
                    case TaskSortBy.category:
                      return a.category.compareTo(b.category);
                    case TaskSortBy.date:
                      return a.startTime.compareTo(b.startTime);
                  }
                });

                if (tasks.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async => Future.delayed(const Duration(seconds: 1)),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return _buildTaskCard(tasks[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Premium Card - No Overflow Ever
  Widget _buildTaskCard(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Priority Circle
          CircleAvatar(
            radius: 26,
            backgroundColor: task.priority == 'High'
                ? Colors.red.shade100
                : task.priority == 'Medium'
                ? Colors.orange.shade100
                : Colors.green.shade100,
            child: Text(
              task.priority[0],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: task.priority == 'High'
                    ? Colors.red.shade700
                    : task.priority == 'Medium'
                    ? Colors.orange.shade700
                    : Colors.green.shade700,
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Main Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  task.title,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // Description
                if (task.description != null && task.description!.trim().isNotEmpty)
                  Text(
                    task.description!,
                    style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                const SizedBox(height: 10),

                // Category & Date
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _infoChip(Icons.category, task.category),
                    _infoChip(Icons.access_time, DateFormat('dd MMM • hh:mm a').format(task.startTime)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: task.status == 'In Progress' ? Colors.orange.shade100 : Colors.blue.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              task.status,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: task.status == 'In Progress' ? Colors.orange.shade800 : Colors.blue.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12.5, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 80, color: Colors.green.shade400),
          const SizedBox(height: 16),
          const Text("All Done!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 10),
          const Text("Great job! You're all caught up", style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}