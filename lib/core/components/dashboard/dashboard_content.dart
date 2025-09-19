import 'package:flutter/material.dart';
import '../../../models/stat_model.dart';
import '../../../models/pipeline_model.dart';
import '../../../models/notification_model.dart';
import 'dashboard_stats_section.dart';
import '../card/sales_pipeline_card.dart';
import '../card/notification_card.dart';

class DashboardContent extends StatelessWidget {
  final List<StatModel> stats;
  final String totalAmount;
  final String period;
  final List<PipelineStage> pipelineStages;
  final List<NotificationModel> notifications;

  const DashboardContent({
    super.key,
    required this.stats,
    required this.totalAmount,
    required this.period,
    required this.pipelineStages,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              DashboardStatsSection(stats: stats),
              
              const SizedBox(height: 24),


              SalesPipelineCard(
                totalAmount: totalAmount,
                period: period,
                stages: pipelineStages,
              ),

              const SizedBox(height: 24),


              NotificationCard(notifications: notifications),

              const SizedBox(height: 100), // Extra space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }
}