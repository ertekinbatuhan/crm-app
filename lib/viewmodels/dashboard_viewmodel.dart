import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../models/contact_model.dart';
import '../models/deal_model.dart';
import '../models/meeting_model.dart';
import '../core/repositories/contact_repository.dart';
import '../core/repositories/deal_repository.dart';
import '../core/utils/deal_extensions.dart';
import '../models/stat_model.dart';
import '../models/pipeline_model.dart';
import '../models/notification_model.dart';
import '../services/task_service.dart';
import '../services/contact_service.dart';
import '../services/deal_service.dart';
import '../services/meeting_service.dart';

enum DashboardViewState { initial, loading, loaded, error }

class DashboardViewModel extends ChangeNotifier {
  final TaskService _taskService;
  final ContactService _contactService;
  final DealService _dealService;
  final MeetingService _meetingService;

  StreamSubscription<List<Task>>? _tasksSubscription;
  StreamSubscription<List<Deal>>? _dealsSubscription;
  StreamSubscription<List<Contact>>? _contactsSubscription;
  StreamSubscription<List<Meeting>>? _meetingsSubscription;

  DashboardViewModel({
    required TaskService taskService,
    required ContactService contactService,
    required DealService dealService,
    required MeetingService meetingService,
  }) : _taskService = taskService,
       _contactService = contactService,
       _dealService = dealService,
       _meetingService = meetingService {
    _listenToStreams();
  }

  DashboardViewState _state = DashboardViewState.initial;
  List<Task> _recentTasks = [];
  List<Contact> _recentContacts = [];
  List<Deal> _recentDeals = [];
  List<Meeting> _upcomingMeetings = [];
  String _errorMessage = '';

  DashboardViewState get state => _state;
  List<Task> get recentTasks => _recentTasks;
  List<Contact> get recentContacts => _recentContacts;
  List<Deal> get recentDeals => _recentDeals;
  List<Meeting> get upcomingMeetings => _upcomingMeetings;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == DashboardViewState.loading;
  bool get hasError => _state == DashboardViewState.error;
  bool get isLoaded => _state == DashboardViewState.loaded;

  void _listenToStreams() {
    _setState(DashboardViewState.loading);

    try {
      _tasksSubscription = _taskService.getTasksStream().listen((tasks) {
        _recentTasks = tasks;
        _updateStateIfReady();
      }, onError: _handleStreamError);

      _dealsSubscription = _dealService.getDealsStream().listen((deals) {
        _recentDeals = deals;
        _updateStateIfReady();
      }, onError: _handleStreamError);

      _contactsSubscription = _contactService.getContactsStream().listen((
        contacts,
      ) {
        _recentContacts = contacts;
        _updateStateIfReady();
      }, onError: _handleStreamError);

      _meetingsSubscription = _meetingService.getMeetingsStream().listen((
        meetings,
      ) {
        _upcomingMeetings = meetings;
        _updateStateIfReady();
      }, onError: _handleStreamError);
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _updateStateIfReady() {
    if (_recentTasks.isEmpty &&
        _recentDeals.isEmpty &&
        _recentContacts.isEmpty &&
        _upcomingMeetings.isEmpty) {
      return;
    }
    _setState(DashboardViewState.loaded);
  }

  void _handleStreamError(Object error) {
    _setError(error.toString());
  }

  Future<void> loadDashboardData() async {
    // Streams already keep data updated; no-op for backward compatibility
    if (_state == DashboardViewState.initial) {
      _setState(DashboardViewState.loading);
    }
  }

  void _setState(DashboardViewState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String message) {
    _state = DashboardViewState.error;
    _errorMessage = message;
    notifyListeners();
  }

  int get totalTasks => _recentTasks.length;
  int get completedTasks =>
      _recentTasks.where((task) => task.isCompleted).length;
  int get pendingTasks => totalTasks - completedTasks;

  double get taskCompletionPercentage {
    if (totalTasks == 0) return 0.0;
    return (completedTasks / totalTasks) * 100;
  }

  double get totalDealValue =>
      _recentDeals.fold(0.0, (sum, deal) => sum + deal.value);

  int get totalContacts => _recentContacts.length;

  int get todayMeetings => _upcomingMeetings
      .where((meeting) => _isSameDay(meeting.startTime))
      .length;

  int get upcomingMeetingsCount => _upcomingMeetings.length;

  int get openDealsCount =>
      _recentDeals.where((deal) => deal.status != DealStatus.closed).length;

  int get closedDealsCount =>
      _recentDeals.where((deal) => deal.status == DealStatus.closed).length;

  double get closedDealsRevenue => _recentDeals
      .where((deal) => deal.status == DealStatus.closed)
      .fold(0.0, (sum, deal) => sum + deal.value);

  double get averageDealValue {
    if (_recentDeals.isEmpty) return 0.0;
    return totalDealValue / _recentDeals.length;
  }

  Map<String, int> get dealsByStatus {
    final Map<String, int> result = {
      'Prospect': 0,
      'Qualified': 0,
      'Proposal': 0,
      'Negotiation': 0,
      'Closed': 0,
      'Lost': 0,
    };

    for (final deal in _recentDeals) {
      final status = deal.status.displayName;
      result[status] = (result[status] ?? 0) + 1;
    }

    return result;
  }

  double get pipelineProgress {
    if (_recentDeals.isEmpty) return 0.0;
    final closed = closedDealsCount;
    return closed / _recentDeals.length;
  }

  double get upcomingMeetingsHours {
    if (_upcomingMeetings.isEmpty) return 0.0;
    final totalMinutes = _upcomingMeetings.fold<int>(
      0,
      (acc, meeting) => acc + meeting.duration.inMinutes,
    );
    return totalMinutes / 60;
  }

  String get mostActiveContactName {
    if (_recentContacts.isEmpty || _recentTasks.isEmpty) return '';

    final Map<String, int> contactTaskCounts = {};

    for (final task in _recentTasks) {
      final contactId = task.associatedContactId;
      if (contactId == null || contactId.isEmpty) continue;
      contactTaskCounts[contactId] = (contactTaskCounts[contactId] ?? 0) + 1;
    }

    if (contactTaskCounts.isEmpty) return '';

    final topContactId = contactTaskCounts.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;

    final contact = _recentContacts.firstWhere(
      (c) => c.id == topContactId,
      orElse: () => const Contact(id: '', name: ''),
    );

    return contact.id.isEmpty ? '' : contact.name;
  }

  List<Task> get highPriorityTasks => _recentTasks
      .where((task) => task.priority == TaskPriority.high && !task.isCompleted)
      .toList();

  bool _isSameDay(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  List<StatModel> get dashboardStats {
    return [
      StatModel(
        title: 'Tasks',
        value: totalTasks.toString(),
        changeValue: taskCompletionPercentage,
        isPositive: taskCompletionPercentage >= 50,
      ),
      StatModel(
        title: 'Deals',
        value: '\$${totalDealValue.toStringAsFixed(0)}',
        changeLabel: '${closedDealsCount} closed',
        isPositive: pipelineProgress >= 0.5,
      ),
      StatModel(
        title: 'Revenue',
        value: '\$${closedDealsRevenue.toStringAsFixed(0)}',
        changeLabel: '${closedDealsCount} closed deals',
        isPositive: closedDealsCount > 0,
      ),
    ];
  }

  String get totalRevenueFormatted => '\$${totalDealValue.toStringAsFixed(0)}';

  String get selectedPeriodLabel => 'Current Period';

  List<PipelineStage> get pipelineStages {
    final statusCounts = dealsByStatus;
    final total = statusCounts.values.fold<int>(0, (acc, value) => acc + value);
    if (total == 0) {
      return statusCounts.keys
          .map((status) => PipelineStage(name: status, progress: 0.0))
          .toList();
    }

    return statusCounts.entries
        .map(
          (entry) =>
              PipelineStage(name: entry.key, progress: entry.value / total),
        )
        .toList();
  }

  List<NotificationModel> get recentNotifications {
    return [
      ...highPriorityTasks
          .take(3)
          .map(
            (task) => NotificationModel(
              title: task.title,
              subtitle: task.dueDate != null
                  ? 'Due: ${_formatDate(task.dueDate!)}'
                  : 'New high priority task',
              avatar: task.title.isNotEmpty ? task.title[0].toUpperCase() : 'T',
            ),
          ),
      ...upcomingMeetings
          .take(2)
          .map(
            (meeting) => NotificationModel(
              title: meeting.title,
              subtitle:
                  'Time: ${_formatDate(meeting.startTime)} ${meeting.timeRange}',
              avatar: 'M',
            ),
          ),
    ];
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    _dealsSubscription?.cancel();
    _contactsSubscription?.cancel();
    _meetingsSubscription?.cancel();
    super.dispose();
  }
}
