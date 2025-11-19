import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/task_viewmodel.dart';

class PrioritySelector extends StatelessWidget {
   PrioritySelector({Key? key}) : super(key: key);

  final List<String> priorities = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Priority level", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: priorities.map((p) {
                bool selected = vm.task.priority == p;
                return ChoiceChip(
                  label: Text(p),
                  selected: selected,
                  selectedColor: Colors.deepPurple.shade100,
                  onSelected: (_) => vm.updatePriority(p),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}