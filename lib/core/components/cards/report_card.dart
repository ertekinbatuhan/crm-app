import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../base/base_card.dart';
import '../layout/section_header.dart';

/// A card component for displaying report sections
class ReportCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onMorePressed;
  final EdgeInsetsGeometry? padding;

  const ReportCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.onTap,
    this.onMorePressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sp4,
              AppSpacing.sp4,
              AppSpacing.sp4,
              0,
            ),
            child: SectionHeader(
              title: title,
              subtitle: subtitle,
              padding: EdgeInsets.zero,
              trailing: onMorePressed != null
                  ? IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: onMorePressed,
                    )
                  : null,
            ),
          ),
          
          // Content
          Padding(
            padding: padding ?? AppSpacing.paddingM,
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Card for displaying key performance metrics
class MetricsCard extends StatelessWidget {
  final List<MetricItem> metrics;
  final VoidCallback? onTap;

  const MetricsCard({
    super.key,
    required this.metrics,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      title: 'Key Metrics',
      onTap: onTap,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        crossAxisSpacing: AppSpacing.sp3,
        mainAxisSpacing: AppSpacing.sp3,
        children: metrics.map((metric) => _MetricItem(metric: metric)).toList(),
      ),
    );
  }
}

/// Card for displaying revenue breakdown
class RevenueCard extends StatelessWidget {
  final double totalRevenue;
  final List<RevenueBreakdown> breakdown;
  final VoidCallback? onTap;
  final VoidCallback? onMorePressed;

  const RevenueCard({
    super.key,
    required this.totalRevenue,
    required this.breakdown,
    this.onTap,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      title: 'Revenue Overview',
      subtitle: _formatCurrency(totalRevenue),
      onTap: onTap,
      onMorePressed: onMorePressed,
      child: Column(
        children: [
          // Chart placeholder
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: AppSpacing.borderRadiusS,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 32,
                    color: AppColors.textTertiary,
                  ),
                  AppSpacing.gapV2,
                  Text(
                    'Revenue Chart',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          AppSpacing.gapV4,
          
          // Revenue breakdown
          Row(
            children: breakdown.map((item) {
              final isLast = breakdown.indexOf(item) == breakdown.length - 1;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : AppSpacing.sp2),
                  child: _RevenueBreakdownItem(breakdown: item),
                ),
              );
            }).toList(),
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

/// Card for displaying deals by status
class DealsStatusCard extends StatelessWidget {
  final Map<String, int> dealsByStatus;
  final VoidCallback? onTap;

  const DealsStatusCard({
    super.key,
    required this.dealsByStatus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalDeals = dealsByStatus.values.fold(0, (sum, count) => sum + count);
    
    return ReportCard(
      title: 'Deals by Status',
      subtitle: '$totalDeals total deals',
      onTap: onTap,
      child: Column(
        children: dealsByStatus.entries.map((entry) {
          final percentage = totalDeals > 0 ? (entry.value / totalDeals * 100) : 0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                // Status indicator
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(entry.key),
                    shape: BoxShape.circle,
                  ),
                ),
                AppSpacing.gapH2,
                
                // Status name
                Expanded(
                  child: Text(
                    entry.key,
                    style: AppTypography.bodyMedium,
                  ),
                ),
                
                // Count and percentage
                Text(
                  '${entry.value}',
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.gapH2,
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'prospect':
        return AppColors.info;
      case 'qualified':
        return AppColors.secondary500;
      case 'proposal':
        return AppColors.warning;
      case 'negotiation':
        return Colors.purple;
      case 'closed':
      case 'closed won':
        return AppColors.success;
      case 'lost':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}

/// Card for displaying performance metrics
class PerformanceCard extends StatelessWidget {
  final List<PerformanceMetric> metrics;
  final VoidCallback? onTap;

  const PerformanceCard({
    super.key,
    required this.metrics,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      title: 'Performance Metrics',
      onTap: onTap,
      child: Column(
        children: metrics.map((metric) => _PerformanceItem(metric: metric)).toList(),
      ),
    );
  }
}

/// Individual metric item widget
class _MetricItem extends StatelessWidget {
  final MetricItem metric;

  const _MetricItem({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingS,
      decoration: BoxDecoration(
        color: metric.color.withOpacity(0.1),
        borderRadius: AppSpacing.borderRadiusS,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                metric.icon,
                color: metric.color,
                size: AppSpacing.iconSizeS,
              ),
              const Spacer(),
              if (metric.trend != null)
                _buildTrendIndicator(metric.trend!),
            ],
          ),
          
          Text(
            metric.value,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          Text(
            metric.label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendIndicator(MetricTrend trend) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: trend.isPositive ? AppColors.successLight : AppColors.errorLight,
        borderRadius: AppSpacing.borderRadiusXS,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            trend.isPositive ? Icons.trending_up : Icons.trending_down,
            size: 12,
            color: trend.isPositive ? AppColors.successDark : AppColors.errorDark,
          ),
          const SizedBox(width: 2),
          Text(
            trend.percentage,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: trend.isPositive ? AppColors.successDark : AppColors.errorDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// Revenue breakdown item widget
class _RevenueBreakdownItem extends StatelessWidget {
  final RevenueBreakdown breakdown;

  const _RevenueBreakdownItem({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingS,
      decoration: BoxDecoration(
        color: breakdown.color.withOpacity(0.1),
        borderRadius: AppSpacing.borderRadiusS,
      ),
      child: Column(
        children: [
          Text(
            breakdown.label,
            style: AppTypography.labelSmall.copyWith(
              color: breakdown.color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapV1,
          Text(
            breakdown.amount,
            style: AppTypography.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Performance metric item widget
class _PerformanceItem extends StatelessWidget {
  final PerformanceMetric metric;

  const _PerformanceItem({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.label,
                  style: AppTypography.bodyMedium,
                ),
                if (metric.subtitle != null) ...[
                  AppSpacing.gapV1,
                  Text(
                    metric.subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                metric.value,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getValueColor(metric.value),
                ),
              ),
              if (metric.target != null) ...[
                AppSpacing.gapV1,
                Text(
                  'Target: ${metric.target}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getValueColor(String value) {
    if (value.contains('%')) {
      final percentage = double.tryParse(value.replaceAll('%', '')) ?? 0;
      if (percentage >= 80) return AppColors.success;
      if (percentage >= 60) return AppColors.warning;
      return AppColors.error;
    }
    return AppColors.textPrimary;
  }
}

/// Data models for report components
class MetricItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final MetricTrend? trend;

  const MetricItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
  });
}

class MetricTrend {
  final String percentage;
  final bool isPositive;

  const MetricTrend({
    required this.percentage,
    required this.isPositive,
  });
}

class RevenueBreakdown {
  final String label;
  final String amount;
  final Color color;

  const RevenueBreakdown({
    required this.label,
    required this.amount,
    required this.color,
  });
}

class PerformanceMetric {
  final String label;
  final String? subtitle;
  final String value;
  final String? target;

  const PerformanceMetric({
    required this.label,
    this.subtitle,
    required this.value,
    this.target,
  });
}