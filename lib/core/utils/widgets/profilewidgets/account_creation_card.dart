// core/utils/widgets/edit_profile/account_creation_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_color.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_theme_constants.dart';

class AccountCreationCard extends StatelessWidget {
  final DateTime creationDate;

  const AccountCreationCard({
    super.key,
    required this.creationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
        border: Border.all(
          color: AppColors.gray400.withOpacity(0.3),
          width: AppThemeConstants.borderWidth,
        ),

        boxShadow: [
          BoxShadow(
            color: AppColors.gray900.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            "Account creation date",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          // Date
          Text(
            DateFormat('dd MMMM yyyy').format(creationDate),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}