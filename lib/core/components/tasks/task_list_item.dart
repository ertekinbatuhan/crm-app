import 'package:flutter/material.dart';
import '../../../models/task_model.dart';
import '../common/action_menu.dart';
import '../list-view/app_list_item.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback? onToggleCompletion;
  final Function(ActionMenuAction)? onActionSelected;

  const TaskListItem({
    super.key,
    required this.task,
    this.onToggleCompletion,
    this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppListItem(
      leading: GestureDetector(
        onTap: onToggleCompletion,
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
      trailing: onActionSelected != null
          ? ActionMenu(
              onSelected: onActionSelected!,
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