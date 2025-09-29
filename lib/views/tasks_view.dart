import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/tasks_viewmodel.dart';
import '../core/components/modal/add_task_modal.dart';
import '../core/components/tasks/tasks_calendar_header.dart';
import '../core/components/tasks/tasks_content.dart';
import '../core/components/common/action_menu.dart';
import '../core/components/common/danger_button.dart';
import '../core/components/view_state_handler.dart';
import '../core/constants/app_constants.dart';
import '../models/task_model.dart';

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
              state: _getViewState(viewModel),
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

  ViewState _getViewState(TasksViewModel viewModel) {
    if (viewModel.isLoading) return ViewState.loading;
    if (viewModel.hasError) return ViewState.error;
    return ViewState.success;
  }

  Widget _buildMainView(TasksViewModel viewModel) {
    return Column(
      children: [
        TasksCalendarHeader(viewModel: viewModel),
        Expanded(
          child: TasksContent(
            viewModel: viewModel,
            onTaskAction: (action, task) => _handleTaskAction(action, task, viewModel),
          ),
        ),
      ],
    );
  }

  Future<void> showAddTaskDialog() async {
    if (!mounted) return;

    final viewModel = context.read<TasksViewModel>();

    try {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => AddTaskModal(
          contacts: viewModel.contacts,
          deals: viewModel.deals,
          onSubmit: (task) async {
            try {
              await viewModel.createTask(task);
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop(true);
              }
            } catch (e) {
              // Silent error handling
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop(false);
              }
            }
          },
        ),
      );
    } catch (e) {
      // Silent error handling
    }
  }

  Future<void> _showEditTaskDialog(Task task, TasksViewModel viewModel) async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AddTaskModal(
        contacts: viewModel.contacts,
        deals: viewModel.deals,
        initialTask: task,
        title: 'Edit Task',
        submitButtonLabel: 'Update Task',
        onSubmit: (updatedTask) async {
          try {
            await viewModel.updateTask(updatedTask);
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop(true);
            }
          } catch (e) {
            // Silent error handling
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop(false);
            }
          }
        },
      ),
    );
  }

  void _handleTaskAction(
    ActionMenuAction action,
    Task task,
    TasksViewModel viewModel,
  ) {
    if (action == ActionMenuAction.edit) {
      _showEditTaskDialog(task, viewModel);
      return;
    }
    if (action == ActionMenuAction.delete) {
      _confirmDeleteTask(task, viewModel);
    }
  }

  Future<void> _confirmDeleteTask(Task task, TasksViewModel viewModel) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
          ),
          title: const Text('Delete Task'),
          content: Text('Are you sure you want to delete "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(AppStrings.cancel),
            ),
            DangerButton(
              label: AppStrings.delete,
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        await viewModel.deleteTask(task.id);
      } catch (e) {
        // Silent error handling - no snackbar
      }
    }
  }
}
