// core/utils/widgets/task/title_text_field.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/task_viewmodel.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_theme_constants.dart';

class TitleTextField extends StatelessWidget {
  const TitleTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Title Field
            TextFormField(
              initialValue: vm.task.title,
              maxLength: 100,
              textCapitalization: TextCapitalization.sentences,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                labelText: "Task title  *",
                hintText: "Enter a clear and meaningful title...",
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                suffixIcon: vm.task.title.isNotEmpty
                    ? Icon(Icons.check_circle_rounded, color: AppColors.success, size: 26)
                    : null,



                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,

                counterText: "", // Hidden counter

                // Borders — fully consistent with your theme
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
                  borderSide: BorderSide(
                    color: AppColors.gray400.withOpacity(0.5),
                    width: AppThemeConstants.borderWidth,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
                  borderSide: BorderSide(
                    color:AppColors.primary,
                    width: AppThemeConstants.borderWidth + 0.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
                  borderSide: BorderSide(color: AppColors.error, width: AppThemeConstants.borderWidth),
                ),

                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              ),
              onChanged: (value) {
                vm.updateTitle(value); // for validation
              },
            ),


          ],
        );
      },
    );
  }
}