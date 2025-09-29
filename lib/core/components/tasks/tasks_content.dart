import 'package:flutter/material.dart';
import '../../../viewmodels/tasks_viewmodel.dart';
import '../column/app_section.dart';
import 'task_list_item.dart';
import '../common/action_menu.dart';

class TasksContent extends StatelessWidget {
  final TasksViewModel viewModel;
  final Function(ActionMenuAction, dynamic) onTaskAction;

  const TasksContent({
    super.key,
    required this.viewModel,
    required this.onTaskAction,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AppSection(
            title: 'Tasks',
            items: viewModel.selectedDateTasks,
            itemBuilder: (task) => TaskListItem(
              task: task,
              onToggleCompletion: () async {
                try {
                  await viewModel.toggleTaskCompletion(task.id);
                } catch (e) {
                  // Silent error handling
                }
              },
              onActionSelected: (action) => onTaskAction(action, task),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}