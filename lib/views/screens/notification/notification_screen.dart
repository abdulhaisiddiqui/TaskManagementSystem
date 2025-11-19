import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/views/screens/bottomnav/bottomnav_screen.dart';

import '../../../data/models/app_notification_model.dart';
import '../../../viewmodels/notification_viewmodel.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
        }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Expanded(
        child: StreamBuilder<List<AppNotification>>(
          stream: context.watch<NotificationViewModel>().notifications,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

            final notifications = snapshot.data!;
            if (notifications.isEmpty) return const Center(child: Text("No notifications"));

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                return ListTile(
                  title: Text(n.title),
                  subtitle: Text(n.body),
                  trailing: Text(n.scheduledTime.toLocal().toString()),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
