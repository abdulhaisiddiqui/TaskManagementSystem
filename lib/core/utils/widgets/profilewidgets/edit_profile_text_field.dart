// core/utils/widgets/edit_profile/edit_profile_text_field.dart
import 'package:flutter/material.dart';

import '../../../theme/app_theme_constants.dart';
import '../../../theme/app_color.dart';

class EditProfileTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final bool enabled;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final int? maxLines;

  const EditProfileTextField({
    super.key,
    required this.label,
    required this.initialValue,
    this.enabled = true,
    this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),

        // Text Field
        TextFormField(
          initialValue: initialValue,
          enabled: enabled,
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled
                ? theme.colorScheme.surface
                : (isDark ? AppColors.gray800 : AppColors.gray200),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),


            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
              borderSide: BorderSide(
                color: AppColors.gray400.withOpacity(0.5),
                width: AppThemeConstants.borderWidth,
              ),
            ),

            // Focused Border
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: AppThemeConstants.borderWidth,
              ),
            ),

            // Disabled Border
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
              borderSide: BorderSide(
                color: AppColors.gray500.withOpacity(0.3),
                width: AppThemeConstants.borderWidth,
              ),
            ),


            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
              borderSide: BorderSide(color: AppColors.error, width: AppThemeConstants.borderWidth),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
              borderSide: BorderSide(color: AppColors.error, width: AppThemeConstants.borderWidth + 0.5),
            ),
          ),
        ),
      ],
    );
  }
}