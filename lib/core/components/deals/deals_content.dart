import 'package:flutter/material.dart';
import '../../../viewmodels/deals_viewmodel.dart';
import '../../../models/deal_model.dart';
import '../../constants/app_constants.dart';
import '../common/generic_metric_card.dart';
import '../deals/deals_list.dart';
import '../modal/add_deal_modal.dart';
import '../modal/delete_deal_dialog.dart';

class DealsContent extends StatelessWidget {
  final DealsViewModel viewModel;
  final VoidCallback onAddDeal;

  const DealsContent({
    super.key,
    required this.viewModel,
    required this.onAddDeal,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GenericMetricCard.stats(
                  title: AppStrings.totalDeals,
                  value: '${viewModel.totalDealsCount}',
                  icon: Icons.handshake,
                  iconColor: const Color(0xFFFF9500),
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: GenericMetricCard.stats(
                  title: AppStrings.totalValue,
                  value: '\$${viewModel.totalValue.toStringAsFixed(0)}',
                  icon: Icons.attach_money,
                  iconColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingL),
          DealsList(
            deals: viewModel.deals,
            onEditDeal: (deal) => _showEditDealDialog(context, viewModel, deal),
            onDeleteDeal: (deal) => _showDeleteConfirmationDialog(context, viewModel, deal),
            onAddDeal: onAddDeal,
          ),
        ],
      ),
    );
  }

  void _showEditDealDialog(BuildContext context, DealsViewModel viewModel, Deal deal) {
    showDialog(
      context: context,
      builder: (context) => AddDealModal(
        viewModel: viewModel,
        existingDeal: deal,
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, DealsViewModel viewModel, Deal deal) {
    showDialog(
      context: context,
      builder: (context) => DeleteDealDialog(
        viewModel: viewModel,
        deal: deal,
      ),
    );
  }
}