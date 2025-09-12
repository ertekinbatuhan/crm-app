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
