// core/utils/widgets/task/status_selector.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/task_viewmodel.dart';

class StatusSelector extends StatelessWidget {
  StatusSelector({super.key});

  final List<Map<String, dynamic>> statuses = [
    {
      'label': 'To Do',
      'icon': Icons.radio_button_unchecked_rounded,
      'color': Colors.grey.shade600,
      'bg': const Color(0xFFF5F5F5),
    },
    {
      'label': 'In Progress',
      'icon': Icons.sync_rounded,
      'color': const Color(0xFFFF9800),
      'bg': const Color(0xFFFFF3E0),
    },
    // {
    //   'label': 'Completed',
    //   'icon': Icons.check_circle_rounded,
    //   'color': const Color(0xFF4CAF50),
    //   'bg': const Color(0xFFE8F5E9),
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {
        final current = vm.task.status;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Status", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.grey.shade800)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 14,
              runSpacing: 12,
              children: statuses.map((s) {
                final bool isSelected = current == s['label'];
                final Color color = s['color'];
                final Color bg = s['bg'];

                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(s['icon'], size: 21, color: isSelected ? Colors.white : color),
                      const SizedBox(width: 8),
                      Text(
                        s['label'],
                        style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87),
                      ),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => vm.updateStatus(s['label']),
                  backgroundColor: bg,
                  selectedColor: color,
                  shape: StadiumBorder(
                    side: BorderSide(color: isSelected ? color : color.withOpacity(0.3), width: isSelected ? 2.6 : 1.6),
                  ),
                  elevation: isSelected ? 12 : 2,
                  pressElevation: 18,
                  shadowColor: color.withOpacity(isSelected ? 0.5 : 0.2),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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