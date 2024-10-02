import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mazilon/util/Form/myDropdownMenuEntry.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/initialForm/initialFormPage2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  // Mock functions
  void mockNext() {}
  void mockPrev() {}
  void mockUpdateName(String name) {}

  // Mock titles
  final Map<String, String> mockTitles = {
    'mainTitle': 'Main Title',
    'subTitle': 'Subtitle'
  };

  // Mock form titles
  final Map<String, String> mockFormTitles = {
    'name': 'Name (required)',
    'age': 'Age (required)',
    'gender': 'Gender (required)'
  };

  // Create the test widget
  Widget createTestWidget() {
    return ChangeNotifierProvider<UserInformation>(
      create: (_) => UserInformation(),
      child: MaterialApp(
          home: InitialFormPage2(
            next: mockNext,
            prev: mockPrev,
            updateName: mockUpdateName,
            titles: mockTitles,
            formTitles: mockFormTitles,
          ),
        ),
      //),
    );
  }

  testWidgets('InitialFormPage2 renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Verify the presence of the main title and subtitle
    expect(find.text('Main Title'), findsOneWidget);
    expect(find.text('Subtitle'), findsOneWidget);

    // Verify the presence of the form labels
    expect(find.text('Name (required)'), findsOneWidget);
    expect(find.text('Age (required)'), findsOneWidget);
    expect(find.text('Gender (required)'), findsOneWidget);

    // Verify the presence of the text field and dropdown menus
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(DropdownMenu<String>), findsNWidgets(2));
  });

  testWidgets('InitialFormPage2 text field input', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Enter text in the name text field
    await tester.enterText(find.byType(TextField), 'Test Name');
    await tester.pump();

    // Verify the entered text
    expect(find.text('Test Name'), findsOneWidget);
  });

  testWidgets('InitialFormPage2 dropdown menu selection', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Tap on the age dropdown menu and select an option
    await tester.tap(find.text('18-30'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('30-40').last);
    await tester.pumpAndSettle();

    // Verify the selected age
    expect(find.text('30-40'), findsOneWidget);

    // Tap on the gender dropdown menu and select an option
    await tester.tap(find.text('לא בינארי'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('נקבה').last);
    await tester.pumpAndSettle();

    // Verify the selected gender
    expect(find.text('נקבה'), findsOneWidget);
  });

  testWidgets('InitialFormPage2 button tap', (WidgetTester tester) async {
    bool nextTapped = false;

    // Override the mockNext function to set a flag when called
    void mockNext() {
      nextTapped = true;
    }

    await tester.pumpWidget(
      ChangeNotifierProvider<UserInformation>(
        create: (_) => UserInformation(),
        child: MaterialApp(
            home: InitialFormPage2(
              next: mockNext,
              prev: mockPrev,
              updateName: mockUpdateName,
              titles: mockTitles,
              formTitles: mockFormTitles,
            ),
          ),
        //),
      ),
    );

    // Enter text in the name text field
    await tester.enterText(find.byType(TextField), 'Test Name');
    await tester.pump();

    // Tap the next button
    await tester.tap(find.text('המשך'));
    await tester.pumpAndSettle();
    expect(nextTapped, isTrue);
  });
}
