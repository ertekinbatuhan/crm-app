import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../models/meeting_model.dart';
import '../models/contact_model.dart';
import '../models/deal_model.dart';
import '../services/task_service.dart';
import '../services/meeting_service.dart';
import '../services/contact_service.dart';
import '../services/deal_service.dart';

enum TasksViewState { initial, loading, loaded, error }

class TasksViewModel extends ChangeNotifier {
  final TaskService _taskService;
  final MeetingService _meetingService;
  final ContactService _contactService;
  final DealService _dealService;

  StreamSubscription<List<Task>>? _tasksSubscription;

  TasksViewModel({
    required TaskService taskService,
    required MeetingService meetingService,
    required ContactService contactService,
    required DealService dealService,
  }) : _taskService = taskService,
       _meetingService = meetingService,
       _contactService = contactService,
       _dealService = dealService;

  // Private fields
  TasksViewState _state = TasksViewState.initial;
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  List<Meeting> _meetings = [];
  List<Meeting> _todayMeetings = [];
  List<Contact> _contacts = [];
  List<Deal> _deals = [];
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  String _errorMessage = '';
  String _selectedFilter = 'All'; // All, Today, Completed, Pending

  // Getters
  TasksViewState get state => _state;
  List<Task> get tasks => _filteredTasks;
  List<Task> get allTasks => _tasks;
  List<Meeting> get meetings => _meetings;
  List<Meeting> get todayMeetings => _todayMeetings;
  List<Contact> get contacts => _contacts;
  List<Deal> get deals => _deals;
  DateTime get selectedDate => _selectedDate;
  DateTime get currentMonth => _currentMonth;
  String get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _state == TasksViewState.loading;
  bool get hasError => _state == TasksViewState.error;
  bool get isLoaded => _state == TasksViewState.loaded;

  // Public methods
  Future<void> loadTasksData() async {
    _setState(TasksViewState.loading);
    await _tasksSubscription?.cancel();
    try {
      final results = await Future.wait([
        _taskService.getTasksStream().first,
        _meetingService.getMeetingsStream().first,
        _contactService.getContactsStream().first,
        _dealService.getDealsStream().first,
      ]);

      _tasks = (results[0] as List<Task>)..sort(_sortByDueDate);
      _meetings = results[1] as List<Meeting>;
      _contacts = results[2] as List<Contact>;
      _deals = results[3] as List<Deal>;

      _applyFilters();
      _loadTodayMeetings();
      _setState(TasksViewState.loaded);

      _tasksSubscription = _taskService.getTasksStream().listen(
        (tasks) {
          _tasks = [...tasks]..sort(_sortByDueDate);
          _applyFilters();
          _loadTodayMeetings();
          if (_state != TasksViewState.loaded) {
            _state = TasksViewState.loaded;
          }
          notifyListeners();
        },
        onError: (error) {
          _setError(error.toString());
        },
      );
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> createTask(Task task) async {
    try {
      final createdTask = await _taskService.createTask(task);
      _tasks = [..._tasks, createdTask]..sort(_sortByDueDate);
      _applyFilters();
      notifyListeners();
      return;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final updatedTask = await _taskService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        _tasks.sort(_sortByDueDate);
      } else {
        _tasks = [..._tasks, updatedTask];
        _tasks.sort(_sortByDueDate);
      }
      _applyFilters();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final updatedTask = await _taskService.toggleTaskCompletion(taskId);
      final taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (taskIndex != -1) {
        _tasks[taskIndex] = updatedTask;
        _tasks.sort(_sortByDueDate);
      }
      _applyFilters();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  void changeFilter(String filter) {
    _selectedFilter = filter;
    _applyFilters();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    _currentMonth = DateTime(date.year, date.month);
    notifyListeners();
  }

  void selectToday() {
    final today = DateTime.now();
    _selectedDate = today;
    _currentMonth = DateTime(today.year, today.month);
    notifyListeners();
  }

  void changeMonth(int increment) {
    _currentMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + increment,
    );
    notifyListeners();
  }

  // Private methods
  void _setState(TasksViewState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String message) {
    _state = TasksViewState.error;
    _errorMessage = message;
    notifyListeners();
  }

  void _applyFilters() {
    switch (_selectedFilter) {
      case 'Today':
        _filteredTasks = _tasks
            .where((task) => task.dueDate != null && isToday(task.dueDate!))
            .toList();
        break;
      case 'Completed':
        _filteredTasks = _tasks.where((task) => task.isCompleted).toList();
        break;
      case 'Pending':
        _filteredTasks = _tasks.where((task) => !task.isCompleted).toList();
        break;
      default:
        _filteredTasks = List.from(_tasks);
    }
  }

  void _loadTodayMeetings() {
    final today = DateTime.now();
    _todayMeetings = _meetings
        .where(
          (meeting) =>
              meeting.startTime.year == today.year &&
              meeting.startTime.month == today.month &&
              meeting.startTime.day == today.day,
        )
        .toList();
  }

  int _sortByDueDate(Task a, Task b) {
    if (a.dueDate == null && b.dueDate == null) {
      return a.title.compareTo(b.title);
    }
    if (a.dueDate == null) return 1;
    if (b.dueDate == null) return -1;
    return a.dueDate!.compareTo(b.dueDate!);
  }

  // Month navigation methods
  void goToNextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    notifyListeners();
  }

  void goToPreviousMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    notifyListeners();
  }

  void goToCurrentMonth() {
    _currentMonth = DateTime.now();
    notifyListeners();
  }

  // Utility methods
  bool isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  bool isSelectedDate(DateTime date) {
    return date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
  }

  bool isSameMonth(DateTime date) {
    return date.year == _currentMonth.year && date.month == _currentMonth.month;
  }

  List<DateTime> getCalendarDays() {
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    );
    final startDate = firstDayOfMonth.subtract(
      Duration(days: firstDayOfMonth.weekday - 1),
    );
    final endDate = lastDayOfMonth.add(
      Duration(days: 7 - lastDayOfMonth.weekday),
    );
    final days = <DateTime>[];
    for (
      DateTime day = startDate;
      day.isBefore(endDate.add(const Duration(days: 1)));
      day = day.add(const Duration(days: 1))
    ) {
      days.add(day);
    }
    return days;
  }

  // Computed getters
  String get monthYearString {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${monthNames[_currentMonth.month - 1]} ${_currentMonth.year}';
  }

  String get selectedDateString {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${monthNames[_selectedDate.month - 1]} ${_selectedDate.day}, ${_selectedDate.year}';
  }

  bool get isCurrentMonth {
    final now = DateTime.now();
    return _currentMonth.year == now.year && _currentMonth.month == now.month;
  }

  List<Task> get selectedDateTasks {
    return getTasksForDate(_selectedDate);
  }

  List<Meeting> get selectedDateMeetings {
    return _meetings
        .where(
          (meeting) =>
              meeting.startTime.year == _selectedDate.year &&
              meeting.startTime.month == _selectedDate.month &&
              meeting.startTime.day == _selectedDate.day,
        )
        .toList();
  }

  // Helper methods
  String getMonthYear(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  List<DateTime> getDaysInMonth(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0);
    final days = <DateTime>[];
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(date.year, date.month, i));
    }
    return days;
  }

  List<Task> getTasksForDate(DateTime date) {
    return _tasks
        .where(
          (task) =>
              task.dueDate != null &&
              task.dueDate!.year == date.year &&
              task.dueDate!.month == date.month &&
              task.dueDate!.day == date.day,
        )
        .toList();
  }

  // Statistics getters
  int get totalTasks => _tasks.length;

  int get completedTasks => _tasks.where((task) => task.isCompleted).length;

  int get pendingTasks => totalTasks - completedTasks;

  double get taskCompletionPercentage {
    if (totalTasks == 0) return 0.0;
    return (completedTasks / totalTasks) * 100;
  }

  int get todayTasksCount => _tasks
      .where((task) => task.dueDate != null && isToday(task.dueDate!))
      .length;

  int get overdueTasksCount => _tasks
      .where(
        (task) =>
            !task.isCompleted &&
            task.dueDate != null &&
            task.dueDate!.isBefore(DateTime.now()),
      )
      .length;

  List<Task> get highPriorityTasks => _tasks
      .where((task) => !task.isCompleted && task.priority == TaskPriority.high)
      .toList();

  int get completedTasksToday {
    return selectedDateTasks.where((task) => task.isCompleted).length;
  }

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }
}
