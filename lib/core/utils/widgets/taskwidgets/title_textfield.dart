import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/task_viewmodel.dart';

class TitleTextField extends StatelessWidget {
  const TitleTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {
        return TextFormField(
          initialValue: vm.task.title,
          maxLength: 100,
          decoration: const InputDecoration(
            labelText: "Task title *",
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            counterText: "",
          ),
          onChanged: vm.updateTitle,
        );
      },
    );
  }
}