import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

enum BadgeVariant { primary, secondary, success, error, warning, info, neutral }
enum BadgeSize { small, medium, large }

/// A reusable badge component for status indicators and labels
class BaseBadge extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final BadgeVariant variant;
  final BadgeSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final bool dot;
  final VoidCallback? onTap;

  const BaseBadge({
    super.key,
    this.text,
    this.icon,
    this.variant = BadgeVariant.primary,
    this.size = BadgeSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.border,
    this.padding,
    this.child,
    this.dot = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get colors based on variant
    final colors = _getColors();
    final bgColor = backgroundColor ?? colors.backgroundColor;
    final fgColor = foregroundColor ?? colors.foregroundColor;

    // Get size properties
    final badgePadding = padding ?? _getPadding();
    final textStyle = _getTextStyle().copyWith(color: fgColor);
    final iconSize = _getIconSize();

    // Build badge content
    Widget badgeContent;
    if (dot) {
      // Dot badge (no content, just a colored dot)
      badgeContent = Container(
        width: size == BadgeSize.small ? 8 : size == BadgeSize.medium ? 10 : 12,
        height: size == BadgeSize.small ? 8 : size == BadgeSize.medium ? 10 : 12,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: border,
        ),
      );
    } else if (child != null) {
      // Custom child content
      badgeContent = Container(
        padding: badgePadding,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius ?? AppSpacing.borderRadiusFull,
          border: border,
        ),
        child: child,
      );
    } else {
      // Text and/or icon content
      badgeContent = Container(
        padding: badgePadding,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius ?? AppSpacing.borderRadiusFull,
          border: border,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: iconSize,
                color: fgColor,
              ),
              if (text != null) AppSpacing.gapH1,
            ],
            if (text != null)
              Text(
                text!,
                style: textStyle,
              ),
          ],
        ),
      );
    }

    // Add tap handler if provided
    if (onTap != null) {
      badgeContent = InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? AppSpacing.borderRadiusFull,
        child: badgeContent,
      );
    }

    return badgeContent;
  }

  _BadgeColors _getColors() {
    switch (variant) {
      case BadgeVariant.primary:
        return _BadgeColors(
          backgroundColor: AppColors.primary100,
          foregroundColor: AppColors.primary700,
        );
      case BadgeVariant.secondary:
        return _BadgeColors(
          backgroundColor: AppColors.secondary100,
          foregroundColor: AppColors.secondary700,
        );
      case BadgeVariant.success:
        return _BadgeColors(
          backgroundColor: AppColors.successLight,
          foregroundColor: AppColors.successDark,
        );
      case BadgeVariant.error:
        return _BadgeColors(
          backgroundColor: AppColors.errorLight,
          foregroundColor: AppColors.errorDark,
        );
      case BadgeVariant.warning:
        return _BadgeColors(
          backgroundColor: AppColors.warningLight,
          foregroundColor: AppColors.warningDark,
        );
      case BadgeVariant.info:
        return _BadgeColors(
          backgroundColor: AppColors.infoLight,
          foregroundColor: AppColors.infoDark,
        );
      case BadgeVariant.neutral:
        return _BadgeColors(
          backgroundColor: AppColors.backgroundCard,
          foregroundColor: AppColors.textSecondary,
        );
    }
  }

  EdgeInsetsGeometry _getPadding() {
    if (dot) return EdgeInsets.zero;
    
    switch (size) {
      case BadgeSize.small:
        return AppSpacing.symmetric(horizontal: AppSpacing.sp2, vertical: AppSpacing.sp1);
      case BadgeSize.medium:
        return AppSpacing.symmetric(horizontal: AppSpacing.sp3, vertical: AppSpacing.sp1);
      case BadgeSize.large:
        return AppSpacing.symmetric(horizontal: AppSpacing.sp4, vertical: AppSpacing.sp2);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case BadgeSize.small:
        return AppTypography.badge.copyWith(fontSize: 10);
      case BadgeSize.medium:
        return AppTypography.badge;
      case BadgeSize.large:
        return AppTypography.labelSmall;
    }
  }

  double _getIconSize() {
    switch (size) {
      case BadgeSize.small:
        return 12;
      case BadgeSize.medium:
        return 14;
      case BadgeSize.large:
        return 16;
    }
  }

  /// Factory constructor for count badge
  factory BaseBadge.count({
    Key? key,
    required int count,
    BadgeVariant variant = BadgeVariant.error,
    BadgeSize size = BadgeSize.small,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    // Format count (99+ for large numbers)
    final displayCount = count > 99 ? '99+' : count.toString();
    
    return BaseBadge(
      key: key,
      text: displayCount,
      variant: variant,
      size: size,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: count > 99 
          ? AppSpacing.symmetric(horizontal: AppSpacing.sp2, vertical: AppSpacing.sp1)
          : AppSpacing.symmetric(horizontal: AppSpacing.sp1, vertical: 0),
    );
  }

  /// Factory constructor for status badge
  factory BaseBadge.status({
    Key? key,
    required String status,
    BadgeSize size = BadgeSize.medium,
    IconData? icon,
  }) {
    BadgeVariant variant;
    IconData? statusIcon = icon;

    // Determine variant and icon based on status
    switch (status.toLowerCase()) {
      case 'active':
      case 'online':
      case 'completed':
      case 'success':
      case 'won':
        variant = BadgeVariant.success;
        statusIcon ??= Icons.check_circle_outline;
        break;
      case 'inactive':
      case 'offline':
      case 'cancelled':
      case 'lost':
        variant = BadgeVariant.error;
        statusIcon ??= Icons.cancel_outlined;
        break;
      case 'pending':
      case 'in progress':
      case 'processing':
        variant = BadgeVariant.warning;
        statusIcon ??= Icons.access_time;
        break;
      case 'draft':
      case 'archived':
        variant = BadgeVariant.neutral;
        statusIcon ??= Icons.archive_outlined;
        break;
      default:
        variant = BadgeVariant.info;
        statusIcon ??= Icons.info_outline;
    }

    return BaseBadge(
      key: key,
      text: status,
      icon: statusIcon,
      variant: variant,
      size: size,
    );
  }

  /// Factory constructor for chip-style badge
  factory BaseBadge.chip({
    Key? key,
    required String text,
    BadgeVariant variant = BadgeVariant.neutral,
    BadgeSize size = BadgeSize.medium,
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return BaseBadge(
      key: key,
      text: text,
      variant: variant,
      size: size,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: size == BadgeSize.small
                ? AppTypography.badge.copyWith(fontSize: 10)
                : size == BadgeSize.medium
                    ? AppTypography.badge
                    : AppTypography.labelSmall,
          ),
          if (onDelete != null) ...[
            AppSpacing.gapH1,
            InkWell(
              onTap: onDelete,
              child: Icon(
                Icons.close,
                size: size == BadgeSize.small ? 12 : 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Factory constructor for notification badge (positioned absolutely)
  static Widget withBadge({
    required Widget child,
    String? badgeText,
    int? count,
    bool showDot = false,
    BadgeVariant variant = BadgeVariant.error,
    BadgeSize size = BadgeSize.small,
    AlignmentDirectional alignment = AlignmentDirectional.topEnd,
    double? top,
    double? right,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: top ?? -4,
          right: right ?? -4,
          child: showDot
              ? BaseBadge(
                  dot: true,
                  variant: variant,
                  size: size,
                )
              : count != null
                  ? BaseBadge.count(
                      count: count,
                      variant: variant,
                      size: size,
                    )
                  : BaseBadge(
                      text: badgeText,
                      variant: variant,
                      size: size,
                    ),
        ),
      ],
    );
  }
}

class _BadgeColors {
  final Color backgroundColor;
  final Color foregroundColor;

  const _BadgeColors({
    required this.backgroundColor,
    required this.foregroundColor,
  });
}