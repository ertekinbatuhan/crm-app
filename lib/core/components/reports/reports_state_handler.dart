import 'package:flutter/material.dart';
import '../../../viewmodels/reports_viewmodel.dart';
import '../../constants/app_constants.dart';

class ReportsStateHandler extends StatelessWidget {
  final ReportsViewModel viewModel;
  final Widget child;

  const ReportsStateHandler({
    super.key,
    required this.viewModel,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'Loading reports...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      );
    }

    if (viewModel.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppSizes.iconXL,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'Error: ${viewModel.errorMessage}',
              style: AppTextStyles.errorMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingM),
            ElevatedButton(
              onPressed: () => viewModel.loadReportsData(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingL,
                  vertical: AppSizes.paddingM,
                ),
              ),
              child: Text(
                'Retry',
                style: AppTextStyles.buttonMedium,
              ),
            ),
          ],
        ),
      );
    }

    return child;
  }
}