import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class ContactsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const ContactsErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppSizes.iconXL, color: AppColors.red),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            AppStrings.somethingWentWrong,
            style: AppTextStyles.errorTitle,
          ),
          const SizedBox(height: AppSizes.paddingS),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingXL),
            child: Text(
              message,
              style: AppTextStyles.errorMessage.copyWith(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSizes.paddingL),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.tryAgain),
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