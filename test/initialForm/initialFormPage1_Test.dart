import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mazilon/initialForm/initialFormPage1.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/styles.dart';
//import 'package:mazilon/initialForm/initialFormPage1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';

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

    await tester.pumpWidget(MultiProvider(
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
          child: InitialFormPage1(
            next: mockNext,
            skip: mockSkip,
            prev: mockPrev,
            updateName: mockUpdateName,
          ),
        ),
      ),
    ));

    final nextButton = find.text('המשך');
    expect(nextButton, findsWidgets);
    await tester.tap(nextButton);
    await tester.pump();
    //expect(find.text("Test Text"), findsOneWidget);

    final skipButton = find.text('דלג');
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
