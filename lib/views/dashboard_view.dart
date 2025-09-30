import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/components/dashboard/dashboard_home_content.dart';
import '../core/components/navigation/custom_bottom_navigation.dart';
import '../core/components/navigation/app_bar_factory.dart';
import 'tasks_view.dart';
import 'contacts_view.dart';
import 'deals_view.dart';
import 'reports_view.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../viewmodels/tasks_viewmodel.dart';

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
        appBar: AppBarFactory.create(
        selectedIndex: selectedNavIndex,
        onContactsAdd: () {
          if (_contactsKey.currentState != null) {
            _contactsKey.currentState!.showAddContactDialog();
          }
        },
        onDealsAdd: () {
          if (_dealsKey.currentState != null) {
            _dealsKey.currentState!.showAddDealDialog();
          }
        },
        onTasksAdd: () {
          if (mounted) {
            context.read<TasksViewModel>().showAddTaskDialog(context);
          }
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: selectedNavIndex,
              children: [
                const DashboardHomeContent(),
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
}
