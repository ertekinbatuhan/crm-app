import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/dashboard_view.dart';
import '../viewmodels/contacts_viewmodel.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../viewmodels/deals_viewmodel.dart';
import '../viewmodels/reports_viewmodel.dart';
import '../viewmodels/tasks_viewmodel.dart';
import '../core/di/service_locator.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => ServiceLocator.get<ContactsViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServiceLocator.get<DashboardViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServiceLocator.get<DealsViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServiceLocator.get<ReportsViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServiceLocator.get<TasksViewModel>(),
        ),
      ],
      child: MaterialApp(
        title: 'CRM Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const DashboardView(),
        navigatorKey: GlobalKey<NavigatorState>(),
      ),
    );
  }
}
