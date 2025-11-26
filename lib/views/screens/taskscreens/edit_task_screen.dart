// lib/views/screens/taskscreens/edit_task_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/core/theme/app_color.dart';
import 'package:taskapp/data/models/task_model.dart';
import 'package:taskapp/viewmodels/task_viewmodel.dart';

import '../../../core/utils/widgets/custom_snackbar.dart';
import '../../../core/utils/widgets/taskwidgets/custom_dropdown.dart';
import '../../../core/utils/widgets/taskwidgets/custom_text_fields.dart';
import '../../../core/utils/widgets/taskwidgets/date_time_card.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;

  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  bool isInitialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInitialized) {
      final vm = Provider.of<TaskViewModel>(context, listen: false);
      vm.initializeTask(widget.task);
      isInitialized = true;
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Edit Task", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),


        actions: [
          Consumer<TaskViewModel>(
            builder: (context, vm, child) {
              return TextButton(
                onPressed: vm.isLoading ? null : () async {
                  final success = await vm.saveTask();
                  if (success && context.mounted) {
                    CustomSnackBar.success(message: "Task updated!", context: context);

                    Navigator.pop(context);
                  }
                },
                child: vm.isLoading
                    ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text("Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6C63FF))),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<TaskViewModel>(
          builder: (context, vm, child) {
            final task = vm.task;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  CustomTextField(
                    label: "Task Title",
                    initialValue: task.title,
                    icon: Icons.title_rounded,
                    onChanged: vm.updateTitle,
                  ),
                  const SizedBox(height: 20),


                  CustomTextField(
                    label: "Description (Optional)",
                    initialValue: task.description ?? '',
                    icon: Icons.description_rounded,
                    maxLines: 5,
                    onChanged: vm.updateDescription,
                  ),
                  const SizedBox(height: 28),


                  Row(
                    children: [
                      Expanded(
                        child: DateTimeCard(
                          label: "Date (read-only)",
                          icon: Icons.calendar_today_rounded,
                          value: DateFormat('dd MMM yyyy').format(task.startTime),
                          onTap: (){},
                        ),

                      ),


                    ],
                  ),
                  const SizedBox(height: 16),

                  Column(
                    children: [
                      DateTimeCard(
                        label: "Start Time",
                        icon: Icons.access_time_rounded,
                        value: DateFormat('hh:mm a').format(task.startTime),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(task.startTime),
                          );
                          if (time != null) {
                            vm.updateStartTime(DateTime(
                              task.startTime.year,
                              task.startTime.month,
                              task.startTime.day,
                              time.hour,
                              time.minute,
                            ));
                          }
                        },
                      ),
                      SizedBox(height: 16,),
                      DateTimeCard(
                        label: "End Time",
                        icon: Icons.access_time_filled_rounded,
                        value: DateFormat('hh:mm a').format(task.endTime),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(task.endTime),
                          );
                          if (time != null) {
                            vm.updateEndTime(DateTime(
                              task.endTime.year,
                              task.endTime.month,
                              task.endTime.day,
                              time.hour,
                              time.minute,
                            ));
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Priority & Category
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          label: "Priority",
                          value: task.priority,
                          items: const ['High', 'Medium', 'Low'],
                          onChanged: (val) => vm.updatePriority(val!), // ← val String? hai
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomDropdown(
                          label: "Category",
                          value: task.category,
                          items: const ['Personal', 'Work', 'Study', 'Other'],
                          onChanged: (val) => vm.updateCategory(val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  CustomDropdown(
                    label: "Status",
                    value: task.status,
                    items: const ['To Do', 'In Progress', 'Completed'],
                    onChanged: (val) => vm.updateStatus(val!),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}