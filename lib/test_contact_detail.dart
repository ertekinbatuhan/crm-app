import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/contact_model.dart';
import 'views/contact_detail_view.dart';
import 'core/theme/app_theme.dart';
import 'viewmodels/contacts_viewmodel.dart';
import 'services/contact_service.dart';

void main() {
  runApp(const TestContactDetailApp());
}

class TestContactDetailApp extends StatelessWidget {
  const TestContactDetailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              ContactsViewModel(contactService: ContactServiceImpl()),
        ),
      ],
      child: MaterialApp(
        title: 'Contact Detail Test',
        theme: AppTheme.lightTheme,
        home: const TestContactDetailScreen(),
      ),
    );
  }
}

class TestContactDetailScreen extends StatelessWidget {
  const TestContactDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a mock contact for testing
    final testContact = Contact(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1-555-0123',
      company: 'Acme Corporation',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Detail Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactDetailView(contact: testContact),
              ),
            );
          },
          child: const Text('Open Contact Detail'),
        ),
      ),
    );
  }
}
