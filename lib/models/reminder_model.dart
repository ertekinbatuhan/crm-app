class Reminder {
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Reminder &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.time == time &&
        other.isCompleted == isCompleted &&
        other.type == type &&
        other.priority == priority;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        time.hashCode ^
        isCompleted.hashCode ^
        type.hashCode ^
        priority.hashCode;
  }
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
