// core/utils/widgets/edit_profile/save_changes_button.dart
import 'package:flutter/material.dart';
import 'package:taskapp/core/theme/app_theme_constants.dart';

class SaveChangesButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveChangesButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
        ),
      ),
      child: Text("Save Changes", style: theme.textTheme.titleLarge),
    );
  }
}