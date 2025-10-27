// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:plantyze/main.dart';

void main() {
  setUpAll(() async {
    // Initialize dotenv for tests
    dotenv.testLoad(fileInput: '''
PLANTNET_API_KEY=test_key
''');
  });

  testWidgets('App starts with home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PlantyzeApp());
    await tester.pump(); // Allow the app to settle

    // Verify that the home screen is displayed
    expect(find.text('Plantyze'), findsOneWidget);
    expect(find.text('Discover Plants Around You'), findsOneWidget);
    expect(find.text('Take Photo'), findsOneWidget);
    expect(find.text('Choose from Gallery'), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    expect(find.byIcon(Icons.photo_library), findsOneWidget);
  });
}
