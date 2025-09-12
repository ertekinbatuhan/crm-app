import 'package:flutter/material.dart';
import '../../../shared/models/stat_model.dart';
import '../../../shared/models/pipeline_model.dart';
import '../../../shared/models/notification_model.dart';
import '../../../core/components/card/stat_card.dart';
import '../../../core/components/card/sales_pipeline_card.dart';
import '../../../core/components/card/notification_card.dart';
import '../../../core/components/navigation/custom_bottom_navigation.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Dashboard',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.black,size: 24),
          onPressed: () {
            // Settings action
            print('Settings pressed');
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.grey[50],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      statModel: StatModel(
                        title: 'Leads',
                        value: '120',
                        change: '+10%',
                        isPositive: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      statModel: StatModel(
                        title: 'Deals',
                        value: '45',
                        change: '+5%',
                        isPositive: false,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Sales Pipeline
              SalesPipelineCard(
                totalAmount: '\$250K',
                period: 'Current Quarter',
                stages: [
                  PipelineStage(name: 'Prospecting', progress: 0.8),
                  PipelineStage(name: 'Qualification', progress: 0.6),
                  PipelineStage(name: 'Proposal', progress: 0.4),
                  PipelineStage(name: 'Negotiation', progress: 0.2),
                  PipelineStage(name: 'Closed', progress: 0.1),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Notifications
              NotificationCard(
                notifications: [
                  NotificationModel(
                    title: 'Ethan Carter',
                    subtitle: 'New lead from website',
                    avatar: 'E',
                  ),
                  NotificationModel(
                    title: 'Project Phoenix',
                    subtitle: 'Deal in negotiation stage',
                    avatar: 'P',
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Bottom Navigation
              CustomBottomNavigation(
                selectedIndex: selectedNavIndex,
                onItemSelected: (index) {
                  setState(() {
                    selectedNavIndex = index;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
