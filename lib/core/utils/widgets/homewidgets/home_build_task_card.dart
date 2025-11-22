// lib/core/utils/widgets/homewidgets/home_build_task_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/data/models/task_model.dart';
import 'package:taskapp/data/repositories/taskrepository/task_repository.dart';
import 'package:taskapp/viewmodels/task_viewmodel.dart';
import 'package:taskapp/views/screens/taskscreens/edit_task_screen.dart';

class HomeBuildTaskCard extends StatefulWidget {
  final TaskModel task;
  final String uid;

  const HomeBuildTaskCard({
    super.key,
    required this.task,
    required this.uid,
  });

  @override
  State<HomeBuildTaskCard> createState() => _HomeBuildTaskCardState();
}

class _HomeBuildTaskCardState extends State<HomeBuildTaskCard> {

  Color _getPriorityColor(String? priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  Color get _statusColor {
    switch (widget.task.status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  final TaskRepository _taskRepo = TaskRepository();
  final TaskViewModel _taskViewModel = TaskViewModel();
  bool _isLoading = false;

  bool get isCompleted => widget.task.status == 'Completed';

  String get _timeRange {
    final start = widget.task.startTime;
    final end = widget.task.endTime;
    final format = (time) => "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
    return "${format(start)} - ${format(end)}";
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFB5B5B5).withOpacity(0.15),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 5,
                backgroundColor: _getPriorityColor(widget.task.priority),
              ),
              const SizedBox(width: 10),
              Text(
                _timeRange,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            widget.task.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),

          // Category & Status
          Row(
            children: [
              Text("Category: ${widget.task.category}", style: const TextStyle(fontSize: 13, color: Colors.black54)),
              const SizedBox(width: 20),
              Text(
                "Status: ${widget.task.status}",
                style: TextStyle(fontSize: 13, color: _statusColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(
                label: "Edit",
                color: Colors.orange,
                onTap: () => _navigateToEdit(),
              ),
              _buildActionButton(
                label: isCompleted ? "Reopen" : "Complete",
                color: isCompleted ? Colors.grey.shade600 : Colors.green,
                onTap: _isLoading ? null : () => _toggleCompleteStatus(),
              ),
              _buildActionButton(
                label: "Delete",
                color: Colors.red,
                onTap: _isLoading ? null : () => _deleteTask(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Reusable Button
  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        minimumSize: const Size(90, 40),
      ),
      child: _isLoading && onTap != null
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }

  // Edit Task
  void _navigateToEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditTaskScreen(task: widget.task)),
    );
  }

  // Toggle Complete / Reopen
  Future<void> _toggleCompleteStatus() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final oldStatus = widget.task.status;
    final newStatus = isCompleted ? 'To Do' : 'Completed';
    final updatedTask = widget.task.copyWith(status: newStatus);

    try {
      await _taskRepo.updateTask(
        widget.uid,
        updatedTask,
        oldCompletionStatus: oldStatus == 'Completed', // Yeh important hai!
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Task marked as $newStatus"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update task"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Delete Task
  Future<void> _deleteTask() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Task?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await _taskViewModel.deleteTask(widget.uid, widget.task.id!, isCompleted);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task deleted successfully"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to delete task"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}


class HomeBuildTaskCardGrid extends StatefulWidget {
  final TaskModel task;
  final String uid;

  const HomeBuildTaskCardGrid({
    super.key,
    required this.task,
    required this.uid,
  });

  @override
  State<HomeBuildTaskCardGrid> createState() => _HomeBuildTaskCardGridState();
}

class _HomeBuildTaskCardGridState extends State<HomeBuildTaskCardGrid> {
  bool _isLoading = false;

  final TaskRepository _taskRepo = TaskRepository();
  final TaskViewModel _taskViewModel = TaskViewModel();

  bool get isCompleted => widget.task.status == 'Completed';

  Color _getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB5B5B5).withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: _getPriorityColor(widget.task.priority),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${widget.task.startTime.hour}:${widget.task.startTime.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.task.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                widget.task.category,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.task.status,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),


          Positioned(
            top: -12,
            right: -20,
            child: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 10,
              offset: const Offset(0, 45),
              icon: Icon(Icons.more_vert, size: 22, color: Colors.black54),
              onSelected: (value) => _handleMenuAction(value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [
                    Icon(Icons.edit, size: 18, color: Colors.orange),
                    SizedBox(width: 10),
                    Text("Edit Task"),
                  ]),
                ),
                PopupMenuItem(
                  value: 'complete',
                  child: Row(children: [
                    Icon(
                      isCompleted ? Icons.restart_alt : Icons.check_circle,
                      size: 18,
                      color: isCompleted ? Colors.grey.shade600 : Colors.green,
                    ),
                    SizedBox(width: 10),
                    Text(isCompleted ? "Reopen Task" : "Mark as Complete"),
                  ]),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    Icon(Icons.delete_forever, size: 18, color: Colors.red),
                    SizedBox(width: 10),
                    Text("Delete Task", style: TextStyle(color: Colors.red)),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tumhari 100% tested & solid logic — bilkul same
  void _navigateToEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditTaskScreen(task: widget.task)),
    );
  }

  Future<void> _toggleCompleteStatus() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final oldStatus = widget.task.status;
    final newStatus = isCompleted ? 'To Do' : 'Completed';
    final updatedTask = widget.task.copyWith(status: newStatus);

    try {
      await _taskRepo.updateTask(
        widget.uid,
        updatedTask,
        oldCompletionStatus: oldStatus == 'Completed',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Task marked as $newStatus"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update task"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteTask() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Task?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await _taskViewModel.deleteTask(widget.uid, widget.task.id!, isCompleted);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task deleted successfully"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to delete task"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Menu Handler
  void _handleMenuAction(String action) {
    switch (action) {
      case 'edit':
        _navigateToEdit();
        break;
      case 'complete':
        _toggleCompleteStatus();
        break;
      case 'delete':
        _deleteTask();
        break;
    }
  }
}