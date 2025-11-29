import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/core/theme/theme.dart';
import 'package:taskapp/core/utils/constants/app_constants.dart';
import 'package:taskapp/core/utils/widgets/text_widget.dart';

class ReuseableButtons extends StatelessWidget {
  final VoidCallback? callback;
  final String text;
  const ReuseableButtons({super.key, this.callback, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: const Color(0XFF828282).withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: AppTextThemes.darkTextTheme.titleMedium,
            ),
          ),
        ),
      ),
    );
  }
}
