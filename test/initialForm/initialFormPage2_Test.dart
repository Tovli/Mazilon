import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mazilon/util/appInformation.dart';

import 'package:mazilon/util/userInformation.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/initialForm/initialFormPage2.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
//class MockSharedPreferences extends Mock implements SharedPreferences {}
import '../MenuTest/FeelGood/FeelGood_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserInformation>(),
  MockSpec<AppInformation>(),
  MockSpec<SharedPreferences>(),
])
void main() {
  // Mock functions
  bool nextTapped = false;
  void mockNext() {}
  void mockPrev() {}
  void mockUpdateName(String name) {}
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockSharedPreferences mockSharedPreferences;
  late UserInformation mockUserInformation;
  late AppInformation mockAppInformation;

  setUp(() {
    mockUserInformation = UserInformation();
    mockAppInformation = AppInformation();
    mockUserInformation.gender = "male";
    mockUserInformation.disclaimerSigned = true;
    SharedPreferences.setMockInitialValues({'hasFilled': false});

    mockSharedPreferences = MockSharedPreferences();
  });
  // Create the test widget
  Widget createTestWidget() {
    void mockNext() {
      nextTapped = true;
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppInformation>.value(value: mockAppInformation),
        ChangeNotifierProvider<UserInformation>.value(
            value: mockUserInformation),
      ],
      child: MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('he'),
        localizationsDelegates: [
          AppLocalizations.localizationsDelegates[0],
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        home: ScreenUtilInit(
          designSize: const Size(360, 690),
          child: InitialFormPage2(
            next: mockNext,
            prev: mockPrev,
            updateName: mockUpdateName,
          ),
        ),
      ),
      //),
    );
  }

  testWidgets('InitialFormPage2 renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Verify the presence of the main title and subtitle
    expect(find.text('בוא נכיר'), findsOneWidget);
    expect(
        find.text(
            'היי, שמחים שהגעת! נשמח להכיר אותך קצת כדי שנוכל לדעת איך לפנות אליך'),
        findsOneWidget);

    // Verify the presence of the form labels
    expect(find.text('כיצד היית רוצה שנפנה אליך?'), findsOneWidget);
    expect(find.text('מהו הגיל שלך?'), findsOneWidget);
    expect(find.text('כיצד היית רוצה שנפנה אליך?'), findsOneWidget);

    // Verify the presence of the text field and dropdown menus
    expect(find.byType(TextField), findsWidgets);
    expect(find.byType(DropdownMenu<String>), findsNWidgets(2));
  });

  testWidgets('InitialFormPage2 text field input', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Enter text in the name text field
    await tester.enterText(find.byType(TextField).first, 'Test Name');
    await tester.pump();

    // Verify the entered text
    expect(find.text('Test Name'), findsOneWidget);
  });

  testWidgets('InitialFormPage2 dropdown menu selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Tap on the age dropdown menu and select an option
    await tester.tap(find.byType(DropdownMenu<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('30-40').last);
    await tester.pumpAndSettle();

    // Verify the selected age
    expect(find.text('30-40'), findsWidgets);

    // Tap on the gender dropdown menu and select an option
    await tester.tap(find.byType(TextField).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('נקבה').last);
    await tester.pumpAndSettle();

    // Verify the selected gender
    expect(find.text('נקבה'), findsWidgets);
  });

  testWidgets('InitialFormPage2 button tap', (WidgetTester tester) async {
    // Override the mockNext function to set a flag when called

    await tester.pumpWidget(createTestWidget());

    // Enter text in the name text field
    await tester.enterText(find.byType(TextField).first, 'Test Name');
    await tester.pump();

    // Tap the next button
    await tester.scrollUntilVisible(
      find.text('המשך'),
      500.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('המשך'));
    await tester.pumpAndSettle();
    expect(nextTapped, isTrue);
  });
}
