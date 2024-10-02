import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'UserSettings.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('User Settings Component Test', () {
    Map<String, dynamic> fakeSharedPreferencesStorage = {
      'thankYous': [''],
      'dates': [''],
    };
    dynamic updateData(name, gender, age) {
      return;
    }

    testWidgets('test name change', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: UserSettings(
          username: "test",
          age: "18-30",
          gender: "male",
          titles: {"name": "test1", "age": "test2", "gender": "test3"},
          updateData: updateData,
        )),
      );
      expect(find.byKey(Key("nameField")), findsWidgets);
      await tester.enterText(find.byKey(Key("nameField")), 'Test Input');
      await tester.pump();
      expect(find.text('Test Input'), findsOneWidget);
    });
    testWidgets('Test age change', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: UserSettings(
          username: "test",
          age: "18-30",
          gender: "male",
          titles: {"name": "test1", "age": "test2", "gender": "test3"},
          updateData: updateData,
        )),
      );
      final Finder editableTextFinder1 = find.byWidgetPredicate(
        (Widget widget) =>
            widget is EditableText && widget.controller.text == "18-30",
      );
      expect(editableTextFinder1, findsWidgets);
      final agedrop = find.byKey(Key('dropdownAge'));
      expect(agedrop, findsWidgets);
      await tester.tap(agedrop);
      await tester.pumpAndSettle();

      await tester.tap(find.text("-18").last);
      await tester.pumpAndSettle();

      final Finder editableTextFinder2 = find.byWidgetPredicate(
        (Widget widget) =>
            widget is EditableText && widget.controller.text == "-18",
      );
      expect(editableTextFinder2, findsWidgets);

      await tester.tap(agedrop);
      await tester.pumpAndSettle();
      await tester.tap(find.text("18-30").last);
      await tester.pumpAndSettle();

      final Finder editableTextFinder3 = find.byWidgetPredicate(
        (Widget widget) =>
            widget is EditableText && widget.controller.text == "18-30",
      );
      expect(editableTextFinder3, findsWidgets);

      await tester.tap(agedrop);
      await tester.pumpAndSettle();
      await tester.tap(find.text("30-40").last);
      await tester.pumpAndSettle();
      final Finder editableTextFinder4 = find.byWidgetPredicate(
        (Widget widget) =>
            widget is EditableText && widget.controller.text == "30-40",
      );
      expect(editableTextFinder4, findsWidgets);

      await tester.tap(agedrop);
      await tester.pumpAndSettle();
      await tester.tap(find.text("40-55").last);
      await tester.pumpAndSettle();
      final Finder editableTextFinder5 = find.byWidgetPredicate(
        (Widget widget) =>
            widget is EditableText && widget.controller.text == "40-55",
      );
      expect(editableTextFinder5, findsWidgets);

      await tester.tap(agedrop);
      await tester.pumpAndSettle();
      await tester.tap(find.text("55+").last);
      await tester.pumpAndSettle();
      final Finder editableTextFinder6 = find.byWidgetPredicate(
        (Widget widget) =>
            widget is EditableText && widget.controller.text == "55+",
      );
      expect(editableTextFinder6, findsWidgets);
    });

    testWidgets('Test gender change', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: UserSettings(
          username: "test",
          age: "18-30",
          gender: "זכר",
          titles: {"name": "test1", "age": "test2", "gender": "name"},
          updateData: updateData,
        )),
      );

      final genderdrop = find.byKey(Key('dropdownGender'));
      expect(genderdrop, findsWidgets);
      await tester.tap(genderdrop);
      await tester.pumpAndSettle();

      await tester.tap(find.text("נקבה").last);
      await tester.pumpAndSettle();

      final Finder editableTextFinder2 = find.byWidgetPredicate(
        (Widget widget) =>
            widget is EditableText && widget.controller.text == "נקבה",
      );
      expect(editableTextFinder2, findsWidgets);

      await tester.tap(genderdrop);
      await tester.pumpAndSettle();
      await tester.tap(find.text("זכר").last);
      await tester.pumpAndSettle();

      final Finder editableTextFinder3 = find.byWidgetPredicate(
        (Widget widget) =>
            widget is EditableText && widget.controller.text == "זכר",
      );
      expect(editableTextFinder3, findsWidgets);

      await tester.tap(genderdrop);
      await tester.pumpAndSettle();
      await tester.tap(find.text("לא מעוניין להגיד").last);
      await tester.pumpAndSettle();
      final Finder editableTextFinder4 = find.byWidgetPredicate(
        (Widget widget) =>
            widget is EditableText &&
            widget.controller.text == "לא מעוניין להגיד",
      );
      expect(editableTextFinder4, findsWidgets);

      await tester.tap(genderdrop);
      await tester.pumpAndSettle();
      await tester.tap(find.text("לא בינארי").last);
      await tester.pumpAndSettle();
      final Finder editableTextFinder5 = find.byWidgetPredicate(
        (Widget widget) =>
            widget is EditableText && widget.controller.text == "לא בינארי",
      );
      expect(editableTextFinder5, findsWidgets);
    });
  });
}
