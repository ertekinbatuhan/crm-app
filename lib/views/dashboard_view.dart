import 'package:flutter/material.dart';
import '../core/components/layout/app_scaffold.dart';
import '../core/components/layout/page_container.dart';
import '../core/components/navigation/bottom_nav_bar.dart';
import '../core/components/cards/stat_card.dart';
import '../core/components/cards/pipeline_card.dart';
import '../core/components/cards/activity_card.dart';
import '../core/theme/app_spacing.dart';
import 'tasks_view.dart';
import 'contacts_view.dart';
import 'deals_view.dart';
import 'reports_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _DashboardContent(),
    const ContactsView(),
    const DealsView(),
    const TasksView(),
    const ReportsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final titles = ['Dashboard', 'Contacts', 'Deals', 'Tasks', 'Reports'];
    
    return AppScaffold(
      title: titles[_currentIndex],
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar.crm(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// Dashboard content implementation using new component system
class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    // For now using static data - will be replaced with ViewModel later
    return PageContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Section
            _buildStatsGrid(),
            AppSpacing.gapV6,
            
            // Pipeline Section
            PipelineCard.sales(
              stages: _getMockPipelineStages(),
              onMorePressed: () {
                // Handle pipeline more action
                print('View pipeline details');
              },
            ),
            AppSpacing.gapV6,
            
            // Activity Section
            ActivityCard.recent(
              activities: _getMockActivities(),
              onViewAll: () {
                // Navigate to all activities
                print('View all activities');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: AppSpacing.sp4,
      mainAxisSpacing: AppSpacing.sp4,
      children: [
        StatCard.contacts(
          value: '1,234',
          change: '+12',
          isPositive: true,
          onTap: () => print('Contacts stat pressed'),
        ),
        StatCard.deals(
          value: '89',
          change: '+5',
          isPositive: true,
          onTap: () => print('Deals stat pressed'),
        ),
        StatCard.revenue(
          value: '\$124,500',
          change: '+8.2%',
          isPositive: true,
          onTap: () => print('Revenue stat pressed'),
        ),
        StatCard.tasks(
          value: '23',
          change: '-3',
          isPositive: false,
          onTap: () => print('Tasks stat pressed'),
        ),
      ],
    );
  }

  List<PipelineStageData> _getMockPipelineStages() {
    return [
      const PipelineStageData(
        name: 'Lead',
        value: '45 (\$125k)',
        progress: 0.85,
      ),
      const PipelineStageData(
        name: 'Prospect',
        value: '32 (\$98k)',
        progress: 0.65,
      ),
      const PipelineStageData(
        name: 'Proposal',
        value: '18 (\$76k)',
        progress: 0.45,
      ),
      const PipelineStageData(
        name: 'Negotiation',
        value: '12 (\$54k)',
        progress: 0.25,
      ),
      const PipelineStageData(
        name: 'Closed Won',
        value: '8 (\$32k)',
        progress: 0.15,
      ),
    ];
  }

  List<ActivityData> _getMockActivities() {
    return [
      ActivityData(
        icon: Icons.person_add,
        title: 'New contact added',
        subtitle: 'John Smith from ABC Corp',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        onTap: () => print('Contact activity tapped'),
      ),
      ActivityData(
        icon: Icons.handshake,
        title: 'Deal updated',
        subtitle: 'Project Phoenix moved to negotiation',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        onTap: () => print('Deal activity tapped'),
      ),
      ActivityData(
        icon: Icons.task,
        title: 'Task completed',
        subtitle: 'Follow up call with Sarah Wilson',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        onTap: () => print('Task activity tapped'),
      ),
      ActivityData(
        icon: Icons.meeting_room,
        title: 'Meeting scheduled',
        subtitle: 'Product demo with Tech Solutions Inc',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        onTap: () => print('Meeting activity tapped'),
      ),
    ];
  }
}
