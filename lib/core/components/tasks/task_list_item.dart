import 'package:flutter/material.dart';
import '../../../viewmodels/tasks_viewmodel.dart';

class TaskListItem extends StatelessWidget {
  final dynamic task;
  final TasksViewModel viewModel;

  const TaskListItem({
    super.key,
    required this.task,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      title: Text(
        task.title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: task.isCompleted ? Colors.grey : Colors.black87,
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: task.dueDate != null
          ? Text(
              _formatTime(task.dueDate!),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            )
          : null,
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(1, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
}