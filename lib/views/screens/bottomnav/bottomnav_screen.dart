// views/screens/common/bottom_nav_screen.dart

import 'package:flutter/material.dart';
import 'package:taskapp/views/screens/home/home_screen.dart';
import 'package:taskapp/views/screens/splash/splash_screen.dart';
import 'package:taskapp/views/screens/taskscreens/create_task_screen.dart';
import 'package:taskapp/views/screens/taskscreens/fetch_task_screen.dart';

import '../../../core/utils/widgets/custom_bottom_navbar.dart';
import 'package:taskapp/views/screens/profile/profile_screen.dart';


class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const TodaysTasksScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Pages
          IndexedStack(
            index: currentIndex,
            children: pages,
          ),
          // Floating Nav Bar
          FloatingBottomNavBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}