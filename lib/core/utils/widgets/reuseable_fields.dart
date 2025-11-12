import 'package:flutter/material.dart';
import 'package:taskapp/core/utils/constants/app_constants.dart';

class ReuseableFields extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const ReuseableFields({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color(0XFFD1D0F9).withOpacity(0.6),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.only(left: 20),
            hintStyle: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.normal,
              color: Color(0XFF6368D9).withOpacity(0.8),
              letterSpacing: 2,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
