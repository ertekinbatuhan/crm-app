import 'package:flutter/material.dart';
import '../../../viewmodels/reports_viewmodel.dart';
import '../../constants/app_constants.dart';
import '../common/generic_metric_card.dart';

class ReportsKeyMetrics extends StatelessWidget {
  final ReportsViewModel viewModel;

  const ReportsKeyMetrics({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Metrics',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: AppSizes.paddingM),
        Row(
          children: [
            Expanded(
              child: GenericMetricCard.dashboard(
                title: 'Total Revenue',
                value: '\$${viewModel.totalRevenue.toStringAsFixed(0)}',
                icon: Icons.attach_money,
                iconColor: AppColors.success,
              ),
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: GenericMetricCard.dashboard(
                title: 'Total Deals',
                value: viewModel.totalDeals.toString(),
                icon: Icons.handshake,
                iconColor: AppColors.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingM),
        Row(
          children: [
            Expanded(
              child: GenericMetricCard.dashboard(
                title: 'Total Contacts',
                value: viewModel.totalContacts.toString(),
                icon: Icons.people,
                iconColor: AppColors.info,
              ),
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: GenericMetricCard.dashboard(
                title: 'Total Tasks',
                value: viewModel.totalTasks.toString(),
                icon: Icons.task,
                iconColor: AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }
}