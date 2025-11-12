import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final TextStyle txtStyle;
  const TextWidget ({super.key,required this.text,required this.txtStyle});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: txtStyle,textAlign: TextAlign.center,);
  }
}
