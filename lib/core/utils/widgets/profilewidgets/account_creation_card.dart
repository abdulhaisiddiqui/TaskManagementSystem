// core/utils/widgets/edit_profile/account_creation_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountCreationCard extends StatelessWidget {
  final DateTime creationDate;

  const AccountCreationCard({super.key, required this.creationDate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Account creation date", style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(
            DateFormat('dd MMMM yyyy').format(creationDate),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}