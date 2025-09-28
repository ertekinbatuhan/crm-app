import '../models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

abstract class TaskService {
  Future<List<Task>> getTasksOnce();
  Future<List<Task>> getTasksByDate(DateTime date);
  Stream<List<Task>> getTasksStream();
  Future<Task> createTask(Task task);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<Task> toggleTaskCompletion(String taskId);
}

class FirebaseTaskService implements TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'tasks';

  @override
  Future<List<Task>> getTasksOnce() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('dueDate', descending: false)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Task.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  @override
  Future<List<Task>> getTasksByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final querySnapshot = await _firestore
          .collection(_collection)
          .where(
            'dueDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          )
          .where('dueDate', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Task.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks by date: $e');
    }
  }

  @override
  Stream<List<Task>> getTasksStream() {
    try {
      return _firestore
          .collection(_collection)
          .orderBy('dueDate', descending: false)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return Task.fromMap(data);
            }).toList();
          });
    } catch (e) {
      throw Exception('Failed to stream tasks: $e');
    }
  }

  @override
  Future<Task> createTask(Task task) async {
    try {
      final taskId = const Uuid().v4();
      final now = DateTime.now();
      final taskData = task
          .copyWith(id: taskId, createdAt: now, updatedAt: now)
          .toMap();
      taskData.remove('id');

      await _firestore.collection(_collection).doc(taskId).set(taskData);

      return task.copyWith(id: taskId, createdAt: now, updatedAt: now);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  @override
  Future<Task> updateTask(Task task) async {
    try {
      if (task.id.isEmpty) {
        throw Exception('Task ID cannot be empty');
      }

      final now = DateTime.now();
      final taskData = task.copyWith(updatedAt: now).toMap();
      taskData.remove('id');

      await _firestore.collection(_collection).doc(task.id).update(taskData);

      return task.copyWith(updatedAt: now);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw Exception('Task ID cannot be empty');
      }

      await _firestore.collection(_collection).doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  @override
  Future<Task> toggleTaskCompletion(String taskId) async {
    try {
      final docRef = _firestore.collection(_collection).doc(taskId);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw Exception('Task not found');
      }

      final data = docSnapshot.data()!;
      final currentTask = Task.fromMap({...data, 'id': docSnapshot.id});
      final updatedTask = currentTask.copyWith(
        isCompleted: !currentTask.isCompleted,
        updatedAt: DateTime.now(),
      );

      final updateData = updatedTask.toMap();
      updateData.remove('id');

      await docRef.update(updateData);

      return updatedTask;
    } catch (e) {
      throw Exception('Failed to toggle task completion: $e');
    }
  }
}
