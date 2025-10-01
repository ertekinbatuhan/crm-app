import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';
import 'core/di/service_locator.dart';
import 'core/utils/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    appLogger.i('Firebase initialized successfully');
  } catch (e) {
    appLogger.e('Firebase initialization failed', error: e);
    appLogger.w('The application will run without Firebase services.');
  }
  
  ServiceLocator.setup();
  
  runApp(const MyApp());
}
