import 'package:flutter/material.dart';
import '../models/stat_model.dart';
import '../models/pipeline_model.dart';
import '../models/notification_model.dart';
import '../core/components/dashboard/dashboard_content.dart';
import '../core/components/navigation/custom_bottom_navigation.dart';
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
  int selectedNavIndex = 0;
  final GlobalKey<ContactsViewWidgetState> _contactsKey = GlobalKey();
  final GlobalKey<DealsViewWidgetState> _dealsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: selectedNavIndex,
              children: [
                _buildHomeView(),
                ContactsView(key: _contactsKey),
                DealsView(key: _dealsKey),
                const TasksView(),
                const ReportsView(),
              ],
            ),
          ),
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
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final titles = ['Dashboard', 'Contacts', 'Deals', 'Tasks', 'Reports'];

    // Contacts AppBar with green FAB
    if (selectedNavIndex == 1) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          titles[selectedNavIndex],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_contactsKey.currentState != null) {
                _contactsKey.currentState!.showAddContactDialog();
              }
            },
            icon: const Icon(Icons.add),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF34C759),
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
        ],
      );
    }

    // Deals AppBar with orange FAB
    if (selectedNavIndex == 2) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          titles[selectedNavIndex],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_dealsKey.currentState != null) {
                _dealsKey.currentState!.showAddDealDialog();
              }
            },
            icon: const Icon(Icons.add),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFFF9500),
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
        ],
      );
    }

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        titles[selectedNavIndex],
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHomeView() {
    return DashboardContent(
      stats: [
        StatModel(
          title: 'Leads',
          value: '120',
          change: '+10%',
          isPositive: true,
        ),
        StatModel(
          title: 'Deals',
          value: '45',
          change: '+5%',
          isPositive: false,
        ),
      ],
      totalAmount: '\$250K',
      period: 'Current Quarter',
      pipelineStages: [
        PipelineStage(name: 'Prospecting', progress: 0.8),
        PipelineStage(name: 'Qualification', progress: 0.6),
        PipelineStage(name: 'Proposal', progress: 0.4),
        PipelineStage(name: 'Negotiation', progress: 0.2),
        PipelineStage(name: 'Closed', progress: 0.1),
      ],
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
    );
  }
}
