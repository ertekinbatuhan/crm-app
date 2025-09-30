import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class DealsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  
  const DealsErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: AppSizes.iconXL,
            color: AppColors.red,
          ),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            'Error: $message',
            style: AppTextStyles.errorMessage,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.paddingM),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
            child: const Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }
}