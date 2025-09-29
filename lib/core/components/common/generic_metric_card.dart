import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

enum MetricCardStyle {
  standard,    // Normal card style
  compact,     // Smaller, more compact
  detailed,    // With extra details and decorations
}

class GenericMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final String? subtitle;
  final Color? subtitleColor;
  final Color? backgroundColor;
  final MetricCardStyle style;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool showIconBackground;

  const GenericMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor = AppColors.primary,
    this.subtitle,
    this.subtitleColor,
    this.backgroundColor,
    this.style = MetricCardStyle.standard,
    this.trailing,
    this.onTap,
    this.padding,
    this.showIconBackground = true,
  });

  // Factory constructors for common use cases
  factory GenericMetricCard.dashboard({
    required String title,
    required String value,
    required IconData icon,
    Color iconColor = AppColors.primary,
    String? subtitle,
    Color? subtitleColor,
  }) {
    return GenericMetricCard(
      title: title,
      value: value,
      icon: icon,
      iconColor: iconColor,
      subtitle: subtitle,
      subtitleColor: subtitleColor,
      style: MetricCardStyle.detailed,
    );
  }

  factory GenericMetricCard.stats({
    required String title,
    required String value,
    required IconData icon,
    Color iconColor = AppColors.primary,
  }) {
    return GenericMetricCard(
      title: title,
      value: value,
      icon: icon,
      iconColor: iconColor,
      style: MetricCardStyle.standard,
      showIconBackground: false,
    );
  }

  factory GenericMetricCard.compact({
    required String title,
    required String value,
    required IconData icon,
    Color iconColor = AppColors.primary,
  }) {
    return GenericMetricCard(
      title: title,
      value: value,
      icon: icon,
      iconColor: iconColor,
      style: MetricCardStyle.compact,
      showIconBackground: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        child: Container(
          width: style == MetricCardStyle.compact ? null : double.infinity,
          padding: padding ?? _getPadding(),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.cardBackgroundColor,
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: _getElevation(),
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (style) {
      case MetricCardStyle.detailed:
        return _buildDetailedContent();
      case MetricCardStyle.compact:
        return _buildCompactContent();
      case MetricCardStyle.standard:
        return _buildStandardContent();
    }
  }

  Widget _buildStandardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildIcon(),
            const SizedBox(width: AppSizes.paddingS),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.statTitle.copyWith(color: AppColors.grey600),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: AppSizes.paddingS),
        Text(
          value,
          style: AppTextStyles.statValue,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            subtitle!,
            style: AppTextStyles.bodySmall.copyWith(
              color: subtitleColor ?? AppColors.grey600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildIcon(),
            const SizedBox(width: AppSizes.paddingM),
            if (subtitle != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingS,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: (subtitleColor ?? iconColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                ),
                child: Text(
                  subtitle!,
                  style: AppTextStyles.chipText.copyWith(
                    color: subtitleColor ?? iconColor,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingM),
        Text(
          title,
          style: AppTextStyles.statTitle.copyWith(color: AppColors.grey600),
        ),
        const SizedBox(height: AppSizes.paddingXS),
        Text(
          value,
          style: AppTextStyles.statValue,
        ),
      ],
    );
  }

  Widget _buildCompactContent() {
    return Row(
      children: [
        _buildIcon(),
        const SizedBox(width: AppSizes.paddingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
              ),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }

  Widget _buildIcon() {
    if (showIconBackground && style == MetricCardStyle.detailed) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.paddingS),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
        ),
        child: Icon(icon, color: iconColor, size: _getIconSize()),
      );
    } else {
      return Icon(icon, color: iconColor, size: _getIconSize());
    }
  }

  double _getBorderRadius() {
    switch (style) {
      case MetricCardStyle.detailed:
        return AppSizes.radiusL;
      case MetricCardStyle.compact:
        return AppSizes.radiusS;
      case MetricCardStyle.standard:
        return AppSizes.radiusM;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (style) {
      case MetricCardStyle.detailed:
        return const EdgeInsets.all(AppSizes.paddingL);
      case MetricCardStyle.compact:
        return const EdgeInsets.all(AppSizes.paddingS);
      case MetricCardStyle.standard:
        return const EdgeInsets.all(AppSizes.paddingM);
    }
  }

  double _getElevation() {
    switch (style) {
      case MetricCardStyle.detailed:
        return AppSizes.elevationM;
      case MetricCardStyle.compact:
        return AppSizes.elevationS;
      case MetricCardStyle.standard:
        return AppSizes.elevationM;
    }
  }

  double _getIconSize() {
    switch (style) {
      case MetricCardStyle.detailed:
        return AppSizes.iconL;
      case MetricCardStyle.compact:
        return AppSizes.iconS;
      case MetricCardStyle.standard:
        return AppSizes.iconM;
    }
  }
}