class Meeting {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> participants;
  final MeetingType type;

  const Meeting({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.participants,
    required this.type,
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
  }) {
    return Meeting(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      participants: participants ?? this.participants,
      type: type ?? this.type,
    );
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
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        participants.hashCode ^
        type.hashCode;
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
