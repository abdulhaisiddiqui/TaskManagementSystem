import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_color.dart';
import '../../../theme/app_theme_constants.dart';

class BuildMenuItem extends StatefulWidget {
  final IconData icon;

  final String title;
  final VoidCallback? callback;
   final bool isLogout;
   BuildMenuItem({super.key,required this.icon, required this.title, required this.isLogout, this.callback});


  @override
  State<BuildMenuItem> createState() => _BuildMenuItemState();

}

class _BuildMenuItemState extends State<BuildMenuItem> {


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: widget.isLogout ? const Color(0xFFE8E1FF) : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Row(
        children: [
          Icon(
              widget.icon,
              color: widget.isLogout ? const Color(0xFF6B4EFF) : Colors.grey.shade700),
          const SizedBox(width: 16),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              color: widget.isLogout ? const Color(0xFF6B4EFF) : Colors.black87,
              fontWeight: widget.isLogout ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
