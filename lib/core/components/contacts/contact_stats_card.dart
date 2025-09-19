import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class ContactStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? backgroundColor;

  const ContactStatsCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: backgroundColor,
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
              if (icon != null) ...[
                Icon(icon, size: AppSizes.iconS, color: AppColors.grey600),
                const SizedBox(width: AppSizes.paddingS),
              ],
              Text(
                title,
                style: AppTextStyles.statTitle.copyWith(color: AppColors.grey600),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            value,
            style: AppTextStyles.statValue,
          ),
        ],
      ),
    );
  }
}