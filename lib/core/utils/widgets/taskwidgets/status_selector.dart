// core/utils/widgets/task/status_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/task_viewmodel.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_theme_constants.dart';

class StatusSelector extends StatelessWidget {
  StatusSelector({super.key});

  final Map<String, Color> statusColors = {
    'To Do': AppColors.gray500.withOpacity(0.2),
    'In Progress': AppColors.amber.withOpacity(0.25),
    'Completed': AppColors.success.withOpacity(0.22),
  };

  final Map<String, Color> selectedColors = {
    'To Do': AppColors.gray600,
    'In Progress': AppColors.amber,
    'Completed': AppColors.success,
  };

  final Map<String, IconData> statusIcons = {
    'To Do': Icons.radio_button_unchecked_rounded,
    'In Progress': Icons.sync_rounded,
    'Completed': Icons.check_circle_rounded,
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
              "Status",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.88),
              ),
            ),
            const SizedBox(height: 14),


            Wrap(
              spacing: 14,
              runSpacing: 12,
              children: ['To Do', 'In Progress', 'Completed'].map((status) {
                final bool isSelected = vm.task.status == status;

                return FilterChip(
                  avatar: Icon(
                    statusIcons[status],
                    size: 20,
                    color: isSelected ? AppColors.onPrimary : selectedColors[status],
                  ),
                  label: Text(
                    status,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 14.5,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => vm.updateStatus(status),

                  // Background
                  backgroundColor: statusColors[status],
                  selectedColor: selectedColors[status],

                  // Border & Shape
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
                    side: BorderSide(
                      color: isSelected
                          ? selectedColors[status]!
                          : AppColors.gray400.withOpacity(0.6),
                      width: isSelected ? 3.0 : AppThemeConstants.borderWidth,
                    ),
                  ),

                  // Text Color
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),

                  // Padding & Elevation
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  elevation: isSelected ? 10 : 2,
                  pressElevation: 18,
                  shadowColor: isSelected
                      ? selectedColors[status]!.withOpacity(0.55)
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