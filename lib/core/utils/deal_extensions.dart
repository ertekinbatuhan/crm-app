import 'package:flutter/material.dart';
import '../../models/deal_model.dart';

extension DealStatusExtensions on DealStatus {
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

  Color get statusColor {
    switch (this) {
      case DealStatus.prospect:
        return Colors.blue;
      case DealStatus.qualified:
        return Colors.orange;
      case DealStatus.proposal:
        return Colors.purple;
      case DealStatus.negotiation:
        return Colors.amber;
      case DealStatus.closed:
        return Colors.green;
      case DealStatus.lost:
        return Colors.red;
    }
  }

  IconData get statusIcon {
    switch (this) {
      case DealStatus.prospect:
        return Icons.visibility;
      case DealStatus.qualified:
        return Icons.star;
      case DealStatus.proposal:
        return Icons.description;
      case DealStatus.negotiation:
        return Icons.handshake;
      case DealStatus.closed:
        return Icons.check_circle;
      case DealStatus.lost:
        return Icons.cancel;
    }
  }
}