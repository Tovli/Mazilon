import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mazilon/util/styles.dart';
//import 'package:mazilon/initialForm/initialFormPage1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'initialFormPage1.dart';

//class MockSharedPreferences extends Mock implements SharedPreferences {}


void main() {
  testWidgets('test the positive trait list', (WidgetTester tester) async {
    String name = '';
    bool tapnext = false;
    bool tapskip = false;
    bool tapprev = false;
    //List<int> index = 0;
  // Mock functions
    mockNext() => {tapnext = !tapnext};
    mockSkip() => {tapskip = !tapskip};
    mockPrev() => {tapprev = !tapprev};
    mockUpdateName(String n) => {name = n};

    // Mock titles
    final Map<String, String> mockTitles = {
      'mainTitle': 'Main Title',
      'subTitle1': 'Subtitle 1',
      'subTitle2': 'Subtitle 2'
    };

    // Create the test widget
    // Widget createTestWidget() {
    //   return MaterialApp(
    //       home: Scaffold(
    //         body: InitialFormPage1(
    //           next: mockNext,
    //           skip: mockSkip,
    //           prev: mockPrev,
    //           updateName: mockUpdateName,
    //           titles: mockTitles,
    //         ),
    //       ),
    //     );
    //   //);
    // }

    await tester.pumpWidget(InitialFormPage1(
      next: mockNext,
      skip: mockSkip,
      prev: mockPrev,
      updateName: mockUpdateName,
      titles: mockTitles,
    ));
    
    final nextButton = find.byKey(Key('next'));
    expect(nextButton, findsWidgets);
    await tester.tap(nextButton);
    await tester.pump();
    //expect(find.text("Test Text"), findsOneWidget);
    
    final skipButton = find.byKey(Key('skip'));
    expect(skipButton, findsWidgets);
    await tester.tap(skipButton);
    await tester.pump();
    //expect(find.text("Edit Text"), findsOneWidget);
    
    // final prevButton = find.byKey(Key('prev'));
    // expect(prevButton, findsWidgets);
    // await tester.tap(prevButton);
    // await tester.pump();
    //expect(find.text("Edit Text"), findsNothing);
    
    // final updateName = find.byKey(Key('addPositiveSuggesstion'));
    // expect(updateName, findsWidgets);
    // await tester.tap(updateName);
    // await tester.pump();
    });

}
