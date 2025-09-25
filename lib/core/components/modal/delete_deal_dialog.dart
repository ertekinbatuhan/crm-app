import 'package:flutter/material.dart';
import '../../../models/deal_model.dart';
import '../../../viewmodels/deals_viewmodel.dart';
import '../../constants/app_constants.dart';

class DeleteDealDialog extends StatelessWidget {
  final DealsViewModel viewModel;
  final Deal deal;

  const DeleteDealDialog({
    super.key,
    required this.viewModel,
    required this.deal,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      title: Text(
        AppStrings.deleteDeal,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
      ),
      content: Text(
        'Are you sure you want to delete "${deal.title}"? This action cannot be undone.',
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.grey600,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingL,
              vertical: AppSizes.paddingM,
            ),
          ),
          child: Text(
            AppStrings.cancel,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            await viewModel.deleteDeal(deal.id);
            // Real-time stream will automatically update the UI
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red600,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingL,
              vertical: AppSizes.paddingM,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
          ),
          child: Text(
            AppStrings.delete,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}