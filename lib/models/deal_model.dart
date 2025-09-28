import 'package:cloud_firestore/cloud_firestore.dart';

class Deal {
  final String id;
  final String title;
  final double value;
  final String? description;
  final DealStatus status;
  final DateTime? closeDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Deal({
    required this.id,
    required this.title,
    required this.value,
    this.description,
    required this.status,
    this.closeDate,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'description': description,
      'status': status.name,
      'closeDate': closeDate != null ? Timestamp.fromDate(closeDate!) : null,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory Deal.fromMap(Map<String, dynamic> map) {
    return Deal(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      value: (map['value'] ?? 0.0).toDouble(),
      description: map['description'],
      status: DealStatus.values.firstWhere(
        (status) => status.name == map['status'],
        orElse: () => DealStatus.prospect,
      ),
      closeDate: _parseTimestamp(map['closeDate']),
      createdAt: _parseTimestamp(map['createdAt']),
      updatedAt: _parseTimestamp(map['updatedAt']),
    );
  }

  Deal copyWith({
    String? id,
    String? title,
    double? value,
    String? description,
    DealStatus? status,
    DateTime? closeDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Deal(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      description: description ?? this.description,
      status: status ?? this.status,
      closeDate: closeDate ?? this.closeDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Deal &&
        other.id == id &&
        other.title == title &&
        other.value == value &&
        other.description == description &&
        other.status == status &&
        other.closeDate == closeDate &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        value.hashCode ^
        description.hashCode ^
        status.hashCode ^
        closeDate.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  /// Calculates automatic closeDate based on deal status
  static DateTime calculateCloseDate(DealStatus status) {
    final now = DateTime.now();
    switch (status) {
      case DealStatus.prospect:
        return now.add(const Duration(days: 45));
      case DealStatus.qualified:
        return now.add(const Duration(days: 30));
      case DealStatus.proposal:
        return now.add(const Duration(days: 21));
      case DealStatus.negotiation:
        return now.add(const Duration(days: 14));
      case DealStatus.closed:
        return now;
      case DealStatus.lost:
        return now;
    }
  }

  /// Creates a deal with automatic closeDate based on status
  factory Deal.withAutoCloseDate({
    required String id,
    required String title,
    required double value,
    String? description,
    required DealStatus status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final now = DateTime.now();
    return Deal(
      id: id,
      title: title,
      value: value,
      description: description,
      status: status,
      closeDate: calculateCloseDate(status),
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
    );
  }

  Deal updateWithAutoCloseDate(DealStatus newStatus) {
    return copyWith(
      status: newStatus,
      closeDate: calculateCloseDate(newStatus),
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Deal(id: $id, title: $title, value: $value, description: $description, status: $status, closeDate: $closeDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}

enum DealStatus { prospect, qualified, proposal, negotiation, closed, lost }

extension DealStatusExtension on DealStatus {
  String get displayName {
    switch (this) {
      case DealStatus.prospect:
        return 'Prospect';
      case DealStatus.qualified:
        return 'Qualified';
      case DealStatus.proposal:
        return 'Proposal';
      case DealStatus.negotiation:
        return 'Negotiation';
      case DealStatus.closed:
        return 'Closed';
      case DealStatus.lost:
        return 'Lost';
    }
  }
}
