import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// A reusable card component with consistent styling
class BaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final double? elevation;
  final VoidCallback? onTap;
  final Border? border;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final List<BoxShadow>? boxShadow;

  const BaseCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
    this.onTap,
    this.border,
    this.width,
    this.height,
    this.constraints,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      width: width,
      height: height,
      constraints: constraints,
      padding: padding ?? AppSpacing.cardPadding,
      child: child,
    );

    // Use default card if no custom styling needed
    if (onTap == null && 
        backgroundColor == null && 
        border == null && 
        boxShadow == null) {
      return Card(
        margin: margin ?? EdgeInsets.zero,
        elevation: elevation ?? AppSpacing.elevation2,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? AppSpacing.borderRadiusM,
        ),
        child: cardContent,
      );
    }

    // Custom implementation for more control
    return Container(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: borderRadius ?? AppSpacing.borderRadiusM,
        border: border,
        boxShadow: boxShadow ?? [
          if (elevation != null && elevation! > 0)
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: elevation! * 2,
              offset: Offset(0, elevation!),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius ?? AppSpacing.borderRadiusM,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? AppSpacing.borderRadiusM,
          child: cardContent,
        ),
      ),
    );
  }

  /// Factory constructor for a clickable card
  factory BaseCard.clickable({
    Key? key,
    required Widget child,
    required VoidCallback onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    double? elevation,
    Border? border,
    double? width,
    double? height,
  }) {
    return BaseCard(
      key: key,
      child: child,
      onTap: onTap,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      elevation: elevation ?? AppSpacing.elevation2,
      border: border,
      width: width,
      height: height,
    );
  }

  /// Factory constructor for an outlined card
  factory BaseCard.outlined({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? borderColor,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    double? width,
    double? height,
  }) {
    return BaseCard(
      key: key,
      child: child,
      padding: padding,
      margin: margin,
      backgroundColor: AppColors.surface,
      borderRadius: borderRadius,
      elevation: 0,
      border: Border.all(
        color: borderColor ?? AppColors.border,
        width: 1,
      ),
      onTap: onTap,
      width: width,
      height: height,
    );
  }

  /// Factory constructor for a flat card (no elevation)
  factory BaseCard.flat({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    double? width,
    double? height,
  }) {
    return BaseCard(
      key: key,
      child: child,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor ?? AppColors.backgroundCard,
      borderRadius: borderRadius,
      elevation: 0,
      onTap: onTap,
      width: width,
      height: height,
    );
  }

  /// Factory constructor for a gradient card
  factory BaseCard.gradient({
    Key? key,
    required Widget child,
    required Gradient gradient,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    double? elevation,
    VoidCallback? onTap,
    double? width,
    double? height,
  }) {
    return BaseCard(
      key: key,
      padding: EdgeInsets.zero,
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
      onTap: onTap,
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: borderRadius ?? AppSpacing.borderRadiusM,
        ),
        padding: padding ?? AppSpacing.cardPadding,
        child: child,
      ),
    );
  }
}