// widgets/save_button.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/views/screens/bottomnav/bottomnav_screen.dart';
import 'package:taskapp/views/screens/home/home_screen.dart';

import '../../../../viewmodels/task_viewmodel.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade400,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: vm.isLoading
                ? null
                : () async {
              if (!vm.isValid) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill title and valid due date")),
                );
                return;
              }

              final success = await vm.saveTask();

              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Task saved successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavScreen())); 
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to save task")),
                );
              }
            },
            child: vm.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Save Task", style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        );
      },
    );
  }
}