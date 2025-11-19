import 'package:flutter/material.dart';
import '../data/models/app_notification_model.dart';
import '../data/repositories/notificationrepository/notification_repository.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository _repo = NotificationRepository();

  Stream<List<AppNotification>> get notifications => _repo.getNotifications();
}
