import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/task_viewmodel.dart';

class DueDateTimePicker extends StatelessWidget {
  const DueDateTimePicker({super.key});

  String formatTime(DateTime t) {
    String hour = t.hour.toString().padLeft(2, '0');
    String minute = t.minute.toString().padLeft(2, '0');
    String ampm = t.hour >= 12 ? 'pm' : 'am';
    return "$hour.$minute $ampm";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {
        return Column(
          children: [
            InkWell(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime:
                  TimeOfDay.fromDateTime(vm.task.startTime),
                );

                if (time != null) {
                  vm.updateStartTime(DateTime(
                    vm.task.startTime.year,
                    vm.task.startTime.month,
                    vm.task.startTime.day,
                    time.hour,
                    time.minute,
                  ));
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Start Time",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                child: Text(formatTime(vm.task.startTime)),
              ),
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(vm.task.endTime),
                );
                if (time != null) {
                  vm.updateEndTime(DateTime(
                    vm.task.endTime.year,
                    vm.task.endTime.month,
                    vm.task.endTime.day,
                    time.hour,
                    time.minute,
                  ));
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "End Time",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                child: Text(formatTime(vm.task.endTime)),
              ),
            ),
          ],
        );
      },
    );
  }
}
