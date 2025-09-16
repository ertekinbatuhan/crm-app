import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// A reusable section header component for consistent section titles across the app
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool showDivider;
  final Color? dividerColor;
  final double? dividerThickness;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.titleStyle,
    this.subtitleStyle,
    this.showDivider = false,
    this.dividerColor,
    this.dividerThickness,
  });

  @override
  Widget build(BuildContext context) {
    Widget header = Container(
      color: backgroundColor,
      margin: margin,
      padding: padding ?? AppSpacing.paddingVerticalM,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            AppSpacing.gapH3,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: titleStyle ?? AppTypography.titleMedium,
                ),
                if (subtitle != null) ...[
                  AppSpacing.gapV1,
                  Text(
                    subtitle!,
                    style: subtitleStyle ??
                        AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            AppSpacing.gapH3,
            trailing!,
          ],
        ],
      ),
    );

    if (onTap != null) {
      header = InkWell(
        onTap: onTap,
        child: header,
      );
    }

    if (showDivider) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          header,
          Divider(
            color: dividerColor ?? AppColors.divider,
            thickness: dividerThickness ?? 1,
            height: 1,
          ),
        ],
      );
    }

    return header;
  }

  /// Factory constructor for a simple section header with just a title
  factory SectionHeader.simple({
    Key? key,
    required String title,
    EdgeInsetsGeometry? padding,
    TextStyle? titleStyle,
  }) {
    return SectionHeader(
      key: key,
      title: title,
      padding: padding,
      titleStyle: titleStyle ?? AppTypography.titleMedium,
    );
  }

  /// Factory constructor for a section header with an action button
  factory SectionHeader.withAction({
    Key? key,
    required String title,
    String? subtitle,
    required String actionText,
    required VoidCallback onActionTap,
    IconData? actionIcon,
    EdgeInsetsGeometry? padding,
  }) {
    return SectionHeader(
      key: key,
      title: title,
      subtitle: subtitle,
      padding: padding,
      trailing: TextButton.icon(
        onPressed: onActionTap,
        icon: actionIcon != null
            ? Icon(
                actionIcon,
                size: AppSpacing.iconSizeS,
              )
            : const SizedBox.shrink(),
        label: Text(
          actionText,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.primary700,
          ),
        ),
      ),
    );
  }

  /// Factory constructor for a collapsible section header
  factory SectionHeader.collapsible({
    Key? key,
    required String title,
    String? subtitle,
    required bool isExpanded,
    required VoidCallback onToggle,
    EdgeInsetsGeometry? padding,
    Widget? leading,
  }) {
    return SectionHeader(
      key: key,
      title: title,
      subtitle: subtitle,
      padding: padding,
      leading: leading,
      trailing: IconButton(
        icon: AnimatedRotation(
          turns: isExpanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.expand_more,
            color: AppColors.textSecondary,
          ),
        ),
        onPressed: onToggle,
      ),
      onTap: onToggle,
    );
  }

  /// Factory constructor for a section header with a badge
  factory SectionHeader.withBadge({
    Key? key,
    required String title,
    String? subtitle,
    required Widget badge,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
  }) {
    return SectionHeader(
      key: key,
      title: title,
      subtitle: subtitle,
      padding: padding,
      trailing: badge,
      onTap: onTap,
    );
  }

  /// Factory constructor for a sticky section header (typically used in lists)
  factory SectionHeader.sticky({
    Key? key,
    required String title,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    return SectionHeader(
      key: key,
      title: title,
      backgroundColor: backgroundColor ?? AppColors.backgroundSecondary,
      padding: padding ??
          AppSpacing.symmetric(
            horizontal: AppSpacing.sp4,
            vertical: AppSpacing.sp2,
          ),
      titleStyle: AppTypography.labelMedium.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}