import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/task_viewmodel.dart';

class StatusSelector extends StatelessWidget {
   StatusSelector({Key? key}) : super(key: key);

  final List<String> statuses = ['To Do', 'In Progress', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Status", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: statuses.map((s) {
                bool selected = vm.task.status == s;
                return ChoiceChip(
                  label: Text(s),
                  selected: selected,
                  selectedColor: Colors.deepPurple.shade100,
                  onSelected: (_) => vm.updateStatus(s),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}