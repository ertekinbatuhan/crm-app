import 'package:flutter/material.dart';
import '../../../models/task_model.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onDelete;

  const TaskItem({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleComplete,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: GestureDetector(
          onTap: onToggleComplete,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: task.isCompleted
                  ? const Color(0xFF007AFF)
                  : Colors.transparent,
              border: Border.all(
                color: task.isCompleted
                    ? const Color(0xFF007AFF)
                    : Colors.grey.withOpacity(0.5),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: task.isCompleted
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: task.isCompleted ? Colors.grey : Colors.black87,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: task.dueDate != null
            ? Text(
                _formatTime(task.dueDate!),
                style: TextStyle(
                  fontSize: 12,
                  color: task.isCompleted
                      ? Colors.grey.withOpacity(0.7)
                      : Colors.grey,
                ),
              )
            : null,
        trailing: onDelete != null
            ? GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.grey.withOpacity(0.5),
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final displayHour = time.hour > 12
        ? time.hour - 12
        : time.hour == 0
        ? 12
        : time.hour;
    return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
  }
}
