import 'package:flutter/material.dart';
import '../../../viewmodels/reports_viewmodel.dart';
import '../../constants/app_constants.dart';

class ReportsRevenueSection extends StatelessWidget {
  final ReportsViewModel viewModel;

  const ReportsRevenueSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Revenue Overview',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: AppSizes.paddingM),
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: AppDecorations.card,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Monthly Revenue',
                    style: AppTextStyles.cardTitle,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM,
                      vertical: AppSizes.paddingXS,
                    ),
                    decoration: AppDecorations.statusOpen,
                    child: Text(
                      '+12.5%',
                      style: AppTextStyles.chipText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingL),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                ),
                child: Center(
                  child: Text(
                    'Revenue Chart Placeholder',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}