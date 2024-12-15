import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'positiveTest.dart';
import 'dart:math';

import 'package:flutter/material.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('Positive Component Test', () {
    Map<String, dynamic> fakeSharedPreferencesStorage = {
      'positiveTraits': [''],
      'positiveDates': [''],
    };

    testWidgets('Test adding suggested item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: Positive(
                fakeSharedPreferencesStorage: fakeSharedPreferencesStorage)),
      );

      var nextButton = find.byKey(Key('positiveTraitSug1'));
      expect(nextButton, findsWidgets);
      var nextButton1 = find.byKey(Key('positiveTraitSug1Add'));
      expect(nextButton1, findsWidgets);

      expect(find.byKey(Key('positiveTrait1')), findsNothing);
      await tester.tap(find.byKey(Key('positiveTraitSug1Add')));
      await tester.pump(Duration(seconds: 1));

      expect(find.byKey(Key('positiveTrait1')), findsWidgets);
    });

    testWidgets('Test removing item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: Positive(
                fakeSharedPreferencesStorage: fakeSharedPreferencesStorage)),
      );

      expect(find.byKey(Key('deleteTrait1')), findsWidgets);
      await tester.tap(find.byKey(Key('deleteTrait1')));
      await tester.pump(Duration(seconds: 1));
      expect(find.byKey(Key('positiveTrait1')), findsNothing);
    });
    testWidgets('Test editing item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: Positive(
                fakeSharedPreferencesStorage: fakeSharedPreferencesStorage)),
      );

      await tester.tap(find.byKey(Key('editTrait1')));
      await tester.pump();
      await tester.enterText(find.byKey(Key('addFormTextField')), 'Test Input');
      await tester.pump();
      expect(find.text('Test Input'), findsOneWidget);

      expect(find.byKey(Key('positiveTrait0')), findsWidgets);
      expect(find.text('Test Input'), findsOneWidget);
    });
    testWidgets('Test adding item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: Positive(
                fakeSharedPreferencesStorage: fakeSharedPreferencesStorage)),
      );

      await tester.tap(find.byKey(Key('addTraitPlus')));
      await tester.pump();
      await tester.enterText(
          find.byKey(Key('addFormTextField')), 'Test Input Add');
      await tester.pump();
      expect(find.text('Test Input Add'), findsOneWidget);

      await tester.pump(Duration(seconds: 1));

      expect(find.text('Test Input Add'), findsOneWidget);
    });
    testWidgets('Test cancel adding item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: Positive(
                fakeSharedPreferencesStorage: fakeSharedPreferencesStorage)),
      );

      await tester.tap(find.byKey(Key('addTraitPlus')));
      await tester.pump();
      await tester.enterText(
          find.byKey(Key('addFormTextField')), 'Test Input Cancel');
      await tester.pump();
      expect(find.text('Test Input Cancel'), findsOneWidget);

      //expect(find.text('Test Input Cancel'), findsNothing);
    });
  });
}
