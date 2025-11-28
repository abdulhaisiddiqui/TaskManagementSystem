// core/utils/widgets/task/priority_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/task_viewmodel.dart';
import '../../../theme/app_color.dart';

class PrioritySelector extends StatelessWidget {
  PrioritySelector({super.key});

  final List<Map<String, dynamic>> priorities = [
    {
      'label': 'Low',
      'icon': Icons.arrow_downward_rounded,
      'color': const Color(0xFF4CAF50), // Green
      'light': const Color(0xFFE8F5E9),
    },
    {
      'label': 'Medium',
      'icon': Icons.remove_rounded,
      'color': const Color(0xFFFF9800), // Amber
      'light': const Color(0xFFFFF3E0),
    },
    {
      'label': 'High',
      'icon': Icons.arrow_upward_rounded,
      'color': const Color(0xFFE91E63), // Pinkish Red (better than harsh red)
      'light': const Color(0xFFFCE4EC),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {
        final current = vm.task.priority;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Priority level", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.grey.shade800)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: priorities.map((p) {
                final bool isSelected = current == p['label'];
                final Color color = p['color'];
                final Color light = p['light'];

                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(p['icon'], size: 19, color: isSelected ? Colors.white : color),
                      const SizedBox(width: 8),
                      Text(
                        p['label'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => vm.updatePriority(p['label']),
                  backgroundColor: light,
                  selectedColor: color,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: isSelected ? color : color.withOpacity(0.3),
                      width: isSelected ? 2.6 : 1.6,
                    ),
                  ),
                  elevation: isSelected ? 10 : 1.5,
                  pressElevation: 16,
                  shadowColor: color.withOpacity(isSelected ? 0.4 : 0.15),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
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