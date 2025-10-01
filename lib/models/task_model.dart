import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final DateTime? dueDate;
  final bool isCompleted;
  final TaskType type;
  final TaskPriority priority;
  final String? associatedContactId;
  final String? associatedDealId;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    this.createdAt,
    this.updatedAt,
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
    DateTime? createdAt,
    DateTime? updatedAt,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'isCompleted': isCompleted,
      'type': type.name,
      'priority': priority.name,
      'associatedContactId': associatedContactId,
      'associatedDealId': associatedDealId,
      'description': description,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      dueDate: _parseTimestamp(map['dueDate']),
      isCompleted: map['isCompleted'] ?? false,
      type: _parseTaskType(map['type']),
      priority: _parseTaskPriority(map['priority']),
      associatedContactId: map['associatedContactId'],
      associatedDealId: map['associatedDealId'],
      description: map['description'],
      createdAt: _parseTimestamp(map['createdAt']),
      updatedAt: _parseTimestamp(map['updatedAt']),
    );
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    if (value is Map<String, dynamic>) {
      final seconds = value['seconds'] as num?;
      final nanoseconds = value['nanoseconds'] as num? ?? 0;
      if (seconds != null) {
        final milliseconds = seconds * 1000 + (nanoseconds / 1000000);
        return DateTime.fromMillisecondsSinceEpoch(milliseconds.round());
      }
    }
    return null;
  }

  static TaskType _parseTaskType(dynamic value) {
    if (value is String) {
      return TaskType.values.firstWhere(
        (type) => type.name == value,
        orElse: () => TaskType.general,
      );
    }
    if (value is TaskType) {
      return value;
    }
    return TaskType.general;
  }

  static TaskPriority _parseTaskPriority(dynamic value) {
    if (value is String) {
      return TaskPriority.values.firstWhere(
        (priority) => priority.name == value,
        orElse: () => TaskPriority.medium,
      );
    }
    if (value is TaskPriority) {
      return value;
    }
    return TaskPriority.medium;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        dueDate,
        isCompleted,
        type,
        priority,
        associatedContactId,
        associatedDealId,
        description,
        createdAt,
        updatedAt,
      ];
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
