import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/core/utils/widgets/text_widget.dart';

class ReuseableTextButtons extends StatelessWidget {
  final String text;
  final String clickabletext;
  final VoidCallback callback;
  const ReuseableTextButtons({
    super.key,
    required this.text,
    required this.clickabletext,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(
          text: text,
          txtStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            color: Color(0XFF9C98A1),
          ),
        ),
        SizedBox(width: 5,),
        GestureDetector(
          onTap: callback,
          child: TextWidget(
            text: clickabletext,
            txtStyle: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              color: Color(0XFF6368D9),
            ),
          ),
        ),
      ],
    );
  }
}
