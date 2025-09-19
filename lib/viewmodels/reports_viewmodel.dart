import 'package:flutter/foundation.dart';
import '../models/deal_model.dart';
import '../models/contact_model.dart';
import '../models/task_model.dart';
import '../models/meeting_model.dart';
import '../services/deal_service.dart';
import '../services/contact_service.dart';
import '../services/task_service.dart';
import '../services/meeting_service.dart';

enum ReportsViewState { initial, loading, loaded, error }

class ReportsViewModel extends ChangeNotifier {
  final DealService _dealService;
  final ContactService _contactService;
  final TaskService _taskService;
  final MeetingService _meetingService;

  ReportsViewModel({
    required DealService dealService,
    required ContactService contactService,
    required TaskService taskService,
    required MeetingService meetingService,
  }) : _dealService = dealService,
       _contactService = contactService,
       _taskService = taskService,
       _meetingService = meetingService;
  ReportsViewState _state = ReportsViewState.initial;
  List<Deal> _deals = [];
  List<Contact> _contacts = [];
  List<Task> _tasks = [];
  List<Meeting> _meetings = [];
  String _errorMessage = '';
  String _selectedPeriod = 'This Month'; // This Month, Last Month, This Year
  ReportsViewState get state => _state;
  List<Deal> get deals => _deals;
  List<Contact> get contacts => _contacts;
  List<Task> get tasks => _tasks;
  List<Meeting> get meetings => _meetings;
  String get errorMessage => _errorMessage;
  String get selectedPeriod => _selectedPeriod;
  bool get isLoading => _state == ReportsViewState.loading;
  bool get hasError => _state == ReportsViewState.error;
  bool get isLoaded => _state == ReportsViewState.loaded;
  Future<void> loadReportsData() async {
    _setState(ReportsViewState.loading);
    try {
      _deals = [];
      _contacts = [];
      _tasks = [];
      _meetings = [];
      _setState(ReportsViewState.loaded);
    } catch (e) {
      _setError(e.toString());
    }
  }
  void changePeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
  }
  double get totalRevenue {
    return _deals
        .where((deal) => deal.status == DealStatus.closed)
        .fold(0.0, (sum, deal) => sum + deal.value);
  }
  int get totalDeals => _deals.length;
  int get closedDeals =>
      _deals.where((deal) => deal.status == DealStatus.closed).length;
  int get totalContacts => _contacts.length;
  int get completedTasks => _tasks.where((task) => task.isCompleted).length;
  int get totalTasks => _tasks.length;
  int get totalMeetings => _meetings.length;
  double get dealConversionRate {
    if (totalDeals == 0) return 0.0;
    return (closedDeals / totalDeals) * 100;
  }
  double get taskCompletionRate {
    if (totalTasks == 0) return 0.0;
    return (completedTasks / totalTasks) * 100;
  }
  double get pendingRevenue {
    return _deals
        .where((deal) => deal.status == DealStatus.prospect)
        .fold(0.0, (sum, deal) => sum + deal.value);
  }
  double get negotiationRevenue {
    return _deals
        .where((deal) => deal.status == DealStatus.negotiation)
        .fold(0.0, (sum, deal) => sum + deal.value);
  }
  void _setState(ReportsViewState newState) {
    _state = newState;
    notifyListeners();
  }
  void _setError(String message) {
    _state = ReportsViewState.error;
    _errorMessage = message;
    notifyListeners();
  }
  Map<String, double> get revenueByMonth {
    final Map<String, double> monthlyRevenue = {};
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    for (int i = 0; i < 12; i++) {
      monthlyRevenue[months[i]] = 0.0;
    }
    for (int i = 0; i < _deals.length; i++) {
      final deal = _deals[i];
      if (deal.status == DealStatus.closed) {
        final monthIndex = i % 12;
        monthlyRevenue[months[monthIndex]] =
            (monthlyRevenue[months[monthIndex]] ?? 0.0) + deal.value;
      }
    }
    return monthlyRevenue;
  }
  Map<String, int> get dealsByStatus {
    return {
      'Prospect': _deals
          .where((deal) => deal.status == DealStatus.prospect)
          .length,
      'Negotiation': _deals
          .where((deal) => deal.status == DealStatus.negotiation)
          .length,
      'Closed': _deals.where((deal) => deal.status == DealStatus.closed).length,
    };
  }
}
