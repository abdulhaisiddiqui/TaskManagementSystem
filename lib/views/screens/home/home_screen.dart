import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/core/utils/widgets/homewidgets/home_build_tab.dart';
import 'package:taskapp/core/utils/widgets/homewidgets/home_build_task_card.dart';
import 'package:taskapp/core/utils/widgets/reuseable_image_widget.dart';
import 'package:taskapp/core/utils/widgets/text_widget.dart';
import 'package:taskapp/data/repositories/notificationrepository/notification_repository.dart';
import 'package:taskapp/viewmodels/auth_viewmodel.dart';
import 'package:taskapp/viewmodels/profile_viewmodel.dart';
import 'package:taskapp/viewmodels/task_viewmodel.dart';
import 'package:taskapp/views/screens/loginsignup/login_screen.dart';
import 'package:taskapp/views/screens/notification/notification_screen.dart';

import '../../../data/models/app_notification_model.dart';
import '../../../viewmodels/notification_viewmodel.dart';

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

    _notificationRepo.setupFirebaseMessagingListener();


    _notificationRepo.showWelcomeNotification();

    final now = DateTime.now();
    final dailyTime = DateTime(now.year, now.month, now.day, 9, 0);
    _notificationRepo.scheduleDailySummary(dailyTime.isBefore(now)
        ? dailyTime.add(const Duration(days: 1))
        : dailyTime);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            // ----------------------------- HEADER -----------------------------
            Consumer<ProfileViewModel>(builder: (context, vm, child) {
              final String? photoUrl = vm.user?.photoURL;

              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade200,
                      child: ClipOval(
                        child: photoUrl != null && photoUrl.isNotEmpty
                            ? Image.network(
                          photoUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                            : const Icon(Icons.person, size: 34),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // NAME + WELCOME
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 170,
                          child: Text(
                            'Hello, ${vm.user?.displayName ?? ''}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),

                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.notifications_none_outlined),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => NotificationScreen()),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),

            // -------------------------- PROGRESS CARD --------------------------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0XFF828282),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(
                          text: '62.5% completed',
                          txtStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: 0.625,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0XFFD1D0F9),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Consumer<ProfileViewModel>(
                            builder: (context, vm, child) {
                              final tasks =
                                  vm.user?.stats['pendingTasks'] ?? 0;
                              return Text(
                                'You have $tasks more task${tasks > 1 ? 's' : ''} to do!',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              );
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ReuseableImageWidget(img: 'cardimg.png'),
                ],
              ),
            ),

            // ----------------------------- TABS -----------------------------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const Row(
                children: [
                  HomeBuildTab(label: 'All', count: 17, index: 0, color: Color(0XFF0DA6C2)),
                  HomeBuildTab(label: 'To Do', count: 5, index: 1, color: Color(0XFF7B78AA)),
                  HomeBuildTab(label: 'Prog', count: 3, index: 2, color: Color(0XFFFFC239)),
                  HomeBuildTab(label: 'Boni', count: 0, index: 3, color: Color(0XFFD9D9D9)),
                ],
              ),
            ),

            // ----------------------------- TASKS LIST -----------------------------
      Expanded(
        child: StreamBuilder(
          stream: context.read<TaskViewModel>().getTasks(),
          builder: (context, snapshot) {
            print("Tasks snapshot: ${snapshot.data}");

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No tasks found"));
            }

            final tasks = snapshot.data!;

            String format(DateTime t) {
              String hour = t.hour.toString().padLeft(2, '0');
              String minute = t.minute.toString().padLeft(2, '0');
              String ampm = t.hour >= 12 ? 'pm' : 'am';
              return "$hour.$minute $ampm";
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                final formattedTime =
                    "${format(task.startTime)} – ${format(task.endTime)}";

                return HomeBuildTaskCard(
                  title: task.title,
                  time: formattedTime,
                  category: task.category,
                  status: task.status,
                  statusColor: task.status == "Completed"
                      ? Colors.green
                      : Colors.orange,
                );
              },
            );
          },
        ),
      ),


          ],
        ),
      ),
    );
  }
}
