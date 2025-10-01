// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutterprojects/app/app.dart';
import 'package:flutterprojects/core/di/service_locator.dart';
import 'package:flutterprojects/services/task_service.dart';
import 'package:flutterprojects/services/contact_service.dart';
import 'package:flutterprojects/services/deal_service.dart';
import 'package:flutterprojects/models/task_model.dart';
import 'package:flutterprojects/models/contact_model.dart';
import 'package:flutterprojects/models/deal_model.dart';
import 'package:flutterprojects/core/repositories/contact_repository.dart';
import 'package:flutterprojects/core/repositories/deal_repository.dart';
import 'package:flutterprojects/viewmodels/contacts_viewmodel.dart';
import 'package:flutterprojects/viewmodels/dashboard_viewmodel.dart';
import 'package:flutterprojects/viewmodels/deals_viewmodel.dart';
import 'package:flutterprojects/viewmodels/reports_viewmodel.dart';
import 'package:flutterprojects/viewmodels/tasks_viewmodel.dart';

class _FakeTaskService implements TaskService {
  final DateTime _now = DateTime(2025, 9, 27, 10, 0);

  List<Task> get _sampleTasks => [
    Task(
      id: 't1',
      title: 'Follow up call',
      dueDate: _now.add(const Duration(days: 1)),
      isCompleted: false,
      type: TaskType.followUp,
      priority: TaskPriority.medium,
      createdAt: _now.subtract(const Duration(days: 1)),
      updatedAt: _now,
    ),
    Task(
      id: 't2',
      title: 'Finish report',
      dueDate: _now,
      isCompleted: true,
      type: TaskType.general,
      priority: TaskPriority.high,
      createdAt: _now.subtract(const Duration(days: 2)),
      updatedAt: _now,
    ),
  ];

  @override
  Future<List<Task>> getTasks() async => _sampleTasks;

  @override
  Future<List<Task>> getTasksOnce() async => _sampleTasks;

  @override
  Future<List<Task>> getTasksByDate(DateTime date) async {
    return _sampleTasks
        .where(
          (task) =>
              task.dueDate != null &&
              task.dueDate!.year == date.year &&
              task.dueDate!.month == date.month &&
              task.dueDate!.day == date.day,
        )
        .toList();
  }

  @override
  Stream<List<Task>> getTasksStream() => Stream.value(_sampleTasks);

  @override
  Future<Task> createTask(Task task) async {
    return task.copyWith(id: 'newTask', createdAt: _now, updatedAt: _now);
  }

  @override
  Future<void> deleteTask(String taskId) async {}

  @override
  Future<Task> toggleTaskCompletion(String taskId) async {
    final task = _sampleTasks.firstWhere((task) => task.id == taskId);
    return task.copyWith(
      isCompleted: !task.isCompleted,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<Task> updateTask(Task task) async =>
      task.copyWith(updatedAt: DateTime.now());
}

class _FakeContactService implements ContactService {
  final DateTime _now = DateTime(2025, 9, 27);

  List<Contact> get _sampleContacts => [
    Contact(
      id: 'c1',
      name: 'Jane Cooper',
      email: 'jane@example.com',
      phone: '555-0001',
      company: 'Acme',
      createdAt: _now.subtract(const Duration(days: 5)),
      updatedAt: _now,
    ),
  ];

  @override
  Future<Contact> createContact(Contact contact) async =>
      contact.copyWith(id: 'newContact', createdAt: _now, updatedAt: _now);

  @override
  Future<void> deleteContact(String contactId) async {}

  @override
  Stream<List<Contact>> getContactsStream() => Stream.value(_sampleContacts);

  @override
  Future<List<Contact>> getContactsOnce() async => _sampleContacts;

  @override
  Future<Contact> updateContact(Contact contact) async =>
      contact.copyWith(updatedAt: _now);
}

class _FakeDealService implements DealService {
  final DateTime _now = DateTime(2025, 9, 27);

  List<Deal> get _sampleDeals => [
    Deal(
      id: 'd1',
      title: 'Big Opportunity',
      value: 50000,
      description: 'Important client',
      status: DealStatus.closed,
      closeDate: _now.subtract(const Duration(days: 2)),
      createdAt: _now.subtract(const Duration(days: 10)),
      updatedAt: _now,
    ),
    Deal(
      id: 'd2',
      title: 'Prospect Deal',
      value: 15000,
      status: DealStatus.prospect,
      createdAt: _now.subtract(const Duration(days: 5)),
      updatedAt: _now,
    ),
  ];

  @override
  Future<Deal> createDeal(Deal deal) async => Deal.withAutoCloseDate(
    id: 'newDeal',
    title: deal.title,
    value: deal.value,
    description: deal.description,
    status: deal.status,
    createdAt: _now,
    updatedAt: _now,
  );

  @override
  Future<void> deleteDeal(String dealId) async {}

  @override
  Stream<List<Deal>> getDealsStream() => Stream.value(_sampleDeals);

  @override
  Future<List<Deal>> getDealsOnce() async => _sampleDeals;

  @override
  Future<Deal> updateDeal(Deal deal) async => deal.copyWith(updatedAt: _now);
}

Future<void> _configureServiceLocatorForTests() async {
  await serviceLocator.reset();

  serviceLocator.registerLazySingleton<TaskService>(() => _FakeTaskService());
  serviceLocator.registerLazySingleton<ContactService>(
    () => _FakeContactService(),
  );
  serviceLocator.registerLazySingleton<DealService>(() => _FakeDealService());

  serviceLocator.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(serviceLocator.get<ContactService>()),
  );
  serviceLocator.registerLazySingleton<DealRepository>(
    () => DealRepositoryImpl(serviceLocator.get<DealService>()),
  );

  serviceLocator.registerLazySingleton<ContactsViewModel>(
    () => ContactsViewModel(serviceLocator.get<ContactRepository>()),
  );
  serviceLocator.registerLazySingleton<DashboardViewModel>(
    () => DashboardViewModel(
      taskService: serviceLocator.get<TaskService>(),
      contactService: serviceLocator.get<ContactService>(),
      dealService: serviceLocator.get<DealService>(),
    ),
  );
  serviceLocator.registerFactory<DealsViewModel>(
    () => DealsViewModel(serviceLocator.get<DealRepository>()),
  );
  serviceLocator.registerLazySingleton<ReportsViewModel>(
    () => ReportsViewModel(
      dealService: serviceLocator.get<DealService>(),
      contactService: serviceLocator.get<ContactService>(),
      taskService: serviceLocator.get<TaskService>(),
    ),
  );
  serviceLocator.registerLazySingleton<TasksViewModel>(
    () => TasksViewModel(
      taskService: serviceLocator.get<TaskService>(),
      contactService: serviceLocator.get<ContactService>(),
      dealService: serviceLocator.get<DealService>(),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _configureServiceLocatorForTests();
  });

  testWidgets('Dashboard renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Contacts'), findsOneWidget);
    expect(find.text('Deals'), findsWidgets);
    expect(find.text('Tasks'), findsWidgets);
    expect(find.text('Reports'), findsOneWidget);

    expect(find.text('Tasks'), findsWidgets);
    expect(find.text('Deals'), findsWidgets);
  });
}
