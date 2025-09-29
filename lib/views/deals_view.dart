import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/deals_viewmodel.dart';
import '../models/deal_model.dart';
import '../core/components/deals/deal_search_bar.dart';
import '../core/components/deals/deals_content.dart';
import '../core/components/view_state_handler.dart';
import '../core/components/modal/add_deal_modal.dart';
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
              child: ListViewStateHandler<Deal>(
                state: _mapDealsStateToViewState(viewModel.state.viewState),
                items: viewModel.deals,
                loadingMessage: AppStrings.loadingDeals,
                emptyTitle: AppStrings.noDealsFound,
                emptySubtitle: AppStrings.startByAddingDeal,
                emptyIcon: Icons.handshake_outlined,
                emptyActionLabel: AppStrings.addDeal,
                onEmptyAction: showAddDealDialog,
                errorMessage: viewModel.errorMessage,
                onRetry: () {
                  // Stream will automatically retry on error
                },
                listBuilder: (deals) => DealsContent(
                  viewModel: viewModel,
                  onAddDeal: showAddDealDialog,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  ViewState _mapDealsStateToViewState(DealsViewState dealState) {
    switch (dealState) {
      case DealsViewState.loading:
        return ViewState.loading;
      case DealsViewState.loaded:
        return ViewState.success;
      case DealsViewState.error:
        return ViewState.error;
      case DealsViewState.initial:
        return ViewState.loading;
    }
  }
}
