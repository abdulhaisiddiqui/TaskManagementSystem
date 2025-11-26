// lib/core/utils/widgets/homewidgets/home_build_task_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/core/theme/app_color.dart';
import 'package:taskapp/core/utils/widgets/custom_snackbar.dart';
import 'package:taskapp/data/models/task_model.dart';
import 'package:taskapp/data/repositories/taskrepository/task_repository.dart';
import 'package:taskapp/viewmodels/task_viewmodel.dart';
import 'package:taskapp/views/screens/taskscreens/edit_task_screen.dart';

import '../../../../data/repositories/streak_service.dart';
import '../../../theme/app_theme_constants.dart';

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
        return Colors.green.withOpacity(0.65);
      case 'In Progress':
        return Colors.orange.withOpacity(0.65);
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
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFB5B5B5).withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius + 13), // 20
        border: Border.all(
          color:  AppColors.primary.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
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
                color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                onTap: () => _navigateToEdit(),
              ),
              _buildActionButton(
                label: isCompleted ? "Reopen" : "Complete",
                color: isCompleted ? Colors.grey.withOpacity(0.12) : Colors.green.withOpacity(0.22),
                onTap: _isLoading ? null : () => _toggleCompleteStatus(),
              ),
              _buildActionButton(
                label: "Delete",
                color: Colors.red.withOpacity(0.22),
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
        foregroundColor: Colors.grey.shade700,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        minimumSize: const Size(90, 40),
      ),
      child: _isLoading && onTap != null
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
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

      // Update streaks & badges only when changing from non-completed -> completed
      if (newStatus == 'Completed' && oldStatus != 'Completed') {
        final unlocked = await StreakService.updateStreakAndBadges(widget.uid);
        print("Streak & Badges Updated! unlocked: $unlocked");
        if (mounted) _showUnlockedBadges(unlocked);
      }

      if (mounted) {
        CustomSnackBar.success(message: "Task marked as $newStatus", context: context);

      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.success(message: "Failed to update task", context: context);

      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showUnlockedBadges(List<String> unlocked) {
    if (unlocked.isEmpty) return;

    // final messenger = ScaffoldMessenger.of(context);

    if (unlocked.contains('week_warrior')) {
      CustomSnackBar.warning(message: "🔥 Week Warrior unlocked!", context: context);
      // messenger.showSnackBar(const SnackBar(content: Text('🔥 Week Warrior unlocked!'), backgroundColor: Colors.deepOrange));
    }
    if (unlocked.contains('month_master')) {
      CustomSnackBar.info(message: "🏆 Month Master unlocked!", context: context);
      // messenger.showSnackBar(const SnackBar(content: Text('🏆 Month Master unlocked!'), backgroundColor: Colors.purple));
    }
    if (unlocked.contains('fire_50')) {
      CustomSnackBar.success(message: "🔥🔥 50-day fire unlocked!", context: context);
      // messenger.showSnackBar(const SnackBar(content: Text('🔥🔥 50-day fire unlocked!'), backgroundColor: Colors.redAccent));
    }
    if (unlocked.contains('first_task')) {
      CustomSnackBar.success(message: "✅ First task completed — Badge unlocked!", context: context);
      // messenger.showSnackBar(const SnackBar(content: Text('✅ First task completed — Badge unlocked!'), backgroundColor: Colors.green));
    }
    if (unlocked.contains('legend_100')) {
      // Show a celebratory dialog for LEGEND
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('LEGEND UNLOCKED! 🎉'),
          content: const Text('You reached a 100-day streak — legendary!'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Nice!')),
          ],
        ),
      );
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
        CustomSnackBar.error(message: "Task deleted successfully", context: context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.error(message: "Failed to delete task", context: context);

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
        borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius + 13), // 20
        border: Border.all(
          color:  AppColors.primary.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                  color: isCompleted ? Colors.green : Colors.orange.withOpacity(0.65),
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


      if (newStatus == 'Completed' && oldStatus != 'Completed') {
        final unlocked = await StreakService.updateStreakAndBadges(widget.uid);
        print("Streak & Badges Updated! unlocked: $unlocked");
        if (mounted) _showUnlockedBadgesGrid(unlocked);
      }

      if (mounted) {
        CustomSnackBar.success(message: "Task $newStatus ho gaya!", context: context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("Task $newStatus ho gaya!"),
        //     backgroundColor: Colors.green,
        //   ),
        // );
      }
    } catch (e) {
      print("Error: $e");
      if (mounted) {
        CustomSnackBar.error(message: "Failed", context: context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Failed"), backgroundColor: Colors.red),
        // );
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
        CustomSnackBar.error(message: "Task deleted successfully", context: context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Task deleted successfully"), backgroundColor: Colors.red),
        // );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.error(message: "Failed to delete task", context: context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Failed to delete task"), backgroundColor: Colors.red),
        // );
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

  void _showUnlockedBadgesGrid(List<String> unlocked) {
    if (unlocked.isEmpty) return;
    // final messenger = ScaffoldMessenger.of(context);

    if (unlocked.contains('week_warrior')) {
      CustomSnackBar.warning(message: "🔥 Week Warrior unlocked!", context: context);
      // messenger.showSnackBar(const SnackBar(content: Text('🔥 Week Warrior unlocked!'), backgroundColor: Colors.deepOrange));
    }
    if (unlocked.contains('month_master')) {
      CustomSnackBar.info(message: "🏆 Month Master unlocked!", context: context);
      // messenger.showSnackBar(const SnackBar(content: Text('🏆 Month Master unlocked!'), backgroundColor: Colors.purple));
    }
    if (unlocked.contains('fire_50')) {
      CustomSnackBar.success(message: "🔥🔥 50-day fire unlocked!", context: context);
      // messenger.showSnackBar(const SnackBar(content: Text('🔥🔥 50-day fire unlocked!'), backgroundColor: Colors.redAccent));
    }
    if (unlocked.contains('first_task')) {
      CustomSnackBar.success(message: "✅ First task completed — Badge unlocked!", context: context);
      // messenger.showSnackBar(const SnackBar(content: Text('✅ First task completed — Badge unlocked!'), backgroundColor: Colors.green));
    }
    if (unlocked.contains('legend_100')) {
      // Show a celebratory dialog for LEGEND
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('LEGEND UNLOCKED! 🎉'),
          content: const Text('You reached a 100-day streak — legendary!'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Nice!')),
          ],
        ),
      );
    }
  }
}