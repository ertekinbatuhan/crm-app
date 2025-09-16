import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../base/base_card.dart';
import '../layout/section_header.dart';

/// Model for activity data
class ActivityData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final DateTime? timestamp;
  final VoidCallback? onTap;

  const ActivityData({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.timestamp,
    this.onTap,
  });
}

/// A card component for displaying recent activities
class ActivityCard extends StatelessWidget {
  final String title;
  final List<ActivityData> activities;
  final VoidCallback? onViewAll;
  final VoidCallback? onTap;

  const ActivityCard({
    super.key,
    required this.title,
    required this.activities,
    this.onViewAll,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader.withAction(
            title: title,
            actionText: 'View All',
            onActionTap: onViewAll ?? () {},
            padding: EdgeInsets.zero,
          ),
          AppSpacing.gapV4,
          ...activities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            final isLast = index == activities.length - 1;
            
            return _ActivityItem(
              activity: activity,
              showDivider: !isLast,
            );
          }),
        ],
      ),
    );
  }

  /// Factory constructor for recent activities
  factory ActivityCard.recent({
    Key? key,
    required List<ActivityData> activities,
    VoidCallback? onViewAll,
    VoidCallback? onTap,
  }) {
    return ActivityCard(
      key: key,
      title: 'Recent Activity',
      activities: activities,
      onViewAll: onViewAll,
      onTap: onTap,
    );
  }
}

/// Individual activity item widget
class _ActivityItem extends StatelessWidget {
  final ActivityData activity;
  final bool showDivider;

  const _ActivityItem({
    required this.activity,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: activity.onTap,
      borderRadius: AppSpacing.borderRadiusS,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: showDivider
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.divider,
                    width: 1,
                  ),
                ),
              )
            : null,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: activity.iconBackgroundColor ?? _getDefaultIconBackground(activity.icon),
                shape: BoxShape.circle,
              ),
              child: Icon(
                activity.icon,
                size: AppSpacing.iconSizeS,
                color: activity.iconColor ?? _getDefaultIconColor(activity.icon),
              ),
            ),
            AppSpacing.gapH3,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.gapV1,
                  Text(
                    activity.subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (activity.timestamp != null) ...[
              AppSpacing.gapH2,
              Text(
                _formatTimestamp(activity.timestamp!),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getDefaultIconBackground(IconData icon) {
    if (icon == Icons.event || icon == Icons.schedule) {
      return AppColors.primary100;
    } else if (icon == Icons.mail || icon == Icons.email) {
      return AppColors.secondary100;
    } else if (icon == Icons.call || icon == Icons.phone) {
      return AppColors.warningLight;
    } else if (icon == Icons.handshake || icon == Icons.business) {
      return AppColors.successLight;
    }
    return AppColors.backgroundCard;
  }

  Color _getDefaultIconColor(IconData icon) {
    if (icon == Icons.event || icon == Icons.schedule) {
      return AppColors.primary700;
    } else if (icon == Icons.mail || icon == Icons.email) {
      return AppColors.secondary700;
    } else if (icon == Icons.call || icon == Icons.phone) {
      return AppColors.warningDark;
    } else if (icon == Icons.handshake || icon == Icons.business) {
      return AppColors.successDark;
    }
    return AppColors.textSecondary;
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}