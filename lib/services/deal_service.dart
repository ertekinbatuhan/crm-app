import '../models/deal_model.dart';

abstract class DealService {
  Future<List<Deal>> getDeals();
  Future<Deal> createDeal(Deal deal);
  Future<Deal> updateDeal(Deal deal);
  Future<void> deleteDeal(String dealId);
}

class DealServiceImpl implements DealService {
  final List<Deal> _deals = [
    const Deal(
      id: '1',
      title: 'Website Redesign Project',
      value: 45000.0,
      description: 'Complete website redesign for Tech Solutions Inc.',
      status: DealStatus.negotiation,
      closeDate: null,
    ),
    const Deal(
      id: '2',
      title: 'Marketing Campaign',
      value: 12000.0,
      description: 'Q4 digital marketing campaign for Digital Marketing Pro',
      status: DealStatus.proposal,
      closeDate: null,
    ),
    const Deal(
      id: '3',
      title: 'Brand Identity Package',
      value: 8500.0,
      description: 'Complete brand identity design for Creative Designs LLC',
      status: DealStatus.qualified,
      closeDate: null,
    ),
    const Deal(
      id: '4',
      title: 'Startup Hub Consultation',
      value: 15000.0,
      description: 'Business consultation services for Startup Hub',
      status: DealStatus.prospect,
      closeDate: null,
    ),
    const Deal(
      id: '5',
      title: 'Innovation Labs Project',
      value: 75000.0,
      description: 'Custom development project for Innovation Labs',
      status: DealStatus.proposal,
      closeDate: null,
    ),
  ];

  @override
  Future<List<Deal>> getDeals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_deals);
  }

  @override
  Future<Deal> createDeal(Deal deal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newDeal = Deal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: deal.title,
      value: deal.value,
      description: deal.description,
      status: deal.status,
      closeDate: deal.closeDate,
    );
    _deals.add(newDeal);
    return newDeal;
  }

  @override
  Future<Deal> updateDeal(Deal deal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _deals.indexWhere((d) => d.id == deal.id);
    if (index != -1) {
      _deals[index] = deal;
      return deal;
    }
    throw Exception('Deal not found');
  }

  @override
  Future<void> deleteDeal(String dealId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _deals.removeWhere((deal) => deal.id == dealId);
  }
}
