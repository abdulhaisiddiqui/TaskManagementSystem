// core/utils/widgets/task/category_selector.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/task_viewmodel.dart';
import '../../../theme/app_color.dart';

class CategorySelector extends StatelessWidget {
  CategorySelector({super.key});

  final List<Map<String, dynamic>> categories = [
    {'label': 'Personal', 'icon': Icons.person_outline, 'bg': const Color(0xFFF3E5F5)}, // Soft Purple
    {'label': 'Work', 'icon': Icons.work_outline, 'bg': const Color(0xFFE8EAF6)},     // Soft Indigo
    {'label': 'Study', 'icon': Icons.school_outlined, 'bg': const Color(0xFFE0F2F1)},  // Soft Teal
    {'label': 'Other', 'icon': Icons.category_outlined, 'bg': const Color(0xFFFFF3E0)}, // Soft Orange
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {
        final current = vm.task.category;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Category", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.grey.shade800)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: categories.map((c) {
                final bool isSelected = current == c['label'];
                final Color bg = c['bg'];

                return FilterChip(
                  avatar: CircleAvatar(
                    radius: 11,
                    backgroundColor: isSelected ? AppColors.primary : bg,
                    child: Icon(c['icon'], size: 15, color: isSelected ? Colors.white : AppColors.primary.withOpacity(0.7)),
                  ),
                  label: Text(
                    c['label'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => vm.updateCategory(c['label']),
                  backgroundColor: bg,
                  selectedColor: AppColors.primary.withOpacity(0.18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  elevation: isSelected ? 8 : 1,
                  padding: const EdgeInsets.fromLTRB(6, 10, 14, 10),
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