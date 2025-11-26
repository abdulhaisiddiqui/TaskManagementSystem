// core/utils/widgets/task/priority_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/task_viewmodel.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_theme_constants.dart';

class PrioritySelector extends StatelessWidget {
  PrioritySelector({super.key});

  final Map<String, Color> priorityColors = {
    'Low': AppColors.success.withOpacity(0.2),
    'Medium': AppColors.amber.withOpacity(0.25),
    'High': AppColors.error.withOpacity(0.18),
  };

  final Map<String, Color> selectedColors = {
    'Low': AppColors.success.withOpacity(0.45),
    'Medium': AppColors.amber.withOpacity(0.45),
    'High': AppColors.error.withOpacity(0.45),
  };

  final Map<String, IconData> priorityIcons = {
    'Low': Icons.arrow_downward_rounded,
    'Medium': Icons.remove_rounded,
    'High': Icons.arrow_upward_rounded,
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
              "Priority level",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 12),


            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: ['Low', 'Medium', 'High'].map((priority) {
                final bool isSelected = vm.task.priority == priority;

                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        Icon(
                          priorityIcons[priority],
                          size: 18,
                          color: AppColors.onPrimary,
                        )
                      else
                        Icon(
                          priorityIcons[priority],
                          size: 18,
                          color: selectedColors[priority],
                        ),
                      const SizedBox(width: 6),
                      Text(
                        priority,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => vm.updatePriority(priority),

                  // Background
                  backgroundColor: priorityColors[priority],
                  selectedColor: selectedColors[priority],


                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
                    side: BorderSide(
                      color: isSelected
                          ? selectedColors[priority]!
                          : AppColors.gray400.withOpacity(0.6),
                      width: isSelected ? 2.8 : AppThemeConstants.borderWidth,
                    ),
                  ),


                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),


                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  elevation: isSelected ? 8 : 2,
                  pressElevation: 16,
                  shadowColor: isSelected
                      ? selectedColors[priority]!.withOpacity(0.5)
                      : Colors.transparent,

                  showCheckmark: false,
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}