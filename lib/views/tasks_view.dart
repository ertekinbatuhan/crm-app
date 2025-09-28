import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/tasks_viewmodel.dart';
import '../core/components/modal/add_task_modal.dart';
import '../core/components/tasks/tasks_calendar_header.dart';
import '../core/components/column/app_section.dart';
import '../core/components/list-view/app_list_item.dart';
import '../models/task_model.dart';
import '../models/meeting_model.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView>
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
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${viewModel.errorMessage}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => viewModel.loadTasksData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SafeArea(child: _buildMainView(viewModel)),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddTaskDialog(),
            backgroundColor: const Color(0xFF007AFF),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildMainView(TasksViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TasksCalendarHeader(viewModel: viewModel),

          AppSection(
            title: 'Tasks',
            items: viewModel.selectedDateTasks,
            itemBuilder: (task) => _buildTaskItem(task, viewModel),
          ),

          AppSection(
            title: 'Meetings',
            items: viewModel.selectedDateMeetings,
            itemBuilder: _buildMeetingItem,
            showEmptyState: true,
          ),

          const SizedBox(height: 100), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task, TasksViewModel viewModel) {
    return AppListItem(
      leading: GestureDetector(
        onTap: () async {
          try {
            await viewModel.toggleTaskCompletion(task.id);
          } catch (e) {
            _showSnackBar('Failed to update task: $e');
          }
        },
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: task.isCompleted
                ? const Color(0xFF34C759)
                : Colors.transparent,
            border: Border.all(
              color: task.isCompleted ? const Color(0xFF34C759) : Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: task.isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : null,
        ),
      ),
      title: AppListItemTitle(
        text: task.title,
        strikeThrough: task.isCompleted,
        color: task.isCompleted ? Colors.grey : Colors.black87,
      ),
      subtitle: task.dueDate != null
          ? AppListItemSubtitle(text: _formatTime(task.dueDate!))
          : null,
      trailing: PopupMenuButton<_TaskMenuAction>(
        onSelected: (action) => _handleTaskAction(action, task, viewModel),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: _TaskMenuAction.edit,
            child: ListTile(
              leading: Icon(Icons.edit_outlined),
              title: Text('Edit'),
              minLeadingWidth: 0,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: _TaskMenuAction.delete,
            child: ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.redAccent),
              title: Text('Delete'),
              minLeadingWidth: 0,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
        tooltip: 'Task options',
        icon: const Icon(Icons.more_vert, color: Colors.grey),
      ),
    );
  }

  Widget _buildMeetingItem(Meeting meeting) {
    return AppListItem(
      leading: AppListItemLeading(
        backgroundColor: const Color(0xFF007AFF).withOpacity(0.1),
        child: const Icon(Icons.videocam, color: Color(0xFF007AFF), size: 20),
      ),
      title: AppListItemTitle(text: meeting.title),
      subtitle: AppListItemSubtitle(
        text:
            '${_formatTime(meeting.startTime)} - ${_formatTime(meeting.endTime)}',
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(1, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  void _showAddTaskDialog() async {
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
              _showSnackBar('Failed to create task: $e');
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop(false);
              }
            }
          },
        ),
      );
    } catch (e) {
      _showSnackBar('Failed to open dialog: $e');
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
            _showSnackBar('Task updated');
          } catch (e) {
            _showSnackBar('Failed to update task: $e');
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop(false);
            }
          }
        },
      ),
    );
  }

  void _handleTaskAction(
    _TaskMenuAction action,
    Task task,
    TasksViewModel viewModel,
  ) {
    switch (action) {
      case _TaskMenuAction.edit:
        _showEditTaskDialog(task, viewModel);
        break;
      case _TaskMenuAction.delete:
        _confirmDeleteTask(task, viewModel);
        break;
    }
  }

  Future<void> _confirmDeleteTask(Task task, TasksViewModel viewModel) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text('Are you sure you want to delete "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        await viewModel.deleteTask(task.id);
        _showSnackBar('Task deleted');
      } catch (e) {
        _showSnackBar('Failed to delete task: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

enum _TaskMenuAction { edit, delete }
