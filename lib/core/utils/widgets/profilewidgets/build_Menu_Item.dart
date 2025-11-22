// core/utils/widgets/build_menu_item.dart (ya jahan bhi hai)
import 'package:flutter/material.dart';

import '../../../theme/app_color.dart';
import '../../../theme/app_theme_constants.dart';

class BuildMenuItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback? callback;
  final bool isLogout;

  const BuildMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isLogout,
    this.callback,
  });

  @override
  State<BuildMenuItem> createState() => _BuildMenuItemState();
}

class _BuildMenuItemState extends State<BuildMenuItem> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;


    final Color backgroundColor = widget.isLogout
        ? (isDark ? AppColors.purple.withOpacity(0.2) : const Color(0xFFF5F0FF))
        : Theme.of(context).colorScheme.surface;

    final Color borderColor = widget.isLogout
        ? AppColors.purple.withOpacity(0.4)
        : AppColors.gray300;

    final Color iconAndTextColor = widget.isLogout
        ? AppColors.purple
        : Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: widget.callback,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
          border: Border.all(
            color: borderColor,
            width: AppThemeConstants.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              color: iconAndTextColor,
              size: 26,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: iconAndTextColor,
                  fontWeight: widget.isLogout ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ),

            if (!widget.isLogout)
              Icon(
                Icons.chevron_right,
                color: AppColors.gray500,
                size: 28,
              ),
          ],
        ),
      ),
    );

  }
}