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

final GetIt serviceLocator = GetIt.instance;

class ServiceLocator {
  static void setup() {
    // Firebase durumunu kontrol et ve uygun ContactService'i kullan
    ContactService contactService;
    try {
      Firebase.app(); // Firebase başlatılmış mı kontrol et
      contactService = FirebaseContactService();
      print('✅ Firebase ContactService kullanılıyor');
    } catch (e) {
      contactService = MockContactService();
      print('📝 Mock ContactService kullanılıyor (Firebase bulunamadı)');
    }

    serviceLocator.registerLazySingleton<ContactService>(
      () => contactService,
    );
    serviceLocator.registerLazySingleton<DealService>(
      () => DealServiceImpl(),
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
    

    serviceLocator.registerFactory<ContactsViewModel>(
      () => ContactsViewModel(serviceLocator.get<ContactRepository>()),
    );
    serviceLocator.registerFactory<DashboardViewModel>(
      () => DashboardViewModel(
        taskService: serviceLocator.get<TaskService>(),
        contactService: serviceLocator.get<ContactService>(),
        dealService: serviceLocator.get<DealService>(),
        meetingService: serviceLocator.get<MeetingService>(),
      ),
    );
    serviceLocator.registerFactory<DealsViewModel>(
      () => DealsViewModel(serviceLocator.get<DealService>()),
    );
    serviceLocator.registerFactory<ReportsViewModel>(
      () => ReportsViewModel(
        dealService: serviceLocator.get<DealService>(),
        contactService: serviceLocator.get<ContactService>(),
        taskService: serviceLocator.get<TaskService>(),
        meetingService: serviceLocator.get<MeetingService>(),
      ),
    );
    serviceLocator.registerFactory<TasksViewModel>(
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