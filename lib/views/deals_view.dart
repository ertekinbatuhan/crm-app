import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/deals_viewmodel.dart';
import '../models/deal_model.dart';
import '../core/components/deals/deal_search_bar.dart';
import '../core/components/deals/deal_stats_card.dart';
import '../core/components/deals/deals_list.dart';
import '../core/components/deals/deals_loading_state.dart';
import '../core/components/deals/deals_error_state.dart';
import '../core/components/modal/add_deal_modal.dart';
import '../core/components/modal/delete_deal_dialog.dart';
import '../core/constants/app_constants.dart';

class DealsView extends StatefulWidget {
  const DealsView({super.key});

  @override
  State<DealsView> createState() => DealsViewWidgetState();
}

class DealsViewWidgetState extends State<DealsView> {
  void showAddDealDialog() {
    final viewModel = context.read<DealsViewModel>();
    showDialog(
      context: context,
      builder: (context) => AddDealModal(viewModel: viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DealsViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            DealSearchBar(
              onChanged: viewModel.updateSearchQuery,
            ),
            Expanded(
              child: _buildContent(viewModel),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(DealsViewModel viewModel) {
    if (viewModel.isLoading) {
      return const DealsLoadingState(
        message: AppStrings.loadingDeals,
      );
    }

    if (viewModel.hasError) {
      return DealsErrorState(
        message: viewModel.errorMessage,
        onRetry: () {
          // Stream will automatically retry on error
        },
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DealStatsCard(
                  title: AppStrings.totalDeals,
                  value: '${viewModel.totalDealsCount}',
                  icon: Icons.handshake,
                  color: const Color(0xFFFF9500),
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: DealStatsCard(
                  title: AppStrings.totalValue,
                  value: '\$${viewModel.totalValue.toStringAsFixed(0)}',
                  icon: Icons.attach_money,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingL),
          DealsList(
            deals: viewModel.deals,
            onEditDeal: (deal) => _showEditDealDialog(viewModel, deal),
            onDeleteDeal: (deal) => _showDeleteConfirmationDialog(viewModel, deal),
            onAddDeal: showAddDealDialog,
          ),
        ],
      ),
    );
  }

  void _showEditDealDialog(DealsViewModel viewModel, Deal deal) {
    showDialog(
      context: context,
      builder: (context) => AddDealModal(
        viewModel: viewModel,
        existingDeal: deal,
      ),
    );
  }

  void _showDeleteConfirmationDialog(DealsViewModel viewModel, Deal deal) {
    showDialog(
      context: context,
      builder: (context) => DeleteDealDialog(
        viewModel: viewModel,
        deal: deal,
      ),
    );
  }
}
