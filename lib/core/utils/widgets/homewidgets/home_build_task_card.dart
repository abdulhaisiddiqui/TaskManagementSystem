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
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      constraints: const BoxConstraints(
        minHeight: 138,
        maxHeight: 172,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9FF).withOpacity(0.92),
        borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius + 13),
        border: Border.all(color: AppColors.primary.withOpacity(0.28), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          Row(
            children: [
              CircleAvatar(
                radius: 4.5,
                backgroundColor: _getPriorityColor(widget.task.priority),
              ),
              const SizedBox(width: 8),
              Text(
                _timeRange,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),

          // Title (Bigger but controlled)
          Text(
            widget.task.title,
            style: const TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 7),

          // Category & Status → Modern Chips Style
          Row(
            children: [
              _buildChip(
                icon: Icons.category_outlined,
                label: widget.task.category,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 14),
              _buildChip(
                icon: Icons.circle,
                label: widget.task.status,
                color: _statusColor,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          const SizedBox(height: 14),


          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: "Edit",
                  bgColor: const Color(0xFFE8E7FF),
                  textColor: const Color(0xFF6C63FF),
                  onTap: () => _navigateToEdit(),
                  isLoading: _isLoading,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionButton(
                  label: isCompleted ? "Reopen" : "Complete",
                  bgColor: isCompleted ? Colors.grey.shade200 : const Color(0xFFE8F5E8),
                  textColor: isCompleted ? Colors.grey.shade600 : const Color(0xFF2E7D32),
                  onTap: _isLoading ? null : () => _toggleCompleteStatus(),
                  isLoading: _isLoading,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionButton(
                  label: "Delete",
                  bgColor: const Color(0xFFFFEBEE),
                  textColor: const Color(0xFFD32F2F),
                  onTap: _isLoading ? null : () => _deleteTask(),
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(fontSize: 12.8, color: color, fontWeight: fontWeight),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Reusable Button
  Widget _buildActionButton({
    required String label,
    required Color bgColor,
    required Color textColor,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return Expanded(
      child: SizedBox(
        height: 38,
        child: ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: textColor,
            elevation: 0,
            disabledBackgroundColor: bgColor.withOpacity(0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // ← Kam touch area
          ),
          child: isLoading
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
              : FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
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
      // margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      constraints: const BoxConstraints(
        minHeight: 138,
        maxHeight: 172,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9FF).withOpacity(0.92),
        borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius + 13),
        border: Border.all(color: AppColors.primary.withOpacity(0.28), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 6),
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