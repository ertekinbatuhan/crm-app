import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/contact_model.dart';
import '../models/deal_model.dart';
import '../services/task_service.dart';
import '../services/contact_service.dart';
import '../services/deal_service.dart';
import '../core/components/modal/add_task_modal.dart';
import '../core/components/common/action_menu.dart';
import '../core/components/common/danger_button.dart';
import '../core/components/view_state_handler.dart';
import '../core/constants/app_constants.dart';

enum TasksViewModelState { initial, loading, loaded, error }

class TasksViewModel extends ChangeNotifier {
  final TaskService _taskService;
  final ContactService _contactService;
  final DealService _dealService;

  StreamSubscription<List<Task>>? _tasksSubscription;

  TasksViewModel({
    required TaskService taskService,
    required ContactService contactService,
    required DealService dealService,
  }) : _taskService = taskService,
       _contactService = contactService,
       _dealService = dealService;

  // Private fields
  TasksViewModelState _state = TasksViewModelState.initial;
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  List<Contact> _contacts = [];
  List<Deal> _deals = [];
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  String _errorMessage = '';
  String _selectedFilter = 'All'; // All, Today, Completed, Pending

  // Getters
  TasksViewModelState get state => _state;
  List<Task> get tasks => _filteredTasks;
  List<Task> get allTasks => _tasks;
  List<Contact> get contacts => _contacts;
  List<Deal> get deals => _deals;
  DateTime get selectedDate => _selectedDate;
  DateTime get currentMonth => _currentMonth;
  String get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _state == TasksViewModelState.loading;
  bool get hasError => _state == TasksViewModelState.error;
  bool get isLoaded => _state == TasksViewModelState.loaded;
  ViewState get viewState {
    if (isLoading) return ViewState.loading;
    if (hasError) return ViewState.error;
    return ViewState.success;
  }

  // Public methods
  Future<void> loadTasksData() async {
    _setState(TasksViewModelState.loading);
    await _tasksSubscription?.cancel();

    // Reset to today's date when loading data
    final today = DateTime.now();
    _selectedDate = today;
    _currentMonth = DateTime(today.year, today.month);

    try {
      final results = await Future.wait([
        _taskService.getTasksStream().first,
        _contactService.getContactsStream().first,
        _dealService.getDealsStream().first,
      ]);

      _tasks = (results[0] as List<Task>)..sort(_sortByDueDate);
      _contacts = results[1] as List<Contact>;
      _deals = results[2] as List<Deal>;

      _applyFilters();
      _setState(TasksViewModelState.loaded);

      _tasksSubscription = _taskService.getTasksStream().listen(
        (tasks) {
          _tasks = [...tasks]..sort(_sortByDueDate);
          _applyFilters();
          if (_state != TasksViewModelState.loaded) {
            _state = TasksViewModelState.loaded;
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
      await _taskService.createTask(task);
      // Stream will handle the state update automatically
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _taskService.updateTask(task);
      // Stream will handle the state update automatically
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      // Stream will handle the state update automatically
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      await _taskService.toggleTaskCompletion(taskId);
      // Stream will handle the state update automatically
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  Future<void> handleTaskAction(
    BuildContext context,
    ActionMenuAction action,
    Task task,
  ) async {
    switch (action) {
      case ActionMenuAction.edit:
        await showEditTaskDialog(context, task);
        break;
      case ActionMenuAction.delete:
        await confirmDeleteTask(context, task);
        break;
    }
  }

  Future<void> showAddTaskDialog(BuildContext context) async {
    if (!context.mounted) return;

    try {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => AddTaskModal(
          contacts: contacts,
          deals: deals,
          onSubmit: (task) async {
            try {
              await createTask(task);
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop(true);
              }
            } catch (_) {
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop(false);
              }
            }
          },
        ),
      );
    } catch (_) {
      // Silent error handling
    }
  }

  Future<void> showEditTaskDialog(BuildContext context, Task task) async {
    if (!context.mounted) return;

    await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AddTaskModal(
        contacts: contacts,
        deals: deals,
        initialTask: task,
        title: 'Edit Task',
        submitButtonLabel: 'Update Task',
        onSubmit: (updatedTask) async {
          try {
            await updateTask(updatedTask);
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop(true);
            }
          } catch (_) {
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop(false);
            }
          }
        },
      ),
    );
  }

  Future<void> confirmDeleteTask(BuildContext context, Task task) async {
    if (!context.mounted) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
          ),
          title: const Text('Delete Task'),
          content: Text('Are you sure you want to delete "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(AppStrings.cancel),
            ),
            DangerButton(
              label: AppStrings.delete,
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        await deleteTask(task.id);
      } catch (_) {
        // Silent error handling - no snackbar
      }
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
  void _setState(TasksViewModelState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String message) {
    _state = TasksViewModelState.error;
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
