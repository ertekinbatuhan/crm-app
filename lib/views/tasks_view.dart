import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../viewmodels/tasks_viewmodel.dart';
import '../core/components/layout/page_container.dart';
import '../core/components/layout/empty_state.dart';
import '../core/components/layout/section_header.dart';
import '../core/components/cards/task_card.dart' as card_task;
import '../core/components/cards/stat_card.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TasksViewModel>().loadTasksData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddTaskDialog(),
            child: const Icon(Icons.add),
          ),
          body: PageContainer(
            scrollable: false,
            child: CustomScrollView(
              slivers: [
                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search tasks...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        contentPadding: AppSpacing.inputPadding,
                      ),
                    ),
                  ),
                ),
                
                // Spacing
                SliverToBoxAdapter(
                  child: AppSpacing.gapV2,
                ),
                
                // Stats Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: Row(
                      children: [
                        Expanded(
                          child: StatCard.tasks(
                            value: viewModel.selectedDateTasks.length.toString(),
                            change: _getCompletedTasksChange(viewModel),
                            isPositive: _isTaskProgressPositive(viewModel),
                            onTap: () => print('Tasks stat tapped'),
                          ),
                        ),
                        AppSpacing.gapH3,
                        Expanded(
                          child: StatCard(
                            title: 'Due Today',
                            value: _getDueTodayCount(viewModel).toString(),
                            icon: Icons.schedule,
                            iconColor: _getDueTodayCount(viewModel) > 0 ? AppColors.warning : AppColors.success,
                            onTap: () => print('Due today stat tapped'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Spacing
                SliverToBoxAdapter(
                  child: AppSpacing.gapV4,
                ),
                
                // Loading State
                if (viewModel.isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                
                // Error State
                if (viewModel.hasError && !viewModel.isLoading)
                  SliverFillRemaining(
                    child: EmptyState.error(
                      message: viewModel.errorMessage ?? 'Failed to load tasks',
                      onRetry: viewModel.loadTasksData,
                    ),
                  ),
                
                // Empty State
                if (viewModel.selectedDateTasks.isEmpty && !viewModel.isLoading && !viewModel.hasError)
                  const SliverFillRemaining(
                    child: EmptyState(
                      iconData: Icons.task_alt,
                      title: 'No tasks yet',
                      message: 'Create your first task to get organized',
                    ),
                  ),
                
                // Tasks List by Category
                if (viewModel.selectedDateTasks.isNotEmpty && !viewModel.isLoading && !viewModel.hasError)
                  ..._buildTaskSections(viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  // Task management methods

  List<Widget> _buildTaskSections(TasksViewModel viewModel) {
    final sections = <Widget>[];
    
    // Group tasks by priority and completion status
    final pendingTasks = viewModel.selectedDateTasks.where((task) => !task.isCompleted).toList();
    final completedTasks = viewModel.selectedDateTasks.where((task) => task.isCompleted).toList();
    
    // Sort pending tasks by priority and due date
    pendingTasks.sort((a, b) {
      // First sort by priority (urgent > high > medium > low)
      final priorityComparison = _getPriorityWeight(b.priority).compareTo(_getPriorityWeight(a.priority));
      if (priorityComparison != 0) return priorityComparison;
      
      // Then sort by due date
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    
    // Pending tasks section
    if (pendingTasks.isNotEmpty) {
      sections.addAll([
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: SectionHeader(
              title: 'Pending Tasks',
              subtitle: '${pendingTasks.length} task${pendingTasks.length != 1 ? 's' : ''}',
            ),
          ),
        ),
        SliverPadding(
          padding: AppSpacing.screenPadding,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final task = pendingTasks[index];
                return card_task.TaskCard.fromModel(
                  id: task.id,
                  title: task.title,
                  description: task.description,
                  dueDate: task.dueDate,
                  isCompleted: task.isCompleted,
                  type: _mapTaskType(task.type),
                  priority: _mapTaskPriority(task.priority),
                  associatedContactId: task.associatedContactId,
                  associatedDealId: task.associatedDealId,
                  onTap: () => _navigateToTaskDetail(task),
                  onToggleComplete: () => viewModel.toggleTaskCompletion(task.id),
                  onEdit: () => _showEditTaskDialog(viewModel, task),
                  onDelete: () => _showDeleteConfirmation(viewModel, task),
                );
              },
              childCount: pendingTasks.length,
            ),
          ),
        ),
      ]);
    }
    
    // Completed tasks section
    if (completedTasks.isNotEmpty) {
      sections.addAll([
        SliverToBoxAdapter(
          child: AppSpacing.gapV4,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: SectionHeader(
              title: 'Completed Tasks',
              subtitle: '${completedTasks.length} task${completedTasks.length != 1 ? 's' : ''}',
            ),
          ),
        ),
        SliverPadding(
          padding: AppSpacing.screenPadding,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final task = completedTasks[index];
                return card_task.TaskCard.fromModel(
                  id: task.id,
                  title: task.title,
                  description: task.description,
                  dueDate: task.dueDate,
                  isCompleted: task.isCompleted,
                  type: _mapTaskType(task.type),
                  priority: _mapTaskPriority(task.priority),
                  associatedContactId: task.associatedContactId,
                  associatedDealId: task.associatedDealId,
                  onTap: () => _navigateToTaskDetail(task),
                  onToggleComplete: () => viewModel.toggleTaskCompletion(task.id),
                  onEdit: () => _showEditTaskDialog(viewModel, task),
                  onDelete: () => _showDeleteConfirmation(viewModel, task),
                );
              },
              childCount: completedTasks.length,
            ),
          ),
        ),
      ]);
    }
    
    return sections;
  }

  // Utility methods
  int _getDueTodayCount(TasksViewModel viewModel) {
    final today = DateTime.now();
    final todayTasks = viewModel.selectedDateTasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.year == today.year &&
             task.dueDate!.month == today.month &&
             task.dueDate!.day == today.day;
    }).length;
    return todayTasks;
  }

  String _getCompletedTasksChange(TasksViewModel viewModel) {
    final completedCount = viewModel.selectedDateTasks.where((task) => task.isCompleted).length;
    final totalCount = viewModel.selectedDateTasks.length;
    if (totalCount == 0) return '+0';
    final percentage = ((completedCount / totalCount) * 100).round();
    return '$percentage%';
  }

  bool _isTaskProgressPositive(TasksViewModel viewModel) {
    final completedCount = viewModel.selectedDateTasks.where((task) => task.isCompleted).length;
    final totalCount = viewModel.selectedDateTasks.length;
    return totalCount > 0 && (completedCount / totalCount) >= 0.5;
  }

  int _getPriorityWeight(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 1;
      case TaskPriority.medium:
        return 2;
      case TaskPriority.high:
        return 3;
      case TaskPriority.urgent:
        return 4;
    }
  }

  card_task.TaskType _mapTaskType(TaskType type) {
    switch (type) {
      case TaskType.followUp:
        return card_task.TaskType.followUp;
      case TaskType.presentation:
        return card_task.TaskType.presentation;
      case TaskType.general:
        return card_task.TaskType.general;
    }
  }

  card_task.TaskPriority _mapTaskPriority(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return card_task.TaskPriority.low;
      case TaskPriority.medium:
        return card_task.TaskPriority.medium;
      case TaskPriority.high:
        return card_task.TaskPriority.high;
      case TaskPriority.urgent:
        return card_task.TaskPriority.urgent;
    }
  }

  // Navigation and action methods
  void _navigateToTaskDetail(Task task) {
    print('Navigate to task detail: ${task.title}');
    // TODO: Navigate to task detail screen
  }

  void _showEditTaskDialog(TasksViewModel viewModel, Task task) {
    print('Edit task: ${task.title}');
    // TODO: Implement edit task dialog
  }

  void _showDeleteConfirmation(TasksViewModel viewModel, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: viewModel.deleteTask(task.id);
              print('Delete task: ${task.title}');
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog() async {
    if (!mounted) return;
    
    final viewModel = context.read<TasksViewModel>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    TaskPriority selectedPriority = TaskPriority.medium;
    TaskType selectedType = TaskType.general;
    DateTime? selectedDate;
    
    try {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Add New Task'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TaskPriority>(
                    value: selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: TaskPriority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedPriority = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TaskType>(
                    value: selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    items: TaskType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedType = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty) {
                    final task = Task(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      description: descriptionController.text.isEmpty
                          ? null
                          : descriptionController.text,
                      isCompleted: false,
                      type: selectedType,
                      priority: selectedPriority,
                      dueDate: selectedDate,
                    );
                    
                    try {
                      await viewModel.createTask(task);
                      if (dialogContext.mounted) {
                        Navigator.of(dialogContext).pop(true);
                      }
                    } catch (e) {
                      print('Error creating task: $e');
                    }
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print('Error showing dialog: $e');
    }
  }
}
