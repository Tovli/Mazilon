import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'personalPlanWidget.dart'; // Update with the correct path

void main() {
  group('PersonalPlanWidget Tests', () {
    testWidgets('PersonalPlanWidget shows correct text',
        (WidgetTester tester) async {
      // Define the test key.
      final testKey = Key('personal_plan_widget');

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PersonalPlanWidget(
            key: testKey,
            text: {
              'list': ['Item 1', 'Item 2'],
              'SubTitle': 'Test Subtitle'
            },
            changeCurrentIndex: (_) {},
          ),
        ),
      ));

      // Verify that PersonalPlanWidget shows the correct subtitle.
      expect(find.text('Test Subtitle'), findsOneWidget);
      expect(find.byKey(Key("download")), findsWidgets);
      expect(find.byKey(Key("share")), findsWidgets);
      expect(find.byKey(Key("cancel")), findsNothing);
      expect(find.byKey(Key("send1")), findsNothing);
      expect(find.byKey(Key("send2")), findsNothing);
      await tester.tap(find.byKey(Key("share")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("cancel")), findsWidgets);
      expect(find.byKey(Key("send1")), findsWidgets);
      expect(find.byKey(Key("send2")), findsWidgets);
      await tester.tap(find.byKey(Key("send1")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("cancel")), findsWidgets);
      expect(find.byKey(Key("send1")), findsWidgets);
      expect(find.byKey(Key("send2")), findsWidgets);
      await tester.tap(find.byKey(Key("send2")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("cancel")), findsWidgets);
      expect(find.byKey(Key("send1")), findsWidgets);
      expect(find.byKey(Key("send2")), findsWidgets);
      await tester.tap(find.byKey(Key("cancel")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("cancel")), findsNothing);
      expect(find.byKey(Key("send1")), findsNothing);
      expect(find.byKey(Key("send2")), findsNothing);

      // You can add more expect statements to verify other functionalities.
    });

    // Add more tests as needed.
  });
}
