import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'disclaimerPage.dart';

import 'package:flutter/material.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('Journal Component Test', () {
    Map<String, dynamic> fakeSharedPreferencesStorage = {
      "disclaimerConfirmed": false
    };

    testWidgets('Test Disclaimer Page', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: DisclaimerPage(
                fakeSharedPreferencesStorage: fakeSharedPreferencesStorage)),
      );

      var acceptButton = find.byKey(Key('accept'));
      expect(acceptButton, findsWidgets);
      await tester.tap(find.byKey(Key('accept')));
      await tester.pump(Duration(seconds: 1));
      expect(fakeSharedPreferencesStorage['disclaimerConfirmed'], true);
    });
  });
}
