// core/utils/widgets/task/description_text_field.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/task_viewmodel.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_theme_constants.dart';

class DescriptionTextField extends StatelessWidget {
  const DescriptionTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {
        return TextFormField(
          initialValue: vm.task.description ?? '',
          maxLength: 500,
          maxLines: null,
          minLines: 4,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            labelText: "Description",
            hintText: "Add more details about your task...",
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              fontWeight: FontWeight.w400,
            ),
            counterText: "${(vm.task.description?.length ?? 0)}/500",
            counterStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),


            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,


            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius + 13),
              borderSide: BorderSide(
                color: AppColors.gray400.withOpacity(0.5),
                width: AppThemeConstants.borderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius + 13),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: AppThemeConstants.borderWidth,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
              borderSide: BorderSide(color: AppColors.error, width: AppThemeConstants.borderWidth),
            ),

            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
          onChanged: vm.updateDescription,
        );
      },
    );
  }
}