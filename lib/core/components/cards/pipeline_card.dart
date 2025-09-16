import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../base/base_card.dart';
import '../layout/section_header.dart';

/// Model for pipeline stage data
class PipelineStageData {
  final String name;
  final String value;
  final double progress; // 0.0 to 1.0

  const PipelineStageData({
    required this.name,
    required this.value,
    required this.progress,
  });
}

/// A card component for displaying sales pipeline with progress bars
class PipelineCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<PipelineStageData> stages;
  final VoidCallback? onTap;
  final VoidCallback? onMorePressed;

  const PipelineCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.stages,
    this.onTap,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
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
          AppSpacing.gapV4,
          ...stages.map((stage) => _PipelineStageItem(stage: stage)),
        ],
      ),
    );
  }

  /// Factory constructor for default CRM pipeline
  factory PipelineCard.sales({
    Key? key,
    required List<PipelineStageData> stages,
    VoidCallback? onTap,
    VoidCallback? onMorePressed,
  }) {
    return PipelineCard(
      key: key,
      title: 'Sales Pipeline',
      subtitle: 'Deals by Stage',
      stages: stages,
      onTap: onTap,
      onMorePressed: onMorePressed,
    );
  }
}

/// Individual pipeline stage item widget
class _PipelineStageItem extends StatelessWidget {
  final PipelineStageData stage;

  const _PipelineStageItem({
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stage.name,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                stage.value,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          AppSpacing.gapV1,
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: AppSpacing.borderRadiusFull,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      width: constraints.maxWidth * stage.progress,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getProgressColor(stage.progress),
                        borderRadius: AppSpacing.borderRadiusFull,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.7) {
      return AppColors.success;
    } else if (progress >= 0.4) {
      return AppColors.secondary500;
    } else if (progress >= 0.2) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }
}