import 'package:flutter/foundation.dart';
import '../models/deal_model.dart';
import '../services/deal_service.dart';

enum DealsViewState { initial, loading, loaded, error }

class DealsViewModel extends ChangeNotifier {
  final DealService _dealService;

  DealsViewModel(this._dealService);

  DealsViewState _state = DealsViewState.initial;
  List<Deal> _deals = [];
  List<Deal> _filteredDeals = [];
  DealStatus? _selectedStatusFilter;
  String _searchQuery = '';
  String _errorMessage = '';
  String _sortBy = 'value';
  DealsViewState get state => _state;
  List<Deal> get deals => _filteredDeals;
  List<Deal> get allDeals => _deals;
  DealStatus? get selectedStatusFilter => _selectedStatusFilter;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == DealsViewState.loading;
  bool get hasError => _state == DealsViewState.error;
  bool get isLoaded => _state == DealsViewState.loaded;
  Future<void> loadDeals() async {
    _setState(DealsViewState.loading);
    try {
      _deals = [];
      _applyFiltersAndSort();
      _setState(DealsViewState.loaded);
    } catch (e) {
      _setError(e.toString());
    }
  }
  Future<void> createDeal(Deal deal) async {
    try {
      _deals.add(deal);
      _applyFiltersAndSort();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }
  Future<void> updateDeal(Deal deal) async {
    try {
      final index = _deals.indexWhere((d) => d.id == deal.id);
      if (index != -1) {
        _deals[index] = deal;
        _applyFiltersAndSort();
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }
  Future<void> deleteDeal(String dealId) async {
    try {
      _deals.removeWhere((deal) => deal.id == dealId);
      _applyFiltersAndSort();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }
  void setStatusFilter(DealStatus? status) {
    _selectedStatusFilter = status;
    _applyFiltersAndSort();
    notifyListeners();
  }
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFiltersAndSort();
    notifyListeners();
  }
  void updateSearchQuery(String query) {
    setSearchQuery(query);
  }
  int get totalDeals => _deals.length;
  double get totalValue => _deals.fold(0.0, (sum, deal) => sum + deal.value);
  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    _applyFiltersAndSort();
    notifyListeners();
  }
  void clearFilters() {
    _selectedStatusFilter = null;
    _searchQuery = '';
    _applyFiltersAndSort();
    notifyListeners();
  }
  void _applyFiltersAndSort() {
    List<Deal> filtered = List.from(_deals);
    if (_searchQuery.isNotEmpty) {
      final lowercaseQuery = _searchQuery.toLowerCase();
      filtered = filtered.where((deal) {
        return deal.title.toLowerCase().contains(lowercaseQuery) ||
               (deal.description?.toLowerCase().contains(lowercaseQuery) ?? false);
      }).toList();
    }
    if (_selectedStatusFilter != null) {
      filtered = filtered
          .where((deal) => deal.status == _selectedStatusFilter)
          .toList();
    }
    switch (_sortBy) {
      case 'value':
        filtered.sort((a, b) => b.value.compareTo(a.value));
        break;
      case 'title':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'status':
        filtered.sort(
          (a, b) => a.status.toString().compareTo(b.status.toString()),
        );
        break;
      case 'date':
        filtered.sort((a, b) {
          if (a.closeDate == null && b.closeDate == null) return 0;
          if (a.closeDate == null) return 1;
          if (b.closeDate == null) return -1;
          return a.closeDate!.compareTo(b.closeDate!);
        });
        break;
    }
    _filteredDeals = filtered;
  }
  void _setState(DealsViewState newState) {
    _state = newState;
    notifyListeners();
  }
  void _setError(String message) {
    _state = DealsViewState.error;
    _errorMessage = message;
    notifyListeners();
  }
  Deal? getDealById(String id) {
    try {
      return _deals.firstWhere((deal) => deal.id == id);
    } catch (e) {
      return null;
    }
  }
  List<Deal> getDealsByStatus(DealStatus status) {
    return _deals.where((deal) => deal.status == status).toList();
  }
  double get totalDealValue =>
      _deals.fold(0.0, (sum, deal) => sum + deal.value);
  double get filteredDealValue =>
      _filteredDeals.fold(0.0, (sum, deal) => sum + deal.value);
  double getDealValueByStatus(DealStatus status) {
    return getDealsByStatus(status).fold(0.0, (sum, deal) => sum + deal.value);
  }
  int get totalDealsCount => _deals.length;
  int get filteredDealsCount => _filteredDeals.length;
  int getDealsCountByStatus(DealStatus status) {
    return getDealsByStatus(status).length;
  }
  Map<DealStatus, int> get dealCountByStatus {
    final Map<DealStatus, int> statusCount = {};
    for (final status in DealStatus.values) {
      statusCount[status] = getDealsCountByStatus(status);
    }
    return statusCount;
  }
  Map<DealStatus, double> get dealValueByStatus {
    final Map<DealStatus, double> statusValue = {};
    for (final status in DealStatus.values) {
      statusValue[status] = getDealValueByStatus(status);
    }
    return statusValue;
  }
  double get averageDealValue {
    if (_deals.isEmpty) return 0.0;
    return totalDealValue / _deals.length;
  }
  List<Deal> get highValueDeals {
    final avgValue = averageDealValue;
    return _deals.where((deal) => deal.value > avgValue).toList();
  }
  double get winRate {
    final closedDeals = getDealsCountByStatus(DealStatus.closed);
    final lostDeals = getDealsCountByStatus(DealStatus.lost);
    final totalConcluded = closedDeals + lostDeals;
    if (totalConcluded == 0) return 0.0;
    return (closedDeals / totalConcluded) * 100;
  }
}
