import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/deal_model.dart';
import '../viewmodels/deals_viewmodel.dart';
import '../core/components/layout/page_container.dart';
import '../core/components/layout/empty_state.dart';
import '../core/components/cards/deal_card.dart' as card_deal;
import '../core/components/cards/stat_card.dart';
import '../core/theme/app_spacing.dart';
import 'deal_detail_view.dart';
import 'modals/add_deal_modal.dart';

class DealsView extends StatefulWidget {
  const DealsView({super.key});

  @override
  State<DealsView> createState() => _DealsViewState();
}

class _DealsViewState extends State<DealsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DealsViewModel>().loadDeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DealsViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddDealModal(viewModel),
          child: const Icon(Icons.add),
        ),
          body: PageContainer(
            scrollable: false,
            child: CustomScrollView(
              slivers: [
                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: TextField(
                      onChanged: viewModel.updateSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search deals...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        contentPadding: AppSpacing.inputPadding,
                      ),
                    ),
                  ),
                ),
                
                // Stats Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: Row(
                      children: [
                        Expanded(
                          child: StatCard.deals(
                            value: viewModel.totalDeals.toString(),
                            onTap: () => print('Deals stat tapped'),
                          ),
                        ),
                        AppSpacing.gapH3,
                        Expanded(
                          child: StatCard.revenue(
                            value: '\$${_formatLargeNumber(viewModel.totalValue)}',
                            onTap: () => print('Revenue stat tapped'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Spacing
                SliverToBoxAdapter(
                  child: AppSpacing.gapV4,
                ),
                
                // Loading State
                if (viewModel.isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                
                // Error State
                if (viewModel.hasError && !viewModel.isLoading)
                  SliverFillRemaining(
                    child: EmptyState.error(
                      message: viewModel.errorMessage ?? 'Failed to load deals',
                      onRetry: viewModel.loadDeals,
                    ),
                  ),
                
                // Empty State
                if (viewModel.deals.isEmpty && !viewModel.isLoading && !viewModel.hasError)
                  const SliverFillRemaining(
                    child: EmptyState(
                      iconData: Icons.handshake_outlined,
                      title: 'No deals yet',
                      message: 'Create your first deal to get started',
                    ),
                  ),
                
                // Deals List
                if (viewModel.deals.isNotEmpty && !viewModel.isLoading && !viewModel.hasError)
                  SliverPadding(
                    padding: AppSpacing.screenPadding,
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final deal = viewModel.deals[index];
                          return card_deal.DealCard.fromModel(
                            id: deal.id,
                            title: deal.title,
                            value: deal.value,
                            description: deal.description,
                            status: _mapDealStatus(deal.status),
                            closeDate: deal.closeDate,
                            onTap: () => _navigateToDealDetail(deal),
                          onEdit: () => _showEditDealModal(viewModel, deal),
                            onStatusChange: () => _showStatusChangeDialog(viewModel, deal),
                            onDelete: () => _showDeleteConfirmation(viewModel, deal),
                          );
                        },
                        childCount: viewModel.deals.length,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Utility methods for new architecture
  String _formatLargeNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }

  card_deal.DealStatus _mapDealStatus(DealStatus status) {
    switch (status) {
      case DealStatus.prospect:
        return card_deal.DealStatus.prospect;
      case DealStatus.qualified:
        return card_deal.DealStatus.qualified;
      case DealStatus.proposal:
        return card_deal.DealStatus.proposal;
      case DealStatus.negotiation:
        return card_deal.DealStatus.negotiation;
      case DealStatus.closed:
        return card_deal.DealStatus.closed;
      case DealStatus.lost:
        return card_deal.DealStatus.lost;
    }
  }

  // Navigation and action methods
  void _navigateToDealDetail(Deal deal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DealDetailView(deal: deal),
      ),
    );
  }

  void _showEditDealModal(DealsViewModel viewModel, Deal deal) async {
    final result = await Navigator.push<Deal>(
      context,
      MaterialPageRoute(
        builder: (context) => AddDealModal(
          deal: deal,
          onSave: (updatedDeal) {
            // TODO: viewModel.updateDeal(updatedDeal);
            print('Update deal: ${updatedDeal.title}');
          },
        ),
        fullscreenDialog: true,
      ),
    );
    
    if (result != null) {
      // Deal was updated successfully
    }
  }

  void _showAddDealModal(DealsViewModel viewModel) async {
    final result = await Navigator.push<Deal>(
      context,
      MaterialPageRoute(
        builder: (context) => AddDealModal(
          onSave: (deal) {
            viewModel.createDeal(deal);
          },
        ),
        fullscreenDialog: true,
      ),
    );
    
    if (result != null) {
      // Deal was saved successfully
    }
  }

  void _showStatusChangeDialog(DealsViewModel viewModel, Deal deal) {
    DealStatus selectedStatus = deal.status;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Change Deal Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Deal: ${deal.title}'),
              const SizedBox(height: 16),
              DropdownButtonFormField<DealStatus>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'New Status',
                  border: OutlineInputBorder(),
                ),
                items: DealStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.displayName),
                  );
                }).toList(),
                onChanged: (DealStatus? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedStatus = newValue;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement status change functionality
                print('Change status for ${deal.title} to ${selectedStatus.displayName}');
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(DealsViewModel viewModel, Deal deal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Deal'),
        content: Text('Are you sure you want to delete "${deal.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.deleteDeal(deal.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
