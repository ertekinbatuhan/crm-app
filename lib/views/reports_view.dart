import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/reports_viewmodel.dart';
import '../core/constants/app_constants.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportsViewModel>().loadReportsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportsViewModel>(
      builder: (context, viewModel, child) {
        return ReportsStateHandler(
          viewModel: viewModel,
          child: _buildContent(viewModel),
        );
      },
    );
  }

  Widget _buildContent(ReportsViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(viewModel),
          const SizedBox(height: AppSizes.paddingL),
          _buildKeyMetrics(viewModel),
          const SizedBox(height: AppSizes.paddingL),
          _buildRevenueSection(viewModel),
          const SizedBox(height: AppSizes.paddingL),
          _buildDealsSection(viewModel),
          const SizedBox(height: AppSizes.paddingL),
          _buildPerformanceSection(viewModel),
        ],
      ),
    );
  }

  Widget _buildHeader(ReportsViewModel viewModel) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingS),
          decoration: AppDecorations.chip.copyWith(
            color: AppColors.accent.withOpacity(0.1),
          ),
          child: Icon(
            Icons.bar_chart,
            color: AppColors.accent,
            size: AppSizes.iconM,
          ),
        ),
        const SizedBox(width: AppSizes.paddingM),
        Text(
          'Reports',
          style: AppTextStyles.h2,
        ),
        const Spacer(),
        _buildPeriodDropdown(viewModel),
      ],
    );
  }

  Widget _buildPeriodDropdown(ReportsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      decoration: AppDecorations.input,
      child: DropdownButton<String>(
        value: viewModel.selectedPeriod,
        onChanged: (String? newValue) {
          if (newValue != null) {
            viewModel.changePeriod(newValue);
          }
        },
        underline: const SizedBox(),
        style: AppTextStyles.bodyMedium,
        items: <String>['This Month', 'Last Month', 'This Year']
            .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
            .toList(),
      ),
    );
  }

  Widget _buildKeyMetrics(ReportsViewModel viewModel) {
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
              child: _buildMetricCard(
                'Total Revenue',
                '\$${viewModel.totalRevenue.toStringAsFixed(0)}',
                Icons.attach_money,
                AppColors.success,
              ),
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: _buildMetricCard(
                'Total Deals',
                viewModel.totalDeals.toString(),
                Icons.handshake,
                AppColors.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingM),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Contacts',
                viewModel.totalContacts.toString(),
                Icons.people,
                AppColors.info,
              ),
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: _buildMetricCard(
                'Total Tasks',
                viewModel.totalTasks.toString(),
                Icons.task,
                AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSizes.iconM),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingXS),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: color,
                  size: AppSizes.iconS,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(title, style: AppTextStyles.statTitle),
          const SizedBox(height: AppSizes.paddingXS),
          Text(value, style: AppTextStyles.statValue),
        ],
      ),
    );
  }

  Widget _buildRevenueSection(ReportsViewModel viewModel) {
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

  Widget _buildDealsSection(ReportsViewModel viewModel) {
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

  Widget _buildPerformanceSection(ReportsViewModel viewModel) {
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

// ReportsStateHandler class for consistent state handling
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