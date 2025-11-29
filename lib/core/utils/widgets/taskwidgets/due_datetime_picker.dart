// core/utils/widgets/task/due_date_time_picker.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/task_viewmodel.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_theme_constants.dart';

class DueDateTimePicker extends StatelessWidget {
  const DueDateTimePicker({super.key});


  String _formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime).toLowerCase();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Column(
          children: [

            _buildTimeField(
              context: context,
              label: "Start Time",
              time: vm.task.startTime,
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(vm.task.startTime),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        timePickerTheme: TimePickerThemeData(
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          hourMinuteTextColor: AppColors.onBackgroundLight,
                          dayPeriodTextColor: AppColors.onBackgroundLight,
                          dialHandColor: AppColors.onBackgroundLight,
                          dialBackgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                          entryModeIconColor: AppColors.onBackgroundLight,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(foregroundColor: AppColors.onBackgroundLight),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (time != null) {
                  vm.updateStartTime(DateTime(
                    vm.task.startTime.year,
                    vm.task.startTime.month,
                    vm.task.startTime.day,
                    time.hour,
                    time.minute,
                  ));
                }
              },
            ),

            const SizedBox(height: 18),

            // End Time Picker
            _buildTimeField(
              context: context,
              label: "End Time",
              time: vm.task.endTime,
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(vm.task.endTime),
                  builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      timePickerTheme: TimePickerThemeData(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        hourMinuteTextColor: AppColors.onBackgroundLight,
                        dayPeriodTextColor: AppColors.onBackgroundLight,
                        dialHandColor: AppColors.onBackgroundLight,
                        dialBackgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(foregroundColor: AppColors.onBackgroundLight),
                      ),
                    ),
                    child: child!,
                  ),
                );

                if (time != null) {
                  vm.updateEndTime(DateTime(
                      vm.task.endTime.year,
                      vm.task.endTime.month, vm.task.endTime.day, time.hour, time.minute));
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimeField({
    required BuildContext context,
    required String label,
    required DateTime time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
          suffixIcon: Icon(
            Icons.access_time_rounded,
            color: AppColors.onBackgroundLight,
            size: 24,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius + 13),
            borderSide: BorderSide(
              color: AppColors.gray400.withOpacity(0.5),
              width: AppThemeConstants.borderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius + 13),
            borderSide: BorderSide(color: AppColors.primary, width: AppThemeConstants.borderWidth),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
        child: Text(
          _formatTime(time),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.onBackgroundLight,
          ),
        ),
      ),
    );
  }
}