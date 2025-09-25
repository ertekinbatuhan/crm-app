import '../../models/deal_model.dart';
import '../../services/deal_service.dart';

abstract class DealRepository {
  Future<List<Deal>> getDeals();
  Stream<List<Deal>> getDealsStream();
  Future<Deal> createDeal(Deal deal);
  Future<Deal> updateDeal(Deal deal);
  Future<void> deleteDeal(String dealId);
  Future<List<Deal>> searchDeals(String query);
  void clearCache();
  bool get hasCache;
}

class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const Result.success(this.data) : error = null, isSuccess = true;
  const Result.error(this.error) : data = null, isSuccess = false;
}

class DealRepositoryImpl implements DealRepository {
  final DealService _dealService;
  List<Deal>? _cachedDeals;
  DateTime? _lastCacheTime;
  static const Duration _cacheTimeout = Duration(minutes: 5);

  DealRepositoryImpl(this._dealService);

  @override
  bool get hasCache => _cachedDeals != null && _isCacheValid();

  bool _isCacheValid() {
    if (_lastCacheTime == null) return false;
    return DateTime.now().difference(_lastCacheTime!) < _cacheTimeout;
  }

  @override
  void clearCache() {
    _cachedDeals = null;
    _lastCacheTime = null;
  }

  @override
  Future<List<Deal>> getDeals() async {
    if (hasCache) {
      return _cachedDeals!;
    }

    try {
      final deals = await _dealService.getDeals();
      _cachedDeals = deals;
      _lastCacheTime = DateTime.now();
      return deals;
    } catch (e) {
      if (_cachedDeals != null) {
        return _cachedDeals!;
      }
      rethrow;
    }
  }

  @override
  Stream<List<Deal>> getDealsStream() {
    return _dealService.getDealsStream().map((deals) {
      _cachedDeals = deals;
      _lastCacheTime = DateTime.now();
      return deals;
    });
  }

  @override
  Future<Deal> createDeal(Deal deal) async {
    final newDeal = await _dealService.createDeal(deal);
    clearCache(); 
    return newDeal;
  }

  @override
  Future<Deal> updateDeal(Deal deal) async {
    final updatedDeal = await _dealService.updateDeal(deal);
  
    clearCache(); 
    
    return updatedDeal;
  }

  @override
  Future<void> deleteDeal(String dealId) async {
    await _dealService.deleteDeal(dealId);
    clearCache();
  }

  @override
  Future<List<Deal>> searchDeals(String query) async {
    final deals = await getDeals();
    
    if (query.isEmpty) return deals;
    
    final lowercaseQuery = query.toLowerCase();
    return deals.where((deal) {
      return deal.title.toLowerCase().contains(lowercaseQuery) ||
             (deal.description?.toLowerCase().contains(lowercaseQuery) ?? false) ||
             deal.value.toString().contains(query) ||
             deal.status.displayName.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}