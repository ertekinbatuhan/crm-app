import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../base/base_card.dart';
import '../base/base_badge.dart';

/// Enum representing task priority for styling
enum TaskPriority { low, medium, high, urgent }

/// Enum representing task type for styling  
enum TaskType { followUp, presentation, general }

/// Extensions for TaskPriority display and styling
extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return AppColors.info;
      case TaskPriority.medium:
        return AppColors.secondary500;
      case TaskPriority.high:
        return AppColors.warning;
      case TaskPriority.urgent:
        return AppColors.error;
    }
  }

  BadgeVariant get badgeVariant {
    switch (this) {
      case TaskPriority.low:
        return BadgeVariant.info;
      case TaskPriority.medium:
        return BadgeVariant.secondary;
      case TaskPriority.high:
        return BadgeVariant.warning;
      case TaskPriority.urgent:
        return BadgeVariant.error;
    }
  }
}

/// Extensions for TaskType display and styling
extension TaskTypeExtension on TaskType {
  String get displayName {
    switch (this) {
      case TaskType.followUp:
        return 'Follow up';
      case TaskType.presentation:
        return 'Presentation';
      case TaskType.general:
        return 'Task';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskType.followUp:
        return Icons.phone;
      case TaskType.presentation:
        return Icons.present_to_all;
      case TaskType.general:
        return Icons.task_alt;
    }
  }

  Color get color {
    switch (this) {
      case TaskType.followUp:
        return AppColors.info;
      case TaskType.presentation:
        return AppColors.secondary500;
      case TaskType.general:
        return AppColors.primary700;
    }
  }
}

/// A card component for displaying task information
class TaskCard extends StatelessWidget {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;
  final TaskType type;
  final TaskPriority priority;
  final String? associatedContactId;
  final String? associatedDealId;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const TaskCard({
    super.key,
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.isCompleted,
    required this.type,
    required this.priority,
    this.associatedContactId,
    this.associatedDealId,
    this.onTap,
    this.onToggleComplete,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: AppSpacing.sp3),
      backgroundColor: isCompleted ? AppColors.backgroundCard.withOpacity(0.5) : null,
      child: Row(
        children: [
          // Completion checkbox
          _buildCheckbox(),
          AppSpacing.gapH3,
          
          // Task icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: type.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              type.icon,
              color: type.color,
              size: AppSpacing.iconSizeXS,
            ),
          ),
          AppSpacing.gapH3,
          
          // Task content
          Expanded(
            child: _buildTaskContent(),
          ),
          
          // Priority badge and actions
          if (!isCompleted) ...[
            AppSpacing.gapH2,
            BaseBadge(
              text: priority.displayName,
              variant: priority.badgeVariant,
              size: BadgeSize.small,
            ),
          ],
          
          if (showActions) ...[
            AppSpacing.gapH2,
            _buildActions(context),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckbox() {
    return GestureDetector(
      onTap: onToggleComplete,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.success : Colors.transparent,
          border: Border.all(
            color: isCompleted ? AppColors.success : AppColors.textTertiary,
            width: 2,
          ),
          borderRadius: AppSpacing.borderRadiusXS,
        ),
        child: isCompleted
            ? Icon(
                Icons.check,
                color: Colors.white,
                size: AppSpacing.iconSizeXS,
              )
            : null,
      ),
    );
  }

  Widget _buildTaskContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        // Description
        if (description != null && description!.isNotEmpty) ...[
          AppSpacing.gapV1,
          Text(
            description!,
            style: AppTypography.bodySmall.copyWith(
              color: isCompleted ? AppColors.textTertiary : AppColors.textSecondary,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        
        // Due date and type info
        if (dueDate != null || associatedContactId != null || associatedDealId != null) ...[
          AppSpacing.gapV1,
          _buildTaskMeta(),
        ],
      ],
    );
  }

  Widget _buildTaskMeta() {
    final metaItems = <Widget>[];
    
    // Due date
    if (dueDate != null) {
      final isOverdue = dueDate!.isBefore(DateTime.now()) && !isCompleted;
      final isToday = _isSameDay(dueDate!, DateTime.now());
      
      metaItems.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule,
              size: AppSpacing.iconSizeXS,
              color: isOverdue 
                  ? AppColors.error 
                  : isToday 
                      ? AppColors.warning 
                      : AppColors.textTertiary,
            ),
            AppSpacing.gapH1,
            Text(
              _formatDueDate(dueDate!),
              style: AppTypography.bodySmall.copyWith(
                color: isOverdue 
                    ? AppColors.error 
                    : isToday 
                        ? AppColors.warning 
                        : AppColors.textTertiary,
                fontWeight: isOverdue || isToday ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }
    
    // Associated contact or deal
    if (associatedContactId != null) {
      if (metaItems.isNotEmpty) metaItems.add(AppSpacing.gapH2);
      metaItems.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person,
              size: AppSpacing.iconSizeXS,
              color: AppColors.textTertiary,
            ),
            AppSpacing.gapH1,
            Text(
              'Contact',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    } else if (associatedDealId != null) {
      if (metaItems.isNotEmpty) metaItems.add(AppSpacing.gapH2);
      metaItems.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.handshake,
              size: AppSpacing.iconSizeXS,
              color: AppColors.textTertiary,
            ),
            AppSpacing.gapH1,
            Text(
              'Deal',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }
    
    return Row(
      children: metaItems,
    );
  }

  Widget _buildActions(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: AppColors.textSecondary,
        size: AppSpacing.iconSizeS,
      ),
      onSelected: (value) {
        switch (value) {
          case 'toggle':
            onToggleComplete?.call();
            break;
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'toggle',
          child: Row(
            children: [
              Icon(
                isCompleted ? Icons.radio_button_unchecked : Icons.check_circle,
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(isCompleted ? 'Mark Incomplete' : 'Mark Complete'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18),
              SizedBox(width: 12),
              Text('Edit Task'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: Colors.red),
              SizedBox(width: 12),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);
    
    if (taskDate == today) {
      return 'Today ${_formatTime(date)}';
    } else if (taskDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow ${_formatTime(date)}';
    } else if (taskDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${_formatTime(date)}';
    } else if (taskDate.isBefore(today)) {
      final difference = today.difference(taskDate).inDays;
      return '$difference days ago';
    } else {
      final difference = taskDate.difference(today).inDays;
      return 'In $difference days';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(1, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Factory constructor for creating from Task model
  factory TaskCard.fromModel({
    required String id,
    required String title,
    String? description,
    DateTime? dueDate,
    required bool isCompleted,
    required TaskType type,
    required TaskPriority priority,
    String? associatedContactId,
    String? associatedDealId,
    VoidCallback? onTap,
    VoidCallback? onToggleComplete,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    bool showActions = true,
  }) {
    return TaskCard(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: isCompleted,
      type: type,
      priority: priority,
      associatedContactId: associatedContactId,
      associatedDealId: associatedDealId,
      onTap: onTap,
      onToggleComplete: onToggleComplete,
      onEdit: onEdit,
      onDelete: onDelete,
      showActions: showActions,
    );
  }
}

/// Compact task card variant for lists
class TaskCardCompact extends StatelessWidget {
  final String title;
  final DateTime? dueDate;
  final bool isCompleted;
  final TaskPriority priority;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;

  const TaskCardCompact({
    super.key,
    required this.title,
    this.dueDate,
    required this.isCompleted,
    required this.priority,
    this.onTap,
    this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      padding: AppSpacing.paddingS,
      backgroundColor: isCompleted ? AppColors.backgroundCard.withOpacity(0.5) : null,
      child: Row(
        children: [
          // Compact checkbox
          GestureDetector(
            onTap: onToggleComplete,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.success : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? AppColors.success : AppColors.textTertiary,
                  width: 1.5,
                ),
                borderRadius: AppSpacing.borderRadiusXS,
              ),
              child: isCompleted
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    )
                  : null,
            ),
          ),
          AppSpacing.gapH2,
          
          // Title and meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (dueDate != null) ...[
                  AppSpacing.gapV1,
                  Text(
                    _formatDueDate(dueDate!),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Priority indicator
          if (!isCompleted) ...[
            AppSpacing.gapH2,
            BaseBadge(
              text: priority.displayName,
              variant: priority.badgeVariant,
              size: BadgeSize.small,
            ),
          ],
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);
    
    if (taskDate == today) {
      return 'Today';
    } else if (taskDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (taskDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else if (taskDate.isBefore(today)) {
      final difference = today.difference(taskDate).inDays;
      return '${difference}d ago';
    } else {
      final difference = taskDate.difference(today).inDays;
      return 'In ${difference}d';
    }
  }
}