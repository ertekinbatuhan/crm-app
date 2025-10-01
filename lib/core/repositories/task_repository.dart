import '../../models/task_model.dart';
import '../../services/task_service.dart';

abstract class TaskRepository {
  Stream<List<Task>> getTasksStream();
  Future<List<Task>> getTasksByDate(DateTime date);
  Future<Task> createTask(Task task);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<Task> toggleTaskCompletion(String taskId);
  
  void clearCache();
  bool get hasCache;
}

class TaskRepositoryImpl implements TaskRepository {
  final TaskService _taskService;
  List<Task>? _cachedTasks;
  DateTime? _lastCacheTime;
  static const Duration _cacheTimeout = Duration(minutes: 5);

  TaskRepositoryImpl(this._taskService);

  @override
  bool get hasCache => _cachedTasks != null && _isCacheValid();

  bool _isCacheValid() {
    if (_lastCacheTime == null) return false;
    return DateTime.now().difference(_lastCacheTime!) < _cacheTimeout;
  }

  @override
  void clearCache() {
    _cachedTasks = null;
    _lastCacheTime = null;
  }

  @override
  Stream<List<Task>> getTasksStream() {
    return _taskService.getTasksStream().map((tasks) {
      _cachedTasks = tasks;
      _lastCacheTime = DateTime.now();
      return tasks;
    });
  }

  @override
  Future<List<Task>> getTasksByDate(DateTime date) async {
    return await _taskService.getTasksByDate(date);
  }

  @override
  Future<Task> createTask(Task task) async {
    final newTask = await _taskService.createTask(task);
    clearCache();
    return newTask;
  }

  @override
  Future<Task> updateTask(Task task) async {
    final updatedTask = await _taskService.updateTask(task);
    clearCache();
    return updatedTask;
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _taskService.deleteTask(taskId);
    clearCache();
  }

  @override
  Future<Task> toggleTaskCompletion(String taskId) async {
    final toggledTask = await _taskService.toggleTaskCompletion(taskId);
    clearCache();
    return toggledTask;
  }
}
