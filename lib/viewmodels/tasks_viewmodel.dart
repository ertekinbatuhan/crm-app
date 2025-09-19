import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../models/meeting_model.dart';
import '../services/task_service.dart';
import '../services/meeting_service.dart';
enum TasksViewState { initial, loading, loaded, error }
class TasksViewModel extends ChangeNotifier {
  final TaskService _taskService;
  final MeetingService _meetingService;
  TasksViewModel({
    required TaskService taskService,
    required MeetingService meetingService,
  }) : _taskService = taskService,
       _meetingService = meetingService;
  TasksViewState _state = TasksViewState.initial;
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  List<Meeting> _meetings = [];
  List<Meeting> _todayMeetings = [];
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  String _errorMessage = '';
  String _selectedFilter = 'All'; // All, Today, Completed, Pending
  TasksViewState get state => _state;
  List<Task> get tasks => _filteredTasks;
  List<Task> get allTasks => _tasks;
  List<Meeting> get meetings => _meetings;
  List<Meeting> get todayMeetings => _todayMeetings;
  DateTime get selectedDate => _selectedDate;
  DateTime get currentMonth => _currentMonth;
  String get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _state == TasksViewState.loading;
  bool get hasError => _state == TasksViewState.error;
  bool get isLoaded => _state == TasksViewState.loaded;
  Future<void> loadTasksData() async {
    _setState(TasksViewState.loading);
    try {
      _tasks = [];
      _meetings = [];
      _applyFilters();
      _loadTodayMeetings();
      _setState(TasksViewState.loaded);
    } catch (e) {
      _setError(e.toString());
    }
  }
  Future<void> createTask(Task task) async {
    try {
      _tasks.add(task);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }
  Future<void> updateTask(Task task) async {
    try {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }
  Future<void> deleteTask(String taskId) async {
    try {
      _tasks.removeWhere((task) => task.id == taskId);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }
  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        final task = _tasks[taskIndex];
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
        await updateTask(updatedTask);
      }
    } catch (e) {
      _setError(e.toString());
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
}
