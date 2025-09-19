import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/deals_viewmodel.dart';
import '../../../models/deal_model.dart';

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
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${viewModel.errorMessage}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => viewModel.loadDeals(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9500).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.handshake,
                      color: Color(0xFFFF9500),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Deals',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  FloatingActionButton(
                    onPressed: () => _showAddDealDialog(viewModel),
                    backgroundColor: const Color(0xFFFF9500),
                    mini: true,
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ],
              ),

              const SizedBox(height: 24),


              TextField(
                onChanged: viewModel.updateSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search deals...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),

              const SizedBox(height: 24),


              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Deals',
                      viewModel.totalDeals.toString(),
                      Icons.handshake,
                      const Color(0xFFFF9500),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Total Value',
                      '\$${viewModel.totalValue.toStringAsFixed(0)}',
                      Icons.attach_money,
                      const Color(0xFF34C759),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),


              if (viewModel.deals.isEmpty)
                const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.handshake_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No deals found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: viewModel.deals.length,
                  itemBuilder: (context, index) {
                    final deal = viewModel.deals[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getStatusColor(deal.status),
                          child: const Icon(
                            Icons.handshake,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          deal.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\$${deal.value.toStringAsFixed(2)}'),
                            Text(deal.status.displayName),
                            if (deal.description != null)
                              Text(deal.description!),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'delete') {
                              viewModel.deleteDeal(deal.id);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(DealStatus status) {
    switch (status) {
      case DealStatus.prospect:
        return Colors.blue;
      case DealStatus.qualified:
        return Colors.orange;
      case DealStatus.proposal:
        return Colors.purple;
      case DealStatus.negotiation:
        return Colors.amber;
      case DealStatus.closed:
        return Colors.green;
      case DealStatus.lost:
        return Colors.red;
    }
  }

  void _showAddDealDialog(DealsViewModel viewModel) {
    final titleController = TextEditingController();
    final valueController = TextEditingController();
    final descriptionController = TextEditingController();
    DealStatus selectedStatus = DealStatus.prospect;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Deal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Value *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<DealStatus>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
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
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
                if (titleController.text.isNotEmpty &&
                    valueController.text.isNotEmpty) {
                  final deal = Deal(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    value: double.tryParse(valueController.text) ?? 0.0,
                    status: selectedStatus,
                    description: descriptionController.text.isEmpty
                        ? null
                        : descriptionController.text,
                  );
                  viewModel.createDeal(deal);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
