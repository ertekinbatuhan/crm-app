import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
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
    ContactService contactService;
    DealService dealService;
    try {
      Firebase.app(); 
      contactService = FirebaseContactService();
      dealService = FirebaseDealService();
      print('✅ Using Firebase Services');
    } catch (e) {
      contactService = MockContactService();
      dealService = MockDealService();
      print('📝 Using Mock Services (Firebase not found)');
    }

    serviceLocator.registerLazySingleton<ContactService>(
      () => contactService,
    );
    serviceLocator.registerLazySingleton<DealService>(
      () => dealService,
    );
    serviceLocator.registerLazySingleton<TaskService>(
      () => TaskServiceImpl(),
    );
    serviceLocator.registerLazySingleton<MeetingService>(
      () => MeetingServiceImpl(),
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
      ),
    );
  }
  
  static T get<T extends Object>() {
    return serviceLocator.get<T>();
  }
}