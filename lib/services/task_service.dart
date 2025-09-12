import '../models/task_model.dart';

abstract class TaskService {
  Future<List<Task>> getTasks();
  Future<List<Task>> getTasksByDate(DateTime date);
  Future<Task> createTask(Task task);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<Task> toggleTaskCompletion(String taskId);
}

class TaskServiceImpl implements TaskService {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Follow up with Sarah',
      dueDate: DateTime.now().copyWith(hour: 10, minute: 0),
      isCompleted: true,
      type: TaskType.followUp,
      priority: TaskPriority.high,
      associatedContactId: '1',
      description: 'Discuss project requirements and timeline',
    ),
    Task(
      id: '2',
      title: 'Prepare presentation for client meeting',
      dueDate: DateTime.now().copyWith(hour: 11, minute: 30),
      isCompleted: true,
      type: TaskType.presentation,
      priority: TaskPriority.urgent,
      associatedDealId: '1',
      description: 'Create slides for quarterly review meeting',
    ),
    Task(
      id: '3',
      title: 'Review quarterly reports',
      dueDate: DateTime.now()
          .add(const Duration(days: 1))
          .copyWith(hour: 9, minute: 0),
      isCompleted: false,
      type: TaskType.general,
      priority: TaskPriority.medium,
      description: 'Analyze Q3 performance metrics',
    ),
    Task(
      id: '4',
      title: 'Update CRM database',
      dueDate: DateTime.now()
          .add(const Duration(days: 1))
          .copyWith(hour: 14, minute: 0),
      isCompleted: false,
      type: TaskType.general,
      priority: TaskPriority.low,
      associatedContactId: '2',
      description: 'Add new contacts and update existing records',
    ),
  ];

  @override
  Future<List<Task>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_tasks);
  }

  @override
  Future<List<Task>> getTasksByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.year == date.year &&
          task.dueDate!.month == date.month &&
          task.dueDate!.day == date.day;
    }).toList();
  }

  @override
  Future<Task> createTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newTask = task.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _tasks.add(newTask);
    return newTask;
  }

  @override
  Future<Task> updateTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      return task;
    }
    throw Exception('Task not found');
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _tasks.removeWhere((task) => task.id == taskId);
  }

  @override
  Future<Task> toggleTaskCompletion(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      _tasks[index] = updatedTask;
      return updatedTask;
    }
    throw Exception('Task not found');
  }
}
