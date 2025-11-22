// core/utils/widgets/edit_profile/save_changes_button.dart
import 'package:flutter/material.dart';

import '../../../theme/app_theme_constants.dart';
import '../../../theme/app_color.dart';

class SaveChangesButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String label;

  const SaveChangesButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.label = "Save Changes",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purple,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.gray500,
          elevation: 8,
          shadowColor: AppColors.primary.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
          ),

          padding: const EdgeInsets.symmetric(vertical: 16),
        ).copyWith(

          overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.2)),
        ),
        child: isLoading
            ? const SizedBox(
          height: 28,
          width: 28,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        )
            : Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: AppColors.onBackgroundDark,
          ),
        ),
      ),
    );
  }
}