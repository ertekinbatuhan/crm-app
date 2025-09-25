import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class DealStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  
  const DealStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: AppSizes.elevationM,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSizes.iconM),
              const SizedBox(width: AppSizes.paddingS),
              Text(
                title,
                style: AppTextStyles.statTitle.copyWith(color: AppColors.grey),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            value,
            style: AppTextStyles.statValue,
          ),
        ],
      ),
    );
  }
}