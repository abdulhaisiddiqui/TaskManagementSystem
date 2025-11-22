// core/utils/widgets/edit_profile/edit_profile_dropdown.dart
import 'package:flutter/material.dart';
import 'package:taskapp/core/theme/app_theme_constants.dart';

class EditProfileDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final Function(String?) onChanged;

  const EditProfileDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: theme.textTheme.bodyLarge))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
              borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
            ),
          ),
          dropdownColor: theme.colorScheme.surface,
          icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.primary),
        ),
      ],
    );
  }
}