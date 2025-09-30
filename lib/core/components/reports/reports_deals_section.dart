import 'package:flutter/material.dart';
import '../../../viewmodels/reports_viewmodel.dart';
import '../../constants/app_constants.dart';

class ReportsDealsSection extends StatelessWidget {
  final ReportsViewModel viewModel;

  const ReportsDealsSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final closedDealsCount = viewModel.closedDeals;
    final totalDealsCount = viewModel.totalDeals;
    final winRate = totalDealsCount > 0 ? closedDealsCount / totalDealsCount : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deals Performance',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: AppSizes.paddingM),
        Row(
          children: [
            Expanded(
              child: _buildPerformanceCard(
                'Closed Deals',
                closedDealsCount.toString(),
                Icons.check_circle,
                AppColors.success,
              ),
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: _buildPerformanceCard(
                'Open Deals',
                (totalDealsCount - closedDealsCount).toString(),
                Icons.schedule,
                AppColors.warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingM),
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: AppDecorations.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Win Rate',
                style: AppTextStyles.cardTitle,
              ),
              const SizedBox(height: AppSizes.paddingS),
              LinearProgressIndicator(
                value: winRate,
                backgroundColor: AppColors.grey200,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
              ),
              const SizedBox(height: AppSizes.paddingS),
              Text(
                '${(winRate * 100).toStringAsFixed(1)}%',
                style: AppTextStyles.statValue.copyWith(fontSize: AppSizes.fontL),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: AppDecorations.card,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingS),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Icon(icon, color: color, size: AppSizes.iconL),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(title, style: AppTextStyles.statTitle),
          const SizedBox(height: AppSizes.paddingXS),
          Text(value, style: AppTextStyles.statValue),
        ],
      ),
    );
  }
}