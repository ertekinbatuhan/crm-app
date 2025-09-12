import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/tasks_viewmodel.dart';
import '../core/components/modal/add_task_modal.dart';
import '../core/components/tasks/tasks_calendar_header.dart';
import '../core/components/column/app_section.dart';
import '../core/components/list-view/app_list_item.dart';

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
          body: SafeArea(
            child: _buildMainView(viewModel),
          ),
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
          // Calendar Header
          TasksCalendarHeader(viewModel: viewModel),

          // Tasks Section
          AppSection(
            title: 'Tasks',
            items: viewModel.selectedDateTasks,
            itemBuilder: (task) => _buildTaskItem(task, viewModel),
          ),

          // Meetings Section  
          AppSection(
            title: 'Meetings',
            items: const [],
            itemBuilder: (meeting) => _buildMeetingItem(meeting),
          ),

          const SizedBox(height: 100), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildTaskItem(dynamic task, TasksViewModel viewModel) {
    return AppListItem(
      leading: GestureDetector(
        onTap: () => viewModel.toggleTaskCompletion(task.id),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: task.isCompleted ? const Color(0xFF34C759) : Colors.transparent,
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
    );
  }

  Widget _buildMeetingItem(dynamic meeting) {
    return AppListItem(
      leading: AppListItemLeading(
        backgroundColor: const Color(0xFF007AFF).withOpacity(0.1),
        child: const Icon(
          Icons.videocam,
          color: Color(0xFF007AFF),
          size: 20,
        ),
      ),
      title: AppListItemTitle(text: meeting.title ?? 'Meeting'),
      subtitle: AppListItemSubtitle(
        text: '${_formatTime(meeting.startTime)} - ${_formatTime(meeting.endTime)}',
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
          contacts: [], // ViewModel'den gelecek
          deals: [], // ViewModel'den gelecek
          onTaskCreated: (task) async {
            try {
              await viewModel.createTask(task);
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop(true);
              }
            } catch (e) {
              print('Error creating task: $e');
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop(false);
              }
            }
          },
        ),
      );
    } catch (e) {
      print('Error showing dialog: $e');
    }
  }
}
