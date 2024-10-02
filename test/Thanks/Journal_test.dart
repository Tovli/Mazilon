import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'journal.dart';
import 'dart:math';

import 'package:flutter/material.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('Journal Component Test', () {
    Map<String, dynamic> fakeSharedPreferencesStorage = {
      'thankYous': [''],
      'dates': [''],
    };

    testWidgets('Test adding suggested item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: Journal(
                fakeSharedPreferencesStorage: fakeSharedPreferencesStorage)),
      );

      var nextButton = find.byKey(Key('Sug1'));
      expect(nextButton, findsWidgets);
      var nextButton1 = find.byKey(Key('Sug1Add'));
      expect(nextButton1, findsWidgets);

      expect(find.byKey(Key('ThankYou1')), findsNothing);
      await tester.tap(find.byKey(Key('Sug1Add')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('ThankYou1')), findsWidgets);
    });

    testWidgets('Test removing item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: Journal(
                fakeSharedPreferencesStorage: fakeSharedPreferencesStorage)),
      );

      expect(find.byKey(Key('deleteThankYou1')), findsWidgets);
      await tester.tap(find.byKey(Key('deleteThankYou1')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('ThankYou1')), findsNothing);
    });
    testWidgets('Test editing item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: Journal(
                fakeSharedPreferencesStorage: fakeSharedPreferencesStorage)),
      );

      await tester.tap(find.byKey(Key('editThankYou1')));
      await tester.pump();
      await tester.enterText(find.byKey(Key('addFormTextField')), 'Test Input');
      await tester.pump();
      expect(find.text('Test Input'), findsOneWidget);
      await tester.tap(find.byKey(Key('saveButton')));
      await tester.pump(Duration(seconds: 1));

      expect(find.byKey(Key('ThankYou0')), findsWidgets);
      expect(find.text('Test Input'), findsOneWidget);
    });
    testWidgets('Test adding item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: Journal(
                fakeSharedPreferencesStorage: fakeSharedPreferencesStorage)),
      );

      await tester.tap(find.byKey(Key('addThankYouPlus')));
      await tester.pump();
      await tester.enterText(
          find.byKey(Key('addFormTextField')), 'Test Input Add');
      await tester.pump();
      expect(find.text('Test Input Add'), findsOneWidget);
      await tester.tap(find.byKey(Key('saveButton')));
      await tester.pump(Duration(seconds: 1));

      expect(find.text('Test Input Add'), findsOneWidget);
    });
    testWidgets('Test cancel adding item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: Journal(
                fakeSharedPreferencesStorage: fakeSharedPreferencesStorage)),
      );

      await tester.tap(find.byKey(Key('addThankYouPlus')));
      await tester.pump();
      await tester.enterText(
          find.byKey(Key('addFormTextField')), 'Test Input Cancel');
      await tester.pump();
      expect(find.text('Test Input Cancel'), findsOneWidget);
      await tester.tap(find.byKey(Key('cancelButton')));
      await tester.pump(Duration(seconds: 1));

      expect(find.text('Test Input Cancel'), findsNothing);
    });
  });
}
