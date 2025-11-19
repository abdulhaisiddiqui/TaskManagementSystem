import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/core/theme/theme.dart';
import 'package:taskapp/core/utils/constants/app_constants.dart';
import 'package:taskapp/core/utils/widgets/text_widget.dart';

class ReuseableButtons extends StatelessWidget {
  final VoidCallback? callback;
  final String text;
  const ReuseableButtons({super.key, this.callback,required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.withOpacity(0.6),
              borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
              border: null,
              boxShadow: [
                BoxShadow(
                  color: Color(0XFF828282).withOpacity(0.5), // Shadow color with opacity
                  spreadRadius: 1, // Spread value
                  blurRadius: 2, // Blur value
                  offset: Offset(2, 2), // Offset (horizontal, vertical)
                ),
              ],
            ),
            child: Center(
              child: Text(
                  text,
                  style: AppTextThemes.darkTextTheme.titleMedium
              ),
            ),
          )
      ),
    );
  }
}
