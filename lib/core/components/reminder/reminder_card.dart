import 'package:flutter/material.dart';
import '../../../models/reminder_model.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;

  const ReminderCard({
    super.key,
    required this.reminder,
    this.onTap,
    this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getReminderTypeColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                _getReminderTypeIcon(),
                color: _getReminderTypeColor(),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: reminder.isCompleted
                          ? Colors.grey
                          : Colors.black87,
                      decoration: reminder.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        reminder.timeFormatted,
                        style: TextStyle(
                          fontSize: 12,
                          color: reminder.isCompleted
                              ? Colors.grey.withOpacity(0.7)
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getPriorityColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          reminder.priority.displayName,
                          style: TextStyle(
                            fontSize: 10,
                            color: _getPriorityColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (reminder.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      reminder.description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: reminder.isCompleted
                            ? Colors.grey.withOpacity(0.7)
                            : Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (onToggleComplete != null)
              GestureDetector(
                onTap: onToggleComplete,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: reminder.isCompleted
                        ? const Color(0xFF007AFF)
                        : Colors.transparent,
                    border: Border.all(
                      color: reminder.isCompleted
                          ? const Color(0xFF007AFF)
                          : Colors.grey.withOpacity(0.5),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: reminder.isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getReminderTypeColor() {
    switch (reminder.type) {
      case ReminderType.proposal:
        return const Color(0xFF007AFF);
      case ReminderType.followUp:
        return const Color(0xFFAF52DE);
      case ReminderType.deadline:
        return const Color(0xFFFF3B30);
      case ReminderType.meeting:
        return const Color(0xFF34C759);
      case ReminderType.general:
        return const Color(0xFF8E8E93);
    }
  }

  IconData _getReminderTypeIcon() {
    switch (reminder.type) {
      case ReminderType.proposal:
        return Icons.description;
      case ReminderType.followUp:
        return Icons.call;
      case ReminderType.deadline:
        return Icons.schedule;
      case ReminderType.meeting:
        return Icons.people;
      case ReminderType.general:
        return Icons.notifications;
    }
  }

  Color _getPriorityColor() {
    switch (reminder.priority) {
      case ReminderPriority.low:
        return const Color(0xFF34C759);
      case ReminderPriority.medium:
        return const Color(0xFFFF9500);
      case ReminderPriority.high:
        return const Color(0xFFFF3B30);
      case ReminderPriority.urgent:
        return const Color(0xFF8B0000);
    }
  }
}
