// lib/core/utils/widgets/taskwidgets/custom_dropdown.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_color.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String value;                    // current selected value
  final List<String> items;
  final void Function(String?) onChanged; // ← String? accept karega

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("  $label", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF5D5DA8))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
              items: items.map((String item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged, // ← Ab yeh String? accept karega
            ),
          ),
        ),
      ],
    );
  }
}