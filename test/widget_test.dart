// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutterprojects/app/app.dart';

void main() {
  testWidgets('Dashboard renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our dashboard title exists.
    expect(find.text('Dashboard'), findsOneWidget);
    
    // Verify that navigation items exist.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Contacts'), findsOneWidget);
    expect(find.text('Deals'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Reports'), findsOneWidget);

    // Verify that stat cards exist.
    expect(find.text('Leads'), findsOneWidget);
    expect(find.text('120'), findsOneWidget);
  });
}
