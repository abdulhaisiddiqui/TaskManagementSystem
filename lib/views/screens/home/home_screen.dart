import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskapp/data/repositories/notificationrepository/notification_repository.dart';
import 'package:taskapp/viewmodels/auth_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  final _notificationRepo = NotificationRepository();
  @override
  void initState() {
    super.initState();
    _notificationRepo.showWelcomeNotification();
  }


  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          AuthViewModel().logout(context);
        }, icon: Icon(Icons.logout)),
      ),
    );
  }
}
