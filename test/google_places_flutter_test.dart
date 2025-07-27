import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

void main() {
  group('GooglePlaceAutoCompleteTextField Tests', () {
    testWidgets('Widget can be created with new API', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GooglePlaceAutoCompleteTextField(
              textEditingController: controller,
              googleAPIKey: "test-api-key",
              useNewAPI: true,
            ),
          ),
        ),
      );

      expect(find.byType(GooglePlaceAutoCompleteTextField), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('Widget can be created with legacy API', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GooglePlaceAutoCompleteTextField(
              textEditingController: controller,
              googleAPIKey: "test-api-key",
              useNewAPI: false,
            ),
          ),
        ),
      );

      expect(find.byType(GooglePlaceAutoCompleteTextField), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('Widget shows cross button when enabled', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController(text: "test");

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GooglePlaceAutoCompleteTextField(
              textEditingController: controller,
              googleAPIKey: "test-api-key",
              isCrossBtnShown: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('Widget hides cross button when disabled', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController(text: "test");

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GooglePlaceAutoCompleteTextField(
              textEditingController: controller,
              googleAPIKey: "test-api-key",
              isCrossBtnShown: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsNothing);
    });
  });
}
