import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/stat_model.dart';
import '../models/pipeline_model.dart';
import '../models/notification_model.dart';
import '../core/components/dashboard/dashboard_content.dart';
import '../core/components/navigation/custom_bottom_navigation.dart';
import 'tasks_view.dart';
import 'contacts_view.dart';
import 'deals_view.dart';
import 'reports_view.dart';
import '../viewmodels/dashboard_viewmodel.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int selectedNavIndex = 0;
  final GlobalKey<ContactsViewWidgetState> _contactsKey = GlobalKey();
  final GlobalKey<DealsViewWidgetState> _dealsKey = GlobalKey();
  final GlobalKey<TasksViewState> _tasksKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DashboardViewModel>().loadDashboardData();
    });
  }

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
                TasksView(key: _tasksKey),
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

    if (selectedNavIndex == 3) {
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
              _tasksKey.currentState?.showAddTaskDialog();
            },
            icon: const Icon(Icons.add),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
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
