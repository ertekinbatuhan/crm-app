import 'package:flutter/material.dart';
import 'models/deal_model.dart';
import 'views/deal_detail_view.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const TestDealDetailApp());
}

class TestDealDetailApp extends StatelessWidget {
  const TestDealDetailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deal Detail Test',
      theme: AppTheme.lightTheme,
      home: const TestDealDetailScreen(),
    );
  }
}

class TestDealDetailScreen extends StatelessWidget {
  const TestDealDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a mock deal for testing
    final testDeal = Deal(
      id: '1',
      title: 'Acme Corp - Enterprise Software',
      value: 50000.0,
      description: 'Enterprise software solution for Acme Corp including licenses and implementation services',
      status: DealStatus.negotiation,
      closeDate: DateTime.now().add(const Duration(days: 30)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Deal Detail Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DealDetailView(deal: testDeal),
              ),
            );
          },
          child: const Text('Open Deal Detail'),
        ),
      ),
    );
  }
}