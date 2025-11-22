// lib/core/utils/widgets/homewidgets/home_build_tab.dart
import 'package:flutter/material.dart';

import '../../../theme/app_color.dart';
import '../../../theme/app_theme_constants.dart';

class HomeBuildTab extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const HomeBuildTab({
    super.key,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.gray800 : AppColors.gray200),
          borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius + 8), // 20
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withOpacity(0.6)
                : Colors.transparent,
            width: 1.5,
          ),
          // boxShadow: isSelected
          //     ? [
          //   BoxShadow(
          //     color: AppColors.primary.withOpacity(isDark ? 0.5 : 0.35),
          //     blurRadius: 14,
          //     offset: const Offset(0, 6),
          //   ),
          //   BoxShadow(
          //     color: AppColors.primary.withOpacity(isDark ? 0.3 : 0.2),
          //     blurRadius: 30,
          //     offset: const Offset(0, 12),
          //   ),
          // ]
          //     : [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
          //     blurRadius: 8,
          //     offset: const Offset(0, 2),
          //   ),
          // ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isSelected ? AppColors.onBackgroundDark : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 15,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 10),

            // Count Badge
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.onBackgroundDark : AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.onBackgroundDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}