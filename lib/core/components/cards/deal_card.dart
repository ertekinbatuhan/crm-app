import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../base/base_card.dart';
import '../base/base_badge.dart';

/// Enum representing deal status for styling
enum DealStatus { 
  prospect, 
  qualified, 
  proposal, 
  negotiation, 
  closed, 
  lost 
}

/// Extension for DealStatus display and styling
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

  Color get color {
    switch (this) {
      case DealStatus.prospect:
        return AppColors.info;
      case DealStatus.qualified:
        return AppColors.secondary500;
      case DealStatus.proposal:
        return AppColors.warning;
      case DealStatus.negotiation:
        return Colors.purple;
      case DealStatus.closed:
        return AppColors.success;
      case DealStatus.lost:
        return AppColors.error;
    }
  }

  BadgeVariant get badgeVariant {
    switch (this) {
      case DealStatus.prospect:
        return BadgeVariant.info;
      case DealStatus.qualified:
        return BadgeVariant.secondary;
      case DealStatus.proposal:
        return BadgeVariant.warning;
      case DealStatus.negotiation:
        return BadgeVariant.primary;
      case DealStatus.closed:
        return BadgeVariant.success;
      case DealStatus.lost:
        return BadgeVariant.error;
    }
  }
}

/// A card component for displaying deal information
class DealCard extends StatelessWidget {
  final String id;
  final String title;
  final double value;
  final String? description;
  final DealStatus status;
  final DateTime? closeDate;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onStatusChange;
  final bool showActions;

  const DealCard({
    super.key,
    required this.id,
    required this.title,
    required this.value,
    this.description,
    required this.status,
    this.closeDate,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onStatusChange,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: AppSpacing.sp3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title and actions
          Row(
            children: [
              // Deal icon with status color
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: status.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.handshake,
                  color: status.color,
                  size: AppSpacing.iconSizeS,
                ),
              ),
              AppSpacing.gapH3,
              
              // Title and value
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.gapV1,
                    Text(
                      _formatCurrency(value),
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Status badge
              BaseBadge(
                text: status.displayName,
                variant: status.badgeVariant,
              ),
              
              // Actions menu
              if (showActions) ...[
                AppSpacing.gapH2,
                _buildActions(context),
              ],
            ],
          ),
          
          // Description
          if (description != null && description!.isNotEmpty) ...[
            AppSpacing.gapV3,
            Text(
              description!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          
          // Close date
          if (closeDate != null) ...[
            AppSpacing.gapV2,
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: AppSpacing.iconSizeXS,
                  color: AppColors.textTertiary,
                ),
                AppSpacing.gapH1,
                Text(
                  'Expected close: ${_formatDate(closeDate!)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: AppColors.textSecondary,
        size: AppSpacing.iconSizeS,
      ),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'status':
            onStatusChange?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18),
              SizedBox(width: 12),
              Text('Edit Deal'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'status',
          child: Row(
            children: [
              Icon(Icons.sync_alt, size: 18),
              SizedBox(width: 12),
              Text('Change Status'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: Colors.red),
              SizedBox(width: 12),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${amount.toStringAsFixed(0)}';
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Factory constructor for creating from Deal model
  factory DealCard.fromModel({
    required String id,
    required String title,
    required double value,
    String? description,
    required DealStatus status,
    DateTime? closeDate,
    VoidCallback? onTap,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    VoidCallback? onStatusChange,
    bool showActions = true,
  }) {
    return DealCard(
      id: id,
      title: title,
      value: value,
      description: description,
      status: status,
      closeDate: closeDate,
      onTap: onTap,
      onEdit: onEdit,
      onDelete: onDelete,
      onStatusChange: onStatusChange,
      showActions: showActions,
    );
  }
}

/// Compact deal card variant for lists
class DealCardCompact extends StatelessWidget {
  final String title;
  final double value;
  final DealStatus status;
  final VoidCallback? onTap;

  const DealCardCompact({
    super.key,
    required this.title,
    required this.value,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      padding: AppSpacing.paddingM,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: status.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.handshake,
              color: status.color,
              size: AppSpacing.iconSizeXS,
            ),
          ),
          AppSpacing.gapH3,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatCurrency(value),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          BaseBadge(
            text: status.displayName,
            variant: status.badgeVariant,
            size: BadgeSize.small,
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${amount.toStringAsFixed(0)}';
    }
  }
}