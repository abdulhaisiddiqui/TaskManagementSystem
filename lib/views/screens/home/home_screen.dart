import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskapp/core/utils/widgets/homewidgets/home_build_tab.dart';
import 'package:taskapp/core/utils/widgets/homewidgets/home_build_task_card.dart';
import 'package:taskapp/core/utils/widgets/reuseable_image_widget.dart';
import 'package:taskapp/core/utils/widgets/text_widget.dart';
import 'package:taskapp/data/repositories/notificationrepository/notification_repository.dart';
import 'package:taskapp/viewmodels/auth_viewmodel.dart';
import 'package:taskapp/views/screens/loginsignup/login_screen.dart';

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
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Greeting
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, Mo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0XFF000000),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      AuthViewModel().logout(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (contex) => LoginScreen()));
                    },
                  ),
                ],
              ),
            ),

            // Progress Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Color(0XFF828282),
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
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 10, // Thoda mota banaya
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Color(0XFFD1D0F9),
                            ), // Full capsule
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: 0.625, // 62.5%
                              backgroundColor: Colors
                                  .transparent, // Background hum Container se le rahe hain
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0XFFD1D0F9),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'You have 3 more tasks to do!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0XFFD1D0F9),
                            foregroundColor: Color(0XFFD1D0F9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                          ),
                          child: const Text(
                            'Details',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ReuseableImageWidget(img: 'cardimg.png'),
                ],
              ),
            ),
            // Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  HomeBuildTab(
                    label: 'All',
                    count: 17,
                    index: 0,
                    color: Color(0XFF0DA6C2),
                  ),
                  HomeBuildTab(
                    label: 'To Do',
                    count: 5,
                    index: 1,
                    color: Color(0XFF7B78AA),
                  ),
                  HomeBuildTab(
                    label: 'Prog',
                    count: 3,
                    index: 2,
                    color: Color(0XFFFFC239),
                  ),
                  HomeBuildTab(
                    label: 'Boni',
                    count: 0,
                    index: 3,
                    color: Color(0XFFD9D9D9),
                  ),
                ],
              ),
            ),

            // Task List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  HomeBuildTaskCard(
                    title: 'Grocery shopping',
                    time: '18.15 pm – 19.30 pm',
                    category: 'study',
                    status: 'high',
                    statusColor: Colors.red,
                  ),
                  HomeBuildTaskCard(
                    title: 'Grocery shopping',
                    time: '18.15 pm – 19.30 pm',
                    category: 'study',
                    status: 'high',
                    statusColor: Colors.red,
                  ),
                  HomeBuildTaskCard(
                    title: 'Grocery shopping',
                    time: '18.15 pm – 19.30 pm',
                    category: 'study',
                    status: 'high',
                    statusColor: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      //   selectedItemColor: Colors.teal,
      //   unselectedItemColor: Colors.grey,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      // ),
// bottomNavigationBar: BottomNavScreen(),
    );
  }


}
