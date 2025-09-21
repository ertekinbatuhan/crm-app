import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase'i güvenli şekilde başlat
  try {
    await Firebase.initializeApp();
    print('✅ Firebase başarıyla başlatıldı');
  } catch (e) {
    print('❌ Firebase başlatılamadı: $e');
    print('Uygulama Firebase olmadan çalışacak');
  }
  
  ServiceLocator.setup();
  
  runApp(const MyApp());
}
