class Task {
  final String id;
  final String title;
  final DateTime? dueDate;
  final bool isCompleted;
  final TaskType type;
  final TaskPriority priority;
  final String? associatedContactId;
  final String? associatedDealId;
  final String? description;

  const Task({
    required this.id,
    required this.title,
    this.dueDate,
    required this.isCompleted,
    required this.type,
    required this.priority,
    this.associatedContactId,
    this.associatedDealId,
    this.description,
  });

  Task copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    bool? isCompleted,
    TaskType? type,
    TaskPriority? priority,
    String? associatedContactId,
    String? associatedDealId,
    String? description,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      associatedContactId: associatedContactId ?? this.associatedContactId,
      associatedDealId: associatedDealId ?? this.associatedDealId,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.dueDate == dueDate &&
        other.isCompleted == isCompleted &&
        other.type == type &&
        other.priority == priority &&
        other.associatedContactId == associatedContactId &&
        other.associatedDealId == associatedDealId &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        dueDate.hashCode ^
        isCompleted.hashCode ^
        type.hashCode ^
        priority.hashCode ^
        associatedContactId.hashCode ^
        associatedDealId.hashCode ^
        description.hashCode;
  }
}

enum TaskPriority { low, medium, high, urgent }

enum TaskType { followUp, presentation, general }

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
}

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
}
