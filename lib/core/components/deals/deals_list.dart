import 'package:flutter/material.dart';
import '../../../models/deal_model.dart';
import '../../constants/app_constants.dart';
import '../common/action_menu.dart';
import '../../utils/date_extensions.dart';
import '../../utils/deal_extensions.dart';

class DealsList extends StatelessWidget {
  final List<Deal> deals;
  final Function(Deal) onEditDeal;
  final Function(Deal) onDeleteDeal;
  final VoidCallback onAddDeal;

  const DealsList({
    super.key,
    required this.deals,
    required this.onEditDeal,
    required this.onDeleteDeal,
    required this.onAddDeal,
  });

  @override
  Widget build(BuildContext context) {
    if (deals.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: deals.length,
      itemBuilder: (context, index) {
        final deal = deals[index];
        return _buildDealCard(deal);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.handshake_outlined,
            size: AppSizes.iconXL,
            color: AppColors.grey,
          ),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            'No deals found',
            style: AppTextStyles.emptyStateTitle.copyWith(
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            'Start by adding your first deal',
            style: AppTextStyles.emptyStateSubtitle.copyWith(
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),
          ElevatedButton.icon(
            onPressed: onAddDeal,
            icon: const Icon(Icons.add, size: AppSizes.iconM),
            label: const Text('Add Deal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9500),
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingL,
                vertical: AppSizes.paddingM,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealCard(Deal deal) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.radiusM),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSizes.paddingM),
        leading: CircleAvatar(
          backgroundColor: deal.status.statusColor,
          child: const Icon(
            Icons.handshake,
            color: AppColors.white,
            size: AppSizes.iconM,
          ),
        ),
        title: Text(deal.title, style: AppTextStyles.cardTitle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.paddingXS),
            Text(
              '\$${deal.value.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                fontSize: AppSizes.fontM,
              ),
            ),
            Text(
              deal.status.displayName,
              style: TextStyle(
                color: deal.status.statusColor,
                fontSize: AppSizes.fontS,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (deal.closeDate != null) ...[
              const SizedBox(height: AppSizes.paddingXS),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: AppColors.grey600),
                  const SizedBox(width: 4),
                  Text(
                    'Close: ${deal.closeDate!.toUserFriendlyString()}',
                    style: TextStyle(
                      color: AppColors.grey600,
                      fontSize: AppSizes.fontS,
                    ),
                  ),
                ],
              ),
            ],
            if (deal.description != null) ...[
              const SizedBox(height: AppSizes.paddingXS),
              Text(
                deal.description!,
                style: TextStyle(
                  color: AppColors.grey600,
                  fontSize: AppSizes.fontS,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: ActionMenu(
          onSelected: (action) {
            if (action == ActionMenuAction.edit) {
              onEditDeal(deal);
            } else if (action == ActionMenuAction.delete) {
              onDeleteDeal(deal);
            }
          },
        ),
      ),
    );
  }
}
