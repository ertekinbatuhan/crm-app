import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';
import 'dashboard_content.dart';

class DashboardHomeContent extends StatelessWidget {
  const DashboardHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (viewModel.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                Text(
                  viewModel.errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => viewModel.loadDashboardData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return DashboardContent(
          stats: viewModel.dashboardStats,
          totalAmount: viewModel.totalRevenueFormatted,
          period: viewModel.selectedPeriodLabel,
          pipelineStages: viewModel.pipelineStages,
          notifications: viewModel.recentNotifications,
        );
      },
    );
  }
}