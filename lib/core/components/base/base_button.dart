import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

enum ButtonVariant { primary, secondary, text, outlined }

enum ButtonSize { small, medium, large }

/// A reusable button component with multiple variants and sizes
class BaseButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final Widget? child;

  const BaseButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    // Get size properties
    final buttonHeight = _getButtonHeight();
    final iconSize = _getIconSize();
    final textStyle = _getTextStyle();
    final buttonPadding = padding ?? _getPadding();

    // Build button content
    Widget buttonContent = isLoading
        ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getForegroundColor(isDisabled),
              ),
            ),
          )
        : child ??
              LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final hasConstraints =
                      availableWidth > 0 && availableWidth.isFinite;

                  // Calculate minimum required width for icon + text + gaps
                  final iconWidth =
                      (leadingIcon != null ? iconSize : 0) +
                      (trailingIcon != null ? iconSize : 0);
                  final gapWidth =
                      ((leadingIcon != null ? 1 : 0) +
                          (trailingIcon != null ? 1 : 0)) *
                      8.0; // AppSpacing.sp2

                  // Estimate text width (rough approximation)
                  final textWidth = text.length * 8.0; // Rough estimation
                  final minRequiredWidth = iconWidth + gapWidth + textWidth;

                  // If constrained and content won't fit, make it adaptive
                  final isVeryConstrained =
                      hasConstraints &&
                      availableWidth < minRequiredWidth &&
                      leadingIcon != null;

                  if (isVeryConstrained) {
                    // Show only icon when severely constrained
                    return Icon(leadingIcon!, size: iconSize);
                  }

                  return Row(
                    mainAxisSize: isFullWidth
                        ? MainAxisSize.max
                        : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (leadingIcon != null) ...[
                        Icon(leadingIcon, size: iconSize),
                        AppSpacing.gapH2,
                      ],
                      Flexible(
                        child: Text(
                          text,
                          style: textStyle,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (trailingIcon != null) ...[
                        AppSpacing.gapH2,
                        Icon(trailingIcon, size: iconSize),
                      ],
                    ],
                  );
                },
              );

    // Build button based on variant
    Widget button;
    switch (variant) {
      case ButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.primary700,
            foregroundColor: foregroundColor ?? AppColors.textInverse,
            disabledBackgroundColor: AppColors.surfaceDisabled,
            disabledForegroundColor: AppColors.textTertiary,
            elevation: elevation ?? AppSpacing.elevation2,
            padding: buttonPadding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? AppSpacing.borderRadiusS,
            ),
            textStyle: textStyle,
          ),
          child: buttonContent,
        );
        break;

      case ButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.secondary500,
            foregroundColor: foregroundColor ?? AppColors.textInverse,
            disabledBackgroundColor: AppColors.surfaceDisabled,
            disabledForegroundColor: AppColors.textTertiary,
            elevation: elevation ?? AppSpacing.elevation1,
            padding: buttonPadding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? AppSpacing.borderRadiusS,
            ),
            textStyle: textStyle,
          ),
          child: buttonContent,
        );
        break;

      case ButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor ?? AppColors.primary700,
            disabledForegroundColor: AppColors.textTertiary,
            side: BorderSide(
              color: isDisabled
                  ? AppColors.borderLight
                  : (backgroundColor ?? AppColors.primary700),
              width: 1.5,
            ),
            padding: buttonPadding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? AppSpacing.borderRadiusS,
            ),
            textStyle: textStyle,
          ),
          child: buttonContent,
        );
        break;

      case ButtonVariant.text:
        button = TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor ?? AppColors.primary700,
            disabledForegroundColor: AppColors.textTertiary,
            padding: buttonPadding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? AppSpacing.borderRadiusS,
            ),
            textStyle: textStyle,
          ),
          child: buttonContent,
        );
        break;
    }

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.buttonHeightS;
      case ButtonSize.medium:
        return AppSpacing.buttonHeightM;
      case ButtonSize.large:
        return AppSpacing.buttonHeightL;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.iconSizeXS;
      case ButtonSize.medium:
        return AppSpacing.iconSizeS;
      case ButtonSize.large:
        return AppSpacing.iconSizeM;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTypography.labelSmall;
      case ButtonSize.medium:
        return AppTypography.buttonText;
      case ButtonSize.large:
        return AppTypography.labelLarge;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.symmetric(
          horizontal: AppSpacing.sp3,
          vertical: AppSpacing.sp2,
        );
      case ButtonSize.medium:
        return AppSpacing.buttonPadding;
      case ButtonSize.large:
        return AppSpacing.symmetric(
          horizontal: AppSpacing.sp6,
          vertical: AppSpacing.sp4,
        );
    }
  }

  Color _getForegroundColor(bool isDisabled) {
    if (isDisabled) return AppColors.textTertiary;

    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
        return foregroundColor ?? AppColors.textInverse;
      case ButtonVariant.outlined:
      case ButtonVariant.text:
        return foregroundColor ?? AppColors.primary700;
    }
  }

  /// Factory constructor for icon-only button
  factory BaseButton.icon({
    Key? key,
    required IconData icon,
    required VoidCallback? onPressed,
    ButtonVariant variant = ButtonVariant.text,
    ButtonSize size = ButtonSize.medium,
    Color? backgroundColor,
    Color? foregroundColor,
    bool isLoading = false,
  }) {
    final iconSize = size == ButtonSize.small
        ? AppSpacing.iconSizeS
        : size == ButtonSize.medium
        ? AppSpacing.iconSizeM
        : AppSpacing.iconSizeL;

    return BaseButton(
      key: key,
      text: '',
      onPressed: onPressed,
      variant: variant,
      size: size,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      isLoading: isLoading,
      padding: EdgeInsets.all(AppSpacing.sp2),
      child: isLoading
          ? SizedBox(
              width: iconSize,
              height: iconSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  foregroundColor ?? AppColors.primary700,
                ),
              ),
            )
          : Icon(icon, size: iconSize),
    );
  }

  /// Factory constructor for FAB-style button
  factory BaseButton.fab({
    Key? key,
    required IconData icon,
    required VoidCallback? onPressed,
    Color? backgroundColor,
    Color? foregroundColor,
    bool mini = false,
  }) {
    return BaseButton(
      key: key,
      text: '',
      onPressed: onPressed,
      variant: ButtonVariant.primary,
      backgroundColor: backgroundColor ?? AppColors.primary700,
      foregroundColor: foregroundColor ?? AppColors.textInverse,
      borderRadius: AppSpacing.borderRadiusFull,
      elevation: AppSpacing.elevation6,
      padding: EdgeInsets.all(mini ? AppSpacing.sp3 : AppSpacing.sp4),
      child: Icon(
        icon,
        size: mini ? AppSpacing.iconSizeM : AppSpacing.iconSizeL,
      ),
    );
  }
}
