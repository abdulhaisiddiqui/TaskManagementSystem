// lib/core/utils/widgets/taskwidgets/custom_text_fields.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_color.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final IconData icon;
  final int maxLines;
  final Function(String) onChanged;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.icon,
    this.maxLines = 1,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("  $label", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF5D5DA8))),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: AppColors.primary, width: 2)),
          ),
        ),
      ],
    );
  }
}