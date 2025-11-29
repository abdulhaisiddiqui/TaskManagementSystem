// core/utils/widgets/task/save_button.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/core/utils/widgets/custom_snackbar.dart';

import '../../../../viewmodels/task_viewmodel.dart';
import '../../../../views/screens/bottomnav/bottomnav_screen.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_theme_constants.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SizedBox(
            height: 58,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: vm.isLoading
                  ? null
                  : () async {
                if (!vm.isValid) {
                  CustomSnackBar.error(message: "Please fill title and valid due date", context: context);

                  return;
                }

                final success = await vm.saveTask();

                if (!context.mounted) return;

                if (success) {
                  CustomSnackBar.success(message: "Task saved successfully!", context: context);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const BottomNavScreen()),
                        (route) => false,
                  );
                } else {
                  CustomSnackBar.error(message: "Failed to save task", context: context);

                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: AppColors.onPrimary,
                disabledBackgroundColor: AppColors.gray500,
                elevation: 10,
                shadowColor: AppColors.primary.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ).copyWith(
                overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.25)),
              ),
              child: vm.isLoading
                  ? const SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3.5,
                ),
              )
                  : Text(
                "Save Task",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.onBackgroundDark,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}