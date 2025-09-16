import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../base/base_button.dart';

/// A component to display when there's no content to show
class EmptyState extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? icon;
  final IconData? iconData;
  final String? imagePath;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const EmptyState({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.iconData,
    this.imagePath,
    this.actionText,
    this.onActionPressed,
    this.iconColor,
    this.iconSize,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : assert(
          icon == null || (iconData == null && imagePath == null),
          'Cannot provide both icon widget and iconData/imagePath',
        );

  @override
  Widget build(BuildContext context) {
    // Build icon/image widget
    Widget? visual;
    if (icon != null) {
      visual = icon;
    } else if (iconData != null) {
      visual = Icon(
        iconData,
        size: iconSize ?? 80,
        color: iconColor ?? AppColors.textTertiary,
      );
    } else if (imagePath != null) {
      visual = Image.asset(
        imagePath!,
        width: iconSize ?? 200,
        height: iconSize ?? 200,
        fit: BoxFit.contain,
      );
    }

    return Container(
      padding: padding ?? AppSpacing.paddingXL,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (visual != null) ...[
            visual,
            AppSpacing.gapV6,
          ],
          if (title != null) ...[
            Text(
              title!,
              style: AppTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (message != null) AppSpacing.gapV2,
          ],
          if (message != null) ...[
            Text(
              message!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (actionText != null && onActionPressed != null) ...[
            AppSpacing.gapV6,
            BaseButton(
              text: actionText!,
              onPressed: onActionPressed,
              variant: ButtonVariant.primary,
            ),
          ],
        ],
      ),
    );
  }

  /// Factory constructor for "No Data" empty state
  factory EmptyState.noData({
    Key? key,
    String? title,
    String? message,
    String? actionText,
    VoidCallback? onActionPressed,
  }) {
    return EmptyState(
      key: key,
      title: title ?? 'No Data',
      message: message ?? 'There\'s nothing to show here yet.',
      iconData: Icons.inbox_outlined,
      actionText: actionText,
      onActionPressed: onActionPressed,
    );
  }

  /// Factory constructor for "No Results" empty state (after search/filter)
  factory EmptyState.noResults({
    Key? key,
    String? searchQuery,
    String? message,
    String? actionText,
    VoidCallback? onActionPressed,
  }) {
    return EmptyState(
      key: key,
      title: 'No Results Found',
      message: message ??
          (searchQuery != null
              ? 'No results found for "$searchQuery".\nTry adjusting your search.'
              : 'No results match your criteria.\nTry adjusting your filters.'),
      iconData: Icons.search_off,
      actionText: actionText ?? 'Clear Search',
      onActionPressed: onActionPressed,
    );
  }

  /// Factory constructor for "Error" empty state
  factory EmptyState.error({
    Key? key,
    String? message,
    VoidCallback? onRetry,
  }) {
    return EmptyState(
      key: key,
      title: 'Something Went Wrong',
      message: message ?? 'An error occurred while loading the data.',
      iconData: Icons.error_outline,
      iconColor: AppColors.error,
      actionText: 'Try Again',
      onActionPressed: onRetry,
    );
  }

  /// Factory constructor for "No Internet" empty state
  factory EmptyState.noInternet({
    Key? key,
    VoidCallback? onRetry,
  }) {
    return EmptyState(
      key: key,
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again.',
      iconData: Icons.wifi_off,
      actionText: 'Retry',
      onActionPressed: onRetry,
    );
  }

  /// Factory constructor for "Coming Soon" empty state
  factory EmptyState.comingSoon({
    Key? key,
    String? feature,
  }) {
    return EmptyState(
      key: key,
      title: 'Coming Soon',
      message: feature != null
          ? '$feature will be available soon!'
          : 'This feature is under development.',
      iconData: Icons.construction,
      iconColor: AppColors.warning,
    );
  }

  /// Factory constructor for custom list empty states
  factory EmptyState.list({
    Key? key,
    required String itemType,
    String? actionText,
    VoidCallback? onActionPressed,
    IconData? icon,
  }) {
    final itemTypeLower = itemType.toLowerCase();
    final itemTypeCapitalized = itemType[0].toUpperCase() + itemType.substring(1);
    
    return EmptyState(
      key: key,
      title: 'No $itemTypeCapitalized',
      message: 'You don\'t have any $itemTypeLower yet.',
      iconData: icon ?? _getIconForItemType(itemTypeLower),
      actionText: actionText ?? 'Add $itemTypeCapitalized',
      onActionPressed: onActionPressed,
    );
  }

  static IconData _getIconForItemType(String type) {
    switch (type.toLowerCase()) {
      case 'contact':
      case 'contacts':
        return Icons.people_outline;
      case 'deal':
      case 'deals':
        return Icons.handshake_outlined;
      case 'task':
      case 'tasks':
        return Icons.task_alt;
      case 'meeting':
      case 'meetings':
        return Icons.event_outlined;
      case 'message':
      case 'messages':
        return Icons.message_outlined;
      case 'notification':
      case 'notifications':
        return Icons.notifications_outlined;
      case 'file':
      case 'files':
        return Icons.folder_outlined;
      default:
        return Icons.inbox_outlined;
    }
  }
}