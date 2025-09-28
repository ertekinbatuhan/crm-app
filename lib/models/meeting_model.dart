import 'package:cloud_firestore/cloud_firestore.dart';

class Meeting {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> participants;
  final MeetingType type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Meeting({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.participants,
    required this.type,
    this.createdAt,
    this.updatedAt,
  });

  Duration get duration => endTime.difference(startTime);

  String get timeRange {
    final startHour = startTime.hour.toString().padLeft(2, '0');
    final startMinute = startTime.minute.toString().padLeft(2, '0');
    final endHour = endTime.hour.toString().padLeft(2, '0');
    final endMinute = endTime.minute.toString().padLeft(2, '0');
    return '$startHour:$startMinute - $endHour:$endMinute';
  }

  Meeting copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? participants,
    MeetingType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Meeting(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      participants: participants ?? this.participants,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'participants': participants,
      'type': type.name,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory Meeting.fromMap(Map<String, dynamic> map) {
    return Meeting(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      startTime: _parseTimestamp(map['startTime']) ?? DateTime.now(),
      endTime: _parseTimestamp(map['endTime']) ?? DateTime.now(),
      participants: List<String>.from(map['participants'] ?? []),
      type: _parseMeetingType(map['type']),
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
    return null;
  }

  static MeetingType _parseMeetingType(dynamic value) {
    if (value is String) {
      return MeetingType.values.firstWhere(
        (type) => type.name == value,
        orElse: () => MeetingType.internal,
      );
    }
    if (value is MeetingType) {
      return value;
    }
    return MeetingType.internal;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Meeting &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.participants == participants &&
        other.type == type &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        participants.hashCode ^
        type.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

enum MeetingType { client, internal, presentation, followUp }

extension MeetingTypeExtension on MeetingType {
  String get displayName {
    switch (this) {
      case MeetingType.client:
        return 'Client Meeting';
      case MeetingType.internal:
        return 'Internal Meeting';
      case MeetingType.presentation:
        return 'Presentation';
      case MeetingType.followUp:
        return 'Follow Up';
    }
  }
}
