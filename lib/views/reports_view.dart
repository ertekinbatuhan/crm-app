import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/reports_viewmodel.dart';
import '../core/constants/app_constants.dart';
import '../core/components/reports/reports_state_handler.dart';
import '../core/components/reports/reports_header.dart';
import '../core/components/reports/reports_key_metrics.dart';
import '../core/components/reports/reports_revenue_section.dart';
import '../core/components/reports/reports_deals_section.dart';
import '../core/components/reports/reports_performance_section.dart';

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
          ReportsHeader(viewModel: viewModel),
          const SizedBox(height: AppSizes.paddingL),
          ReportsKeyMetrics(viewModel: viewModel),
          const SizedBox(height: AppSizes.paddingL),
          ReportsRevenueSection(viewModel: viewModel),
          const SizedBox(height: AppSizes.paddingL),
          ReportsDealsSection(viewModel: viewModel),
          const SizedBox(height: AppSizes.paddingL),
          ReportsPerformanceSection(viewModel: viewModel),
        ],
      ),
    );
  }
}