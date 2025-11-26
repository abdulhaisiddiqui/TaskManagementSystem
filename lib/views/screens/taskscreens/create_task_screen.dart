import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/core/theme/theme.dart';
import 'package:taskapp/views/screens/bottomnav/bottomnav_screen.dart';
import 'package:taskapp/views/screens/home/home_screen.dart';

import '../../../core/utils/widgets/taskwidgets/category_selector.dart';
import '../../../core/utils/widgets/taskwidgets/description_textfield.dart';
import '../../../core/utils/widgets/taskwidgets/due_datetime_picker.dart';
import '../../../core/utils/widgets/taskwidgets/priority_selector.dart';
import '../../../core/utils/widgets/taskwidgets/save_button.dart';
import '../../../core/utils/widgets/taskwidgets/status_selector.dart';
import '../../../core/utils/widgets/taskwidgets/title_textfield.dart';
import '../../../data/models/task_model.dart';
import '../../../viewmodels/task_viewmodel.dart';

class CreateTaskScreen extends StatelessWidget {
  final TaskModel? existingTask;

  const CreateTaskScreen({Key? key, this.existingTask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = TaskViewModel();
        vm.initializeTask(existingTask);
        return vm;
      },
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context)
          ),
          title: const Text("Create task", style: TextStyle(color: Colors.black)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const TitleTextField(),
              const SizedBox(height: 20),
              const DescriptionTextField(),
              const SizedBox(height: 20),
              const DueDateTimePicker(),
              const SizedBox(height: 20),
              PrioritySelector(),
              const SizedBox(height: 20),
              CategorySelector(),
              const SizedBox(height: 20),
              StatusSelector(),
              const SizedBox(height: 40),
              const SaveButton(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}