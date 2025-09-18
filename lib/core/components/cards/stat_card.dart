import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../base/base_card.dart';

/// A card component for displaying statistics with trend indicators
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? change;
  final bool? isPositive;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.change,
    this.isPositive,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? changeColor;
    IconData? changeIcon;

    if (change != null && isPositive != null) {
      changeColor = isPositive! ? AppColors.success : AppColors.error;
      changeIcon = isPositive! ? Icons.arrow_upward : Icons.arrow_downward;
    }

    return BaseCard.clickable(
      onTap: onTap ?? () {},
      backgroundColor: backgroundColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Adjust font size based on available height
          final availableHeight = constraints.maxHeight;
          final isCompact = availableHeight < 120; // Threshold for compact mode

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.statLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (icon != null)
                    Icon(
                      icon,
                      size: AppSpacing.iconSizeS,
                      color: iconColor ?? AppColors.textSecondary,
                    ),
                ],
              ),

              // Value - responsive sizing
              Text(
                value,
                style: isCompact
                    ? AppTypography.headlineMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      )
                    : AppTypography.statValue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Change indicator - only show if space allows
              if (change != null && !isCompact) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (changeIcon != null) ...[
                      Icon(changeIcon, size: 14, color: changeColor),
                      AppSpacing.gapH1,
                    ],
                    Flexible(
                      child: Text(
                        change!,
                        style: AppTypography.labelSmall.copyWith(
                          color: changeColor ?? AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  /// Factory constructor for a revenue stat card
  factory StatCard.revenue({
    Key? key,
    required String value,
    String? change,
    bool? isPositive,
    VoidCallback? onTap,
  }) {
    return StatCard(
      key: key,
      title: 'Total Revenue',
      value: value,
      change: change,
      isPositive: isPositive,
      icon: Icons.attach_money,
      iconColor: AppColors.success,
      onTap: onTap,
    );
  }

  /// Factory constructor for a deals stat card
  factory StatCard.deals({
    Key? key,
    required String value,
    String? change,
    bool? isPositive,
    VoidCallback? onTap,
  }) {
    return StatCard(
      key: key,
      title: 'New Deals',
      value: value,
      change: change,
      isPositive: isPositive,
      icon: Icons.handshake,
      iconColor: AppColors.primary700,
      onTap: onTap,
    );
  }

  /// Factory constructor for a contacts stat card
  factory StatCard.contacts({
    Key? key,
    required String value,
    String? change,
    bool? isPositive,
    VoidCallback? onTap,
  }) {
    return StatCard(
      key: key,
      title: 'Total Contacts',
      value: value,
      change: change,
      isPositive: isPositive,
      icon: Icons.people,
      iconColor: AppColors.secondary500,
      onTap: onTap,
    );
  }

  /// Factory constructor for a tasks stat card
  factory StatCard.tasks({
    Key? key,
    required String value,
    String? change,
    bool? isPositive,
    VoidCallback? onTap,
  }) {
    return StatCard(
      key: key,
      title: 'Pending Tasks',
      value: value,
      change: change,
      isPositive: isPositive,
      icon: Icons.task_alt,
      iconColor: AppColors.warning,
      onTap: onTap,
    );
  }
}
