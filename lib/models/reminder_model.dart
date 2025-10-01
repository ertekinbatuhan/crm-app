import 'package:equatable/equatable.dart';

class Reminder extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime time;
  final bool isCompleted;
  final ReminderType type;
  final ReminderPriority priority;

  const Reminder({
    required this.id,
    required this.title,
    this.description,
    required this.time,
    required this.isCompleted,
    required this.type,
    required this.priority,
  });

  String get timeFormatted {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  bool get isToday {
    final now = DateTime.now();
    return time.year == now.year &&
        time.month == now.month &&
        time.day == now.day;
  }

  bool get isOverdue {
    return time.isBefore(DateTime.now()) && !isCompleted;
  }

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? time,
    bool? isCompleted,
    ReminderType? type,
    ReminderPriority? priority,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
      type: type ?? this.type,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        time,
        isCompleted,
        type,
        priority,
      ];
}

enum ReminderType { proposal, followUp, deadline, meeting, general }

enum ReminderPriority { low, medium, high, urgent }

extension ReminderTypeExtension on ReminderType {
  String get displayName {
    switch (this) {
      case ReminderType.proposal:
        return 'Proposal';
      case ReminderType.followUp:
        return 'Follow Up';
      case ReminderType.deadline:
        return 'Deadline';
      case ReminderType.meeting:
        return 'Meeting';
      case ReminderType.general:
        return 'General';
    }
  }
}

extension ReminderPriorityExtension on ReminderPriority {
  String get displayName {
    switch (this) {
      case ReminderPriority.low:
        return 'Low';
      case ReminderPriority.medium:
        return 'Medium';
      case ReminderPriority.high:
        return 'High';
      case ReminderPriority.urgent:
        return 'Urgent';
    }
  }
}
