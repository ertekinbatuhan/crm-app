import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show DateTimeRange;
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

  StreamSubscription<List<Deal>>? _dealsSubscription;
  StreamSubscription<List<Contact>>? _contactsSubscription;
  StreamSubscription<List<Task>>? _tasksSubscription;
  StreamSubscription<List<Meeting>>? _meetingsSubscription;

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
  List<Deal> get deals => _filteredDeals;
  List<Contact> get contacts => _filteredContacts;
  List<Task> get tasks => _filteredTasks;
  List<Meeting> get meetings => _filteredMeetings;
  String get errorMessage => _errorMessage;
  String get selectedPeriod => _selectedPeriod;
  bool get isLoading => _state == ReportsViewState.loading;
  bool get hasError => _state == ReportsViewState.error;
  bool get isLoaded => _state == ReportsViewState.loaded;

  List<Deal> _filteredDeals = [];
  List<Contact> _filteredContacts = [];
  List<Task> _filteredTasks = [];
  List<Meeting> _filteredMeetings = [];

  Future<void> loadReportsData() async {
    if (_state == ReportsViewState.initial) {
      _setState(ReportsViewState.loading);
    }
    _listenToStreams();
    _applyFilters();
  }

  void _listenToStreams() {
    _dealsSubscription ??= _dealService.getDealsStream().listen(
      _onDealsUpdated,
      onError: _onError,
    );
    _contactsSubscription ??= _contactService.getContactsStream().listen(
      _onContactsUpdated,
      onError: _onError,
    );
    _tasksSubscription ??= _taskService.getTasksStream().listen(
      _onTasksUpdated,
      onError: _onError,
    );
    _meetingsSubscription ??= _meetingService.getMeetingsStream().listen(
      _onMeetingsUpdated,
      onError: _onError,
    );
  }

  void _onDealsUpdated(List<Deal> deals) {
    _deals = deals;
    _applyFilters();
  }

  void _onContactsUpdated(List<Contact> contacts) {
    _contacts = contacts;
    _applyFilters();
  }

  void _onTasksUpdated(List<Task> tasks) {
    _tasks = tasks;
    _applyFilters();
  }

  void _onMeetingsUpdated(List<Meeting> meetings) {
    _meetings = meetings;
    _applyFilters();
  }

  void _applyFilters() {
    if (_deals.isEmpty &&
        _contacts.isEmpty &&
        _tasks.isEmpty &&
        _meetings.isEmpty) {
      if (_state != ReportsViewState.loading) {
        _setState(ReportsViewState.loading);
      }
      return;
    }

    final now = DateTime.now();
    final periodRange = _getPeriodRange(now);

    _filteredDeals = _deals.where((deal) {
      final date = deal.createdAt ?? deal.updatedAt ?? deal.closeDate;
      if (date == null) return true;
      return _isWithinPeriod(date, periodRange);
    }).toList();

    _filteredContacts = _contacts.where((contact) {
      final date = contact.createdAt ?? contact.updatedAt;
      if (date == null) return true;
      return _isWithinPeriod(date, periodRange);
    }).toList();

    _filteredTasks = _tasks.where((task) {
      final date = task.createdAt ?? task.updatedAt ?? task.dueDate;
      if (date == null) return true;
      return _isWithinPeriod(date, periodRange);
    }).toList();

    _filteredMeetings = _meetings
        .where((meeting) => _isWithinPeriod(meeting.startTime, periodRange))
        .toList();

    _setState(ReportsViewState.loaded);
  }

  void _onError(Object error) {
    _setError(error.toString());
  }

  void changePeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
    _applyFilters();
  }

  double get totalRevenue {
    return deals
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

    for (final month in months) {
      monthlyRevenue[month] = 0.0;
    }

    for (final deal in _deals) {
      if (deal.status == DealStatus.closed && deal.closeDate != null) {
        final monthIndex = deal.closeDate!.month - 1;
        final key = months[monthIndex];
        monthlyRevenue[key] = (monthlyRevenue[key] ?? 0.0) + deal.value;
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
      'Closed': closedDeals,
      'Lost': _deals.where((deal) => deal.status == DealStatus.lost).length,
    };
  }

  double get averageDealValue {
    if (closedDeals == 0) return 0.0;
    return totalRevenue / closedDeals;
  }

  Map<String, int> get tasksByType {
    final result = <String, int>{};
    for (final task in _tasks) {
      final key = task.type.displayName;
      result[key] = (result[key] ?? 0) + 1;
    }
    return result;
  }

  Map<String, int> get meetingsByType {
    final result = <String, int>{};
    for (final meeting in _meetings) {
      final key = meeting.type.displayName;
      result[key] = (result[key] ?? 0) + 1;
    }
    return result;
  }

  Map<String, int> get contactsByCompany {
    final result = <String, int>{};
    for (final contact in _contacts) {
      final key = contact.company ?? 'Bilinmiyor';
      result[key] = (result[key] ?? 0) + 1;
    }
    return result;
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

  DateTimeRange _getPeriodRange(DateTime reference) {
    switch (_selectedPeriod) {
      case 'Last Month':
        final start = DateTime(reference.year, reference.month - 1, 1);
        final end = DateTime(reference.year, reference.month, 1);
        return DateTimeRange(start: start, end: end);
      case 'This Year':
        final start = DateTime(reference.year, 1, 1);
        final end = DateTime(reference.year + 1, 1, 1);
        return DateTimeRange(start: start, end: end);
      case 'This Month':
      default:
        final start = DateTime(reference.year, reference.month, 1);
        final end = DateTime(reference.year, reference.month + 1, 1);
        return DateTimeRange(start: start, end: end);
    }
  }

  bool _isWithinPeriod(DateTime date, DateTimeRange range) {
    return !date.isBefore(range.start) && date.isBefore(range.end);
  }

  @override
  void dispose() {
    _dealsSubscription?.cancel();
    _contactsSubscription?.cancel();
    _tasksSubscription?.cancel();
    _meetingsSubscription?.cancel();
    super.dispose();
  }
}
