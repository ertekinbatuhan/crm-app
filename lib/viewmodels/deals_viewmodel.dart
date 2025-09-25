import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import '../models/deal_model.dart';
import '../core/repositories/deal_repository.dart';

@immutable
class DealsState extends Equatable {
  final DealsViewState viewState;
  final List<Deal> deals;
  final List<Deal> filteredDeals;
  final String searchQuery;
  final String errorMessage;
  final DealStatus? selectedStatusFilter;
  final String sortBy;

  const DealsState({
    required this.viewState,
    required this.deals,
    required this.filteredDeals,
    required this.searchQuery,
    required this.errorMessage,
    required this.selectedStatusFilter,
    required this.sortBy,
  });

  factory DealsState.initial() {
    return const DealsState(
      viewState: DealsViewState.initial,
      deals: [],
      filteredDeals: [],
      searchQuery: '',
      errorMessage: '',
      selectedStatusFilter: null,
      sortBy: 'value',
    );
  }

  DealsState copyWith({
    DealsViewState? viewState,
    List<Deal>? deals,
    List<Deal>? filteredDeals,
    String? searchQuery,
    String? errorMessage,
    DealStatus? selectedStatusFilter,
    String? sortBy,
  }) {
    return DealsState(
      viewState: viewState ?? this.viewState,
      deals: deals ?? this.deals,
      filteredDeals: filteredDeals ?? this.filteredDeals,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedStatusFilter: selectedStatusFilter,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get isLoading => viewState == DealsViewState.loading;
  bool get hasError => viewState == DealsViewState.error;
  bool get isLoaded => viewState == DealsViewState.loaded;

  @override
  List<Object?> get props => [
        viewState,
        deals,
        filteredDeals,
        searchQuery,
        errorMessage,
        selectedStatusFilter,
        sortBy,
      ];
}

enum DealsViewState { initial, loading, loaded, error }

class DealsViewModel extends ChangeNotifier {
  final DealRepository _dealRepository;
  DealsState _state = DealsState.initial();
  StreamSubscription<List<Deal>>? _dealsSubscription;

  DealsViewModel(this._dealRepository) {
    _listenToDeals();
  }

  DealsState get state => _state;

  List<Deal> get deals => _state.filteredDeals;  
  List<Deal> get allDeals => _state.deals;      
  String get searchQuery => _state.searchQuery;
  DealStatus? get selectedStatusFilter => _state.selectedStatusFilter;
  String get sortBy => _state.sortBy;
  String get errorMessage => _state.errorMessage;
  bool get isLoading => _state.isLoading;
  bool get hasError => _state.hasError;
  bool get isLoaded => _state.isLoaded;
  int get totalDealsCount => allDeals.length;    
  double get totalValue => allDeals.fold(0.0, (sum, deal) => sum + deal.value); 

  void _updateState(DealsState newState) {
    _state = newState;
    notifyListeners();
  }

  void _listenToDeals() {
    // Avoid multiple subscriptions
    if (_dealsSubscription != null) {
      _dealsSubscription?.cancel();
    }
    
    _updateState(_state.copyWith(viewState: DealsViewState.loading));
    
    _dealsSubscription = _dealRepository.getDealsStream().listen(
      (deals) {
        final filteredDeals = _applyFiltersAndSort(
          deals, 
          _state.searchQuery, 
          _state.selectedStatusFilter,
          _state.sortBy,
        );
        
        _updateState(_state.copyWith(
          viewState: DealsViewState.loaded,
          deals: deals,
          filteredDeals: filteredDeals,
          errorMessage: '',
        ));
      },
      onError: (error) {
        _updateState(_state.copyWith(
          viewState: DealsViewState.error,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  @override
  void dispose() {
    _dealsSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadDeals() async {
    _updateState(_state.copyWith(viewState: DealsViewState.loading));
    
    try {
      final deals = await _dealRepository.getDeals();
      final filteredDeals = _applyFiltersAndSort(
        deals, 
        _state.searchQuery, 
        _state.selectedStatusFilter,
        _state.sortBy,
      );
      
      _updateState(_state.copyWith(
        viewState: DealsViewState.loaded,
        deals: deals,
        filteredDeals: filteredDeals,
        errorMessage: '',
      ));
    } catch (e) {
      _updateState(_state.copyWith(
        viewState: DealsViewState.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<bool> createDeal(Deal deal) async {
    try {
      await _dealRepository.createDeal(deal);
      // Real-time stream will automatically update the state
      return true;
    } catch (e) {
      _updateState(_state.copyWith(
        viewState: DealsViewState.error,
        errorMessage: e.toString(),
      ));
      return false;
    }
  }

  Future<bool> updateDeal(Deal deal) async {
    try {
      await _dealRepository.updateDeal(deal);
      return true;
    } catch (e) {
      _updateState(_state.copyWith(
        viewState: DealsViewState.error,
        errorMessage: e.toString(),
      ));
      return false;
    }
  }

  Future<void> deleteDeal(String dealId) async {
    try {
      await _dealRepository.deleteDeal(dealId);
    } catch (e) {
      _updateState(_state.copyWith(
        viewState: DealsViewState.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void updateSearchQuery(String query) {
    final filteredDeals = _applyFiltersAndSort(
      _state.deals, 
      query, 
      _state.selectedStatusFilter,
      _state.sortBy,
    );
    
    _updateState(_state.copyWith(
      searchQuery: query,
      filteredDeals: filteredDeals,
    ));
  }

  void setStatusFilter(DealStatus? status) {
    final filteredDeals = _applyFiltersAndSort(
      _state.deals, 
      _state.searchQuery, 
      status,
      _state.sortBy,
    );
    
    _updateState(_state.copyWith(
      selectedStatusFilter: status,
      filteredDeals: filteredDeals,
    ));
  }

  void setSortBy(String sortBy) {
    final filteredDeals = _applyFiltersAndSort(
      _state.deals, 
      _state.searchQuery, 
      _state.selectedStatusFilter,
      sortBy,
    );
    
    _updateState(_state.copyWith(
      sortBy: sortBy,
      filteredDeals: filteredDeals,
    ));
  }

  void clearFilters() {
    final filteredDeals = _applyFiltersAndSort(
      _state.deals, 
      '', 
      null,
      _state.sortBy,
    );
    
    _updateState(_state.copyWith(
      selectedStatusFilter: null,
      searchQuery: '',
      filteredDeals: filteredDeals,
    ));
  }

  List<Deal> _applyFiltersAndSort(
    List<Deal> deals, 
    String searchQuery, 
    DealStatus? statusFilter,
    String sortBy,
  ) {
    List<Deal> filtered = List.from(deals);

    if (searchQuery.isNotEmpty) {
      final lowercaseQuery = searchQuery.toLowerCase();
      filtered = filtered.where((deal) {
        return deal.title.toLowerCase().contains(lowercaseQuery) ||
               (deal.description?.toLowerCase().contains(lowercaseQuery) ?? false) ||
               deal.value.toString().contains(searchQuery) ||
               deal.status.displayName.toLowerCase().contains(lowercaseQuery);
      }).toList();
    }

    if (statusFilter != null) {
      filtered = filtered
          .where((deal) => deal.status == statusFilter)
          .toList();
    }

    switch (sortBy) {
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

    return filtered;
  }

  void clearCache() {
    _dealRepository.clearCache();
  }

  void refreshDeals() {
    _dealsSubscription?.cancel();
    clearCache();
    _listenToDeals();
  }

  // Analytics methods
  Deal? getDealById(String id) {
    try {
      return _state.deals.firstWhere((deal) => deal.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Deal> getDealsByStatus(DealStatus status) {
    return _state.deals.where((deal) => deal.status == status).toList();
  }

  double get totalDealValue =>
      _state.deals.fold(0.0, (sum, deal) => sum + deal.value);

  double get filteredDealValue =>
      _state.filteredDeals.fold(0.0, (sum, deal) => sum + deal.value);

  double getDealValueByStatus(DealStatus status) {
    return getDealsByStatus(status).fold(0.0, (sum, deal) => sum + deal.value);
  }

  int get filteredDealsCount => _state.filteredDeals.length;

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
    if (_state.deals.isEmpty) return 0.0;
    return totalDealValue / _state.deals.length;
  }

  List<Deal> get highValueDeals {
    final avgValue = averageDealValue;
    return _state.deals.where((deal) => deal.value > avgValue).toList();
  }

  double get winRate {
    final closedDeals = getDealsCountByStatus(DealStatus.closed);
    final lostDeals = getDealsCountByStatus(DealStatus.lost);
    final totalConcluded = closedDeals + lostDeals;
    if (totalConcluded == 0) return 0.0;
    return (closedDeals / totalConcluded) * 100;
  }
}
