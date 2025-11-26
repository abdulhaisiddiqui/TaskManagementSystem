// views/widgets/floating_bottom_nav_bar.dart
import 'dart:ui';
import 'package:flutter/material.dart';

import '../../theme/app_color.dart';
import '../../theme/app_theme_constants.dart';

class FloatingBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Material(
          elevation: 24,
          borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius + 13), // 20
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius + 8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 76,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withOpacity(0.4)
                      : Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius + 8),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.15)
                        : AppColors.primary.withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  currentIndex: currentIndex,
                  onTap: onTap,
                  type: BottomNavigationBarType.fixed,
                  elevation: 0,
                  selectedFontSize: 12,
                  unselectedFontSize: 11,
                  selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),


                  selectedItemColor: AppColors.primary,
                  unselectedItemColor: isDark ? Colors.white70 : Colors.black54,

                  items: [
                    _navItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
                    _navItem(Icons.format_list_bulleted_outlined, Icons.format_list_bulleted_rounded, 'Tasks'),
                    _navItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(IconData outline, IconData filled, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(outline, size: 28),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(filled, size: 30),
      ),
      label: label,
    );
  }
}