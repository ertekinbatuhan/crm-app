class Deal {
  final String id;
  final String title;
  final double value;
  final String? description;
  final DealStatus status;
  final DateTime? closeDate;

  const Deal({
    required this.id,
    required this.title,
    required this.value,
    this.description,
    required this.status,
    this.closeDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'description': description,
      'status': status.name,
      'closeDate': closeDate?.millisecondsSinceEpoch,
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
      closeDate: map['closeDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['closeDate'])
          : null,
    );
  }

  Deal copyWith({
    String? id,
    String? title,
    double? value,
    String? description,
    DealStatus? status,
    DateTime? closeDate,
  }) {
    return Deal(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      description: description ?? this.description,
      status: status ?? this.status,
      closeDate: closeDate ?? this.closeDate,
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
        other.closeDate == closeDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        value.hashCode ^
        description.hashCode ^
        status.hashCode ^
        closeDate.hashCode;
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
  }) {
    return Deal(
      id: id,
      title: title,
      value: value,
      description: description,
      status: status,
      closeDate: calculateCloseDate(status),
    );
  }

  Deal updateWithAutoCloseDate(DealStatus newStatus) {
    return copyWith(
      status: newStatus,
      closeDate: calculateCloseDate(newStatus),
    );
  }

  @override
  String toString() {
    return 'Deal(id: $id, title: $title, value: $value, description: $description, status: $status, closeDate: $closeDate)';
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
