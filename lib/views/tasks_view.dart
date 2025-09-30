import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/tasks_viewmodel.dart';
import '../core/components/tasks/tasks_calendar_header.dart';
import '../core/components/tasks/tasks_content.dart';
import '../core/components/view_state_handler.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  TasksViewState createState() => TasksViewState();
}

class TasksViewState extends State<TasksView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TasksViewModel>().loadTasksData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SafeArea(
            child: ViewStateHandler<TasksViewModel>(
              state: viewModel.viewState,
              data: viewModel,
              successBuilder: (viewModel) => _buildMainView(viewModel),
              loadingMessage: 'Loading tasks...',
              errorMessage: viewModel.errorMessage,
              onRetry: () => viewModel.loadTasksData(),
              emptyTitle: 'No tasks found',
              emptySubtitle: 'Start by adding your first task',
              emptyIcon: Icons.task_outlined,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainView(TasksViewModel viewModel) {
    return Column(
      children: [
        TasksCalendarHeader(viewModel: viewModel),
        Expanded(
          child: TasksContent(
            viewModel: viewModel,
            onTaskAction: (action, task) =>
                viewModel.handleTaskAction(context, action, task),
          ),
        ),
      ],
    );
  }
}
