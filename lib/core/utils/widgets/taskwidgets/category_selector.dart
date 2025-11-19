import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/task_viewmodel.dart';

class CategorySelector extends StatelessWidget {
   CategorySelector({Key? key}) : super(key: key);

  final List<String> categories = ['Personal', 'Work', 'Study', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Category", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: categories.map((c) {
                bool selected = vm.task.category == c;
                return ChoiceChip(
                  label: Text(c),
                  selected: selected,
                  selectedColor: Colors.deepPurple.shade100,
                  onSelected: (_) => vm.updateCategory(c),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}