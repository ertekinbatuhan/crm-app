import 'package:flutter/material.dart';
import '../../../viewmodels/reports_viewmodel.dart';
import '../../constants/app_constants.dart';

class ReportsPerformanceSection extends StatelessWidget {
  final ReportsViewModel viewModel;

  const ReportsPerformanceSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final avgDealSize = viewModel.totalDeals > 0 
        ? viewModel.totalRevenue / viewModel.totalDeals 
        : 0.0;
    final conversionRate = viewModel.dealConversionRate / 100;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Insights',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: AppSizes.paddingM),
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: AppDecorations.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.insights,
                    color: AppColors.primary,
                    size: AppSizes.iconM,
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Text(
                    'Key Insights',
                    style: AppTextStyles.cardTitle,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
              _buildInsightItem(
                'Best performing period',
                viewModel.selectedPeriod,
                Icons.calendar_month,
                AppColors.success,
              ),
              const SizedBox(height: AppSizes.paddingS),
              _buildInsightItem(
                'Average deal size',
                '\$${avgDealSize.toStringAsFixed(0)}',
                Icons.monetization_on,
                AppColors.accent,
              ),
              const SizedBox(height: AppSizes.paddingS),
              _buildInsightItem(
                'Conversion rate',
                '${(conversionRate * 100).toStringAsFixed(1)}%',
                Icons.trending_up,
                AppColors.info,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingXS),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusS),
          ),
          child: Icon(icon, color: color, size: AppSizes.iconS),
        ),
        const SizedBox(width: AppSizes.paddingM),
        Expanded(
          child: Text(title, style: AppTextStyles.bodyMedium),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}