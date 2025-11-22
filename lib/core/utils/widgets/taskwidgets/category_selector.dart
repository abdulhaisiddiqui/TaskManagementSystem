// core/utils/widgets/task/category_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/task_viewmodel.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_theme_constants.dart';

class CategorySelector extends StatelessWidget {
  CategorySelector({super.key});

  final List<String> categories = ['Personal', 'Work', 'Study', 'Other'];


  final Map<String, Color> categoryColors = {
    'Personal': const Color(0xFFE8F5E9),
    'Work': const Color(0xFFFFF3E0),
    'Study': const Color(0xFFE3F2FD),
    'Other': const Color(0xFFF3E5F5),
  };

  final Map<String, Color> categorySelectedColors = {
    'Personal': AppColors.primary,
    'Work': AppColors.amber,
    'Study': AppColors.info,
    'Other': AppColors.purple,
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Text(
              "Category",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 12),

            // Chips
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: categories.map((category) {
                final bool isSelected = vm.task.category == category;

                return FilterChip(
                  label: Text(
                    category,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => vm.updateCategory(category),

                  // Background & Selected State
                  backgroundColor: categoryColors[category],
                  selectedColor: categorySelectedColors[category] ?? AppColors.primary,

                  // Shape & Border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
                    side: BorderSide(
                      color: isSelected
                          ? (categorySelectedColors[category] ?? AppColors.primary)
                          : AppColors.gray400.withOpacity(0.5),
                      width: isSelected ? 2.5 : AppThemeConstants.borderWidth,
                    ),
                  ),

                  // Padding & Elevation
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  showCheckmark: false,
                  elevation: isSelected ? 6 : 1,
                  pressElevation: 12,
                  shadowColor: isSelected
                      ? (categorySelectedColors[category] ?? AppColors.primary).withOpacity(0.4)
                      : Colors.transparent,
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}