import 'package:flutter/material.dart';

class BuildSocialIcon extends StatelessWidget {
  final Widget icon;
  final VoidCallback? callback;
  const BuildSocialIcon({super.key,required this.icon,required this.callback});

  @override
  Widget build(BuildContext context) {
      return InkWell(
        onTap: callback,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(child: icon),
        ),
      );
  }
}
