import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'TraitListWidgetTest.dart';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  testWidgets('test the positive trait list', (WidgetTester tester) async {
    List<String> positive_traits = ["smart", "beautifull", "kind"];
    add(text) {
      positive_traits.add(text);
    }

    edit(text, index) => {positive_traits[index] = text};
    remove(index) => {positive_traits.removeAt(index)};
    addSuggested() => positive_traits.add("Suggested");
    onTabTapped(index) => print(index);

    await tester.pumpWidget(TraitListWidget(
      traits: positive_traits,
      add: add,
      edit: edit,
      remove: remove,
      traitListLength: positive_traits.length,
      addSuggested: addSuggested,
      onTabTapped: onTabTapped,
    ));
    final addButton = find.byKey(Key('addButton'));
    expect(addButton, findsWidgets);
    await tester.tap(addButton);
    await tester.pump();
    expect(find.text("Test Text"), findsOneWidget);
    final editButton = find.byKey(Key('editButton_3'));
    expect(editButton, findsWidgets);
    await tester.tap(editButton);
    await tester.pump();
    expect(find.text("Edit Text"), findsOneWidget);
    final removeButton = find.byKey(Key('deleteButton_3'));
    expect(removeButton, findsWidgets);
    await tester.tap(removeButton);
    await tester.pump();
    expect(find.text("Edit Text"), findsNothing);
    final addSuggestedButton = find.byKey(Key('addPositiveSuggesstion'));
    expect(addSuggestedButton, findsWidgets);
    await tester.tap(addSuggestedButton);
    await tester.pump();
    //expect(find.text("Suggested"), findsOneWidget);
  });
}
