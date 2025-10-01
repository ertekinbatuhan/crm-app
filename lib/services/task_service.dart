import '../models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/firestore_constants.dart';
import '../core/errors/exceptions.dart';

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
  final FirebaseFirestore _firestore;
  static const String _collection = FirestoreCollections.tasks;

  FirebaseTaskService([FirebaseFirestore? firestore])
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Task>> getTasksOnce() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('dueDate', descending: false)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Task.fromMap({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch tasks',
        code: 'FETCH_ERROR',
        originalError: e,
      );
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
        return Task.fromMap({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to fetch tasks by date',
        code: 'FETCH_ERROR',
        originalError: e,
      );
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
              return Task.fromMap({...data, 'id': doc.id});
            }).toList();
          });
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to stream tasks',
        code: 'STREAM_ERROR',
        originalError: e,
      );
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
      throw FirestoreException(
        message: 'Failed to create task',
        code: 'CREATE_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<Task> updateTask(Task task) async {
    try {
      if (task.id.isEmpty) {
        throw ValidationException.requiredField('task.id');
      }

      final now = DateTime.now();
      final taskData = task.copyWith(updatedAt: now).toMap();
      taskData.remove('id');

      await _firestore.collection(_collection).doc(task.id).update(taskData);

      return task.copyWith(updatedAt: now);
    } on ValidationException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to update task',
        code: 'UPDATE_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw ValidationException.requiredField('taskId');
      }

      await _firestore.collection(_collection).doc(taskId).delete();
    } on ValidationException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to delete task',
        code: 'DELETE_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<Task> toggleTaskCompletion(String taskId) async {
    try {
      final docRef = _firestore.collection(_collection).doc(taskId);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw FirestoreException.notFound();
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
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        message: 'Failed to toggle task completion',
        code: 'UPDATE_ERROR',
        originalError: e,
      );
    }
  }
}
