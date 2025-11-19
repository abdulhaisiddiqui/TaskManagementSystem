// core/utils/widgets/edit_profile/edit_profile_text_field.dart
import 'package:flutter/material.dart';
import 'package:taskapp/core/theme/app_theme_constants.dart';

class EditProfileTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final bool enabled;
  final Function(String)? onChanged;

  const EditProfileTextField({
    super.key,
    required this.label,
    required this.initialValue,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          enabled: enabled,
          onChanged: onChanged,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled
                ? theme.colorScheme.surface
                : theme.colorScheme.surface.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
              borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
              borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
              borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.1)),
            ),
          ),
        ),
      ],
    );
  }
}