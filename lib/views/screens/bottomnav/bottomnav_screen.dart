// views/screens/common/bottom_nav_screen.dart

import 'package:flutter/material.dart';
import 'package:taskapp/views/screens/home/home_screen.dart';

import '../../../core/utils/widgets/custom_bottom_navbar.dart';
import '../../profile_screen.dart';
import '../../task_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const TasksScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // ← ZAROORI: Peeche wali screen dikhe
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