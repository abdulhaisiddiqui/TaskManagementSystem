// lib/views/screens/task_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/core/theme/app_color.dart';
import 'package:taskapp/data/models/task_model.dart';
import 'package:taskapp/viewmodels/task_viewmodel.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId; // Ab sirf taskId pass karo

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: SafeArea(
        child: StreamBuilder<TaskModel?>(
          stream: taskViewModel.listenTask(taskId), // Real-time stream
          builder: (context, snapshot) {
            // Loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Error or task not found
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text(
                  "Task not found",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            final task = snapshot.data!;
            final DateFormat dateFormat = DateFormat('dd MMMM yyyy');
            final DateFormat timeFormat = DateFormat('h:mm a');

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),

                        // Title + Status
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                task.title,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5D5DA8),
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: _getStatusColor(task.status).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                task.status,
                                style: TextStyle(
                                  color: _getStatusColor(task.status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Priority + Category
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(task.priority).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                task.priority,
                                style: TextStyle(
                                  color: _getPriorityColor(task.priority),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                task.category,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Description
                        if (task.description != null && task.description!.trim().isNotEmpty) ...[
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gray800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Text(
                              task.description!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF444444),
                                height: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],

                        // Date & Time Cards
                        _buildDetailCard("Date", Icons.calendar_today_rounded, dateFormat.format(task.startTime)),
                        _buildDetailCard("Start Time", Icons.access_time_rounded, timeFormat.format(task.startTime)),
                        _buildDetailCard("End Time", Icons.access_time_filled_rounded, timeFormat.format(task.endTime)),

                        const SizedBox(height: 40),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditTaskScreen(task: task),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit_rounded, size: 22),
                                label: const Text("Edit Task", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.close_rounded, size: 22),
                                label: const Text("Close", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: BorderSide(color: AppColors.primary, width: 2.5),
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper Widgets
  static Widget _buildDetailCard(String label, IconData icon, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5D5DA8))),
            ],
          ),
        ],
      ),
    );
  }

  static Color _getPriorityColor(String? priority) {
    return switch (priority?.toLowerCase()) {
      'high' => Colors.red,
      'medium' => Colors.orange,
      'low' => Colors.green,
      _ => Colors.grey,
    };
  }

  static Color _getStatusColor(String status) {
    return switch (status) {
      'Completed' => Colors.green,
      'In Progress' => Colors.orange,
      'To Do' => Colors.grey,
      _ => Colors.blue,
    };
  }
}