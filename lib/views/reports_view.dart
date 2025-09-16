import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/reports_viewmodel.dart';
import '../core/components/layout/page_container.dart';
import '../core/components/layout/empty_state.dart';
import '../core/components/cards/report_card.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

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
        return Scaffold(
          body: PageContainer(
            scrollable: false,
            child: CustomScrollView(
              slivers: [
                // Period Filter Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: _buildPeriodFilter(viewModel),
                  ),
                ),
                
                // Spacing
                SliverToBoxAdapter(
                  child: AppSpacing.gapV4,
                ),
                
                // Loading State
                if (viewModel.isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                
                // Error State
                if (viewModel.hasError && !viewModel.isLoading)
                  SliverFillRemaining(
                    child: EmptyState.error(
                      message: viewModel.errorMessage ?? 'Failed to load reports',
                      onRetry: viewModel.loadReportsData,
                    ),
                  ),
                
                // Reports Content
                if (!viewModel.isLoading && !viewModel.hasError) ..._buildReportSections(viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  // New methods for redesigned reports view
  Widget _buildPeriodFilter(ReportsViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Reports',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: AppSpacing.borderRadiusS,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: viewModel.selectedPeriod,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  viewModel.changePeriod(newValue);
                }
              },
              items: <String>['This Month', 'Last Month', 'This Year']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildReportSections(ReportsViewModel viewModel) {
    return [
      // Key Metrics Section
      SliverToBoxAdapter(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: MetricsCard(
            metrics: _getMetrics(viewModel),
            onTap: () => print('Metrics card tapped'),
          ),
        ),
      ),
      
      // Spacing
      SliverToBoxAdapter(
        child: AppSpacing.gapV4,
      ),
      
      // Revenue Overview Section
      SliverToBoxAdapter(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: RevenueCard(
            totalRevenue: viewModel.totalRevenue,
            breakdown: _getRevenueBreakdown(viewModel),
            onTap: () => print('Revenue card tapped'),
            onMorePressed: () => print('Revenue more pressed'),
          ),
        ),
      ),
      
      // Spacing
      SliverToBoxAdapter(
        child: AppSpacing.gapV4,
      ),
      
      // Deals by Status Section
      SliverToBoxAdapter(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: DealsStatusCard(
            dealsByStatus: viewModel.dealsByStatus,
            onTap: () => print('Deals status card tapped'),
          ),
        ),
      ),
      
      // Spacing
      SliverToBoxAdapter(
        child: AppSpacing.gapV4,
      ),
      
      // Performance Metrics Section
      SliverToBoxAdapter(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: PerformanceCard(
            metrics: _getPerformanceMetrics(viewModel),
            onTap: () => print('Performance card tapped'),
          ),
        ),
      ),
      
      // Bottom spacing
      SliverToBoxAdapter(
        child: AppSpacing.gapV6,
      ),
    ];
  }

  // Helper methods to create report data
  List<MetricItem> _getMetrics(ReportsViewModel viewModel) {
    return [
      MetricItem(
        label: 'Total Revenue',
        value: _formatCurrency(viewModel.totalRevenue),
        icon: Icons.attach_money,
        color: AppColors.success,
        trend: const MetricTrend(percentage: '+12.5%', isPositive: true),
      ),
      MetricItem(
        label: 'Total Deals',
        value: viewModel.totalDeals.toString(),
        icon: Icons.handshake,
        color: AppColors.warning,
        trend: const MetricTrend(percentage: '+8.3%', isPositive: true),
      ),
      MetricItem(
        label: 'Total Contacts',
        value: viewModel.totalContacts.toString(),
        icon: Icons.people,
        color: AppColors.info,
        trend: const MetricTrend(percentage: '+15.2%', isPositive: true),
      ),
      MetricItem(
        label: 'Total Tasks',
        value: viewModel.totalTasks.toString(),
        icon: Icons.task_alt,
        color: AppColors.secondary500,
        trend: const MetricTrend(percentage: '-2.1%', isPositive: false),
      ),
    ];
  }

  List<RevenueBreakdown> _getRevenueBreakdown(ReportsViewModel viewModel) {
    return [
      RevenueBreakdown(
        label: 'Closed',
        amount: _formatCurrency(viewModel.totalRevenue),
        color: AppColors.success,
      ),
      RevenueBreakdown(
        label: 'Prospect',
        amount: _formatCurrency(viewModel.pendingRevenue),
        color: AppColors.warning,
      ),
      RevenueBreakdown(
        label: 'Negotiation',
        amount: _formatCurrency(viewModel.negotiationRevenue),
        color: AppColors.info,
      ),
    ];
  }

  List<PerformanceMetric> _getPerformanceMetrics(ReportsViewModel viewModel) {
    return [
      PerformanceMetric(
        label: 'Deal Conversion Rate',
        subtitle: 'Percentage of leads converted to deals',
        value: '${viewModel.dealConversionRate.toStringAsFixed(1)}%',
        target: '75%',
      ),
      PerformanceMetric(
        label: 'Task Completion Rate',
        subtitle: 'Percentage of tasks completed on time',
        value: '${viewModel.taskCompletionRate.toStringAsFixed(1)}%',
        target: '90%',
      ),
      PerformanceMetric(
        label: 'Average Deal Size',
        subtitle: 'Average value per closed deal',
        value: _formatCurrency(viewModel.totalRevenue / (viewModel.totalDeals > 0 ? viewModel.totalDeals : 1)),
      ),
      PerformanceMetric(
        label: 'Sales Cycle Length',
        subtitle: 'Average days from lead to close',
        value: '28 days',
        target: '21 days',
      ),
    ];
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${amount.toStringAsFixed(0)}';
    }
  }
}
