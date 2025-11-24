// lib/views/screens/notification_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/core/theme/app_color.dart';
import 'package:taskapp/data/models/app_notification_model.dart';
import 'package:taskapp/viewmodels/notification_viewmodel.dart';
import 'package:taskapp/views/screens/bottomnav/bottomnav_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D5DA8),
          ),
        ),
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
        }, icon: Icon(Icons.arrow_back_ios)),
        actions: [
          TextButton(
            onPressed: () {

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("All notifications cleared!")),
              );
            },
            child: const Text(
              "Clear All",
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: Consumer<NotificationViewModel>(
        builder: (context, vm, child) {
          return StreamBuilder<List<AppNotification>>(
            stream: vm.notifications,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text("Error loading notifications: ${snapshot.error}"),
                );
              }

              final notifications = snapshot.data ?? [];

              if (notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        "No notifications yet",
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                      ),
                      Text(
                        "We'll notify you when something important happens",
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final timeAgo = _formatTimeAgo(notification.scheduledTime);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon based on type
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getNotificationColor(notification.type).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _getNotificationIcon(notification.type),
                            color: _getNotificationColor(notification.type),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D2D2D),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                notification.body,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                timeAgo,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return "Just now";
    if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
    if (difference.inHours < 24) return "${difference.inHours}h ago";
    if (difference.inDays < 7) return "${difference.inDays}d ago";
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  Color _getNotificationColor(String type) {
    return switch (type) {
      "Task Reminder" => Colors.orange,
      "Overdue Alert" => Colors.red,
      "Completion Celebration" => Colors.green,
      "Daily Summary" => AppColors.primary,
      _ => Colors.blue,
    };
  }

  IconData _getNotificationIcon(String type) {
    return switch (type) {
      "Task Reminder" => Icons.alarm,
      "Overdue Alert" => Icons.warning_amber_rounded,
      "Completion Celebration" => Icons.celebration,
      "Daily Summary" => Icons.today_rounded,
      _ => Icons.notifications_active,
    };
  }
}