import 'package:flutter/material.dart';
import 'package:taskapp/core/utils/constants/app_constants.dart';

import '../../theme/app_color.dart';
import '../../theme/app_text_themes.dart';

class ReuseableFields extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefix, suffix;
  const ReuseableFields({
    super.key,
    required this.controller,
    required this.hintText,  this.prefix,  this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.gray100,
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefix,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintStyle: AppTextThemes.lightTextTheme.bodyMedium,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppConstants.textColor.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppConstants.textColor, width: 1.5),
            ),
          ),
        )
        ,
      ),
    );
  }
}
