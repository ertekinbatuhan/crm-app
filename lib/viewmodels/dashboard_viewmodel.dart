import 'package:flutter/foundation.dart';
import '../../models/task_model.dart';
import '../../models/contact_model.dart';
import '../../models/deal_model.dart';
import '../../models/meeting_model.dart';
import '../../services/task_service.dart';
import '../../services/contact_service.dart';
import '../../services/deal_service.dart';
import '../../services/meeting_service.dart';

enum DashboardViewState { initial, loading, loaded, error }

class DashboardViewModel extends ChangeNotifier {
  final TaskService _taskService;
  final ContactService _contactService;
  final DealService _dealService;
  final MeetingService _meetingService;

  DashboardViewModel({
    required TaskService taskService,
    required ContactService contactService,
    required DealService dealService,
    required MeetingService meetingService,
  }) : _taskService = taskService,
       _contactService = contactService,
       _dealService = dealService,
       _meetingService = meetingService;

  // State
  DashboardViewState _state = DashboardViewState.initial;
  List<Task> _recentTasks = [];
  List<Contact> _recentContacts = [];
  List<Deal> _recentDeals = [];
  List<Meeting> _upcomingMeetings = [];
  String _errorMessage = '';

  // Getters
  DashboardViewState get state => _state;
  List<Task> get recentTasks => _recentTasks;
  List<Contact> get recentContacts => _recentContacts;
  List<Deal> get recentDeals => _recentDeals;
  List<Meeting> get upcomingMeetings => _upcomingMeetings;
  String get errorMessage => _errorMessage;

  bool get isLoading => _state == DashboardViewState.loading;
  bool get hasError => _state == DashboardViewState.error;
  bool get isLoaded => _state == DashboardViewState.loaded;

  // Dashboard specific business logic
  Future<void> loadDashboardData() async {
    _setState(DashboardViewState.loading);
    try {
      // Load all dashboard data in parallel
      final results = await Future.wait([
        _taskService.getTasks(),
        _contactService.getContacts(),
        _dealService.getDeals(),
        _meetingService.getMeetings(),
      ]);

      _recentTasks = (results[0] as List<Task>).take(5).toList();
      _recentContacts = (results[1] as List<Contact>).take(5).toList();
      _recentDeals = (results[2] as List<Deal>).take(5).toList();
      _upcomingMeetings = (results[3] as List<Meeting>)
          .where((meeting) => meeting.startTime.isAfter(DateTime.now()))
          .take(3)
          .toList();

      _setState(DashboardViewState.loaded);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Helper methods
  void _setState(DashboardViewState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String message) {
    _state = DashboardViewState.error;
    _errorMessage = message;
    notifyListeners();
  }

  // Dashboard analytics
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
  int get todayMeetings =>
      _upcomingMeetings.where((meeting) => _isToday(meeting.startTime)).length;

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
