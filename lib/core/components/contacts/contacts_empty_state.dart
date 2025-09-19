import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class ContactsEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const ContactsEmptyState({
    super.key,
    this.title = AppStrings.noContactsFound,
    this.subtitle = AppStrings.startByAddingContact,
    this.icon = Icons.people_outline,
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppSizes.iconXL, color: AppColors.grey),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            title,
            style: AppTextStyles.emptyStateTitle.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            subtitle,
            style: AppTextStyles.emptyStateSubtitle.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          if (onActionPressed != null && actionLabel != null) ...[
            const SizedBox(height: AppSizes.paddingL),
            ElevatedButton.icon(
              onPressed: onActionPressed,
              icon: const Icon(Icons.add),
              label: Text(actionLabel!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}