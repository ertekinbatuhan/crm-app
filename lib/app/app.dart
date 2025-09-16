import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../views/dashboard_view.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../viewmodels/contacts_viewmodel.dart';
import '../viewmodels/deals_viewmodel.dart';
import '../viewmodels/reports_viewmodel.dart';
import '../viewmodels/tasks_viewmodel.dart';
import '../services/task_service.dart';
import '../services/contact_service.dart';
import '../services/deal_service.dart';
import '../services/meeting_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services (Singletons)
        Provider<TaskService>(create: (_) => TaskServiceImpl()),
        Provider<ContactService>(create: (_) => ContactServiceImpl()),
        Provider<DealService>(create: (_) => DealServiceImpl()),
        Provider<MeetingService>(create: (_) => MeetingServiceImpl()),

        // ViewModels
        ChangeNotifierProxyProvider4<
          TaskService,
          ContactService,
          DealService,
          MeetingService,
          DashboardViewModel
        >(
          create: (context) => DashboardViewModel(
            taskService: context.read<TaskService>(),
            contactService: context.read<ContactService>(),
            dealService: context.read<DealService>(),
            meetingService: context.read<MeetingService>(),
          ),
          update:
              (
                _,
                taskService,
                contactService,
                dealService,
                meetingService,
                __,
              ) => DashboardViewModel(
                taskService: taskService,
                contactService: contactService,
                dealService: dealService,
                meetingService: meetingService,
              ),
        ),
        ChangeNotifierProxyProvider<ContactService, ContactsViewModel>(
          create: (context) =>
              ContactsViewModel(contactService: context.read<ContactService>()),
          update: (_, contactService, __) =>
              ContactsViewModel(contactService: contactService),
        ),
        ChangeNotifierProxyProvider<DealService, DealsViewModel>(
          create: (context) =>
              DealsViewModel(dealService: context.read<DealService>()),
          update: (_, dealService, __) =>
              DealsViewModel(dealService: dealService),
        ),
        ChangeNotifierProxyProvider4<
          DealService,
          ContactService,
          TaskService,
          MeetingService,
          ReportsViewModel
        >(
          create: (context) => ReportsViewModel(
            dealService: context.read<DealService>(),
            contactService: context.read<ContactService>(),
            taskService: context.read<TaskService>(),
            meetingService: context.read<MeetingService>(),
          ),
          update:
              (
                _,
                dealService,
                contactService,
                taskService,
                meetingService,
                __,
              ) => ReportsViewModel(
                dealService: dealService,
                contactService: contactService,
                taskService: taskService,
                meetingService: meetingService,
              ),
        ),
        ChangeNotifierProxyProvider2<
          TaskService,
          MeetingService,
          TasksViewModel
        >(
          create: (context) => TasksViewModel(
            taskService: context.read<TaskService>(),
            meetingService: context.read<MeetingService>(),
          ),
          update: (_, taskService, meetingService, __) => TasksViewModel(
            taskService: taskService,
            meetingService: meetingService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'CRM Dashboard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const DashboardView(),
        navigatorKey: GlobalKey<NavigatorState>(),
      ),
    );
  }
}
