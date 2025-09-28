import 'package:get_it/get_it.dart';
import '../../services/contact_service.dart';
import '../../services/deal_service.dart';
import '../../services/task_service.dart';
import '../../services/meeting_service.dart';
import '../../viewmodels/contacts_viewmodel.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../viewmodels/deals_viewmodel.dart';
import '../../viewmodels/reports_viewmodel.dart';
import '../../viewmodels/tasks_viewmodel.dart';
import '../repositories/contact_repository.dart';
import '../repositories/deal_repository.dart';

final GetIt serviceLocator = GetIt.instance;

class ServiceLocator {
  static void setup() {
    // Register Firebase services directly
    serviceLocator.registerLazySingleton<ContactService>(
      () => FirebaseContactService(),
    );
    serviceLocator.registerLazySingleton<DealService>(
      () => FirebaseDealService(),
    );
    serviceLocator.registerLazySingleton<TaskService>(
      () => FirebaseTaskService(),
    );
    serviceLocator.registerLazySingleton<MeetingService>(
      () => FirebaseMeetingService(),
    );
    

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
        meetingService: serviceLocator.get<MeetingService>(),
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
        meetingService: serviceLocator.get<MeetingService>(),
      ),
    );
    serviceLocator.registerLazySingleton<TasksViewModel>(
      () => TasksViewModel(
        taskService: serviceLocator.get<TaskService>(),
        meetingService: serviceLocator.get<MeetingService>(),
        contactService: serviceLocator.get<ContactService>(),
        dealService: serviceLocator.get<DealService>(),
      ),
    );
  }
  
  static T get<T extends Object>() {
    return serviceLocator.get<T>();
  }
}