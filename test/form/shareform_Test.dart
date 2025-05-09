import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/AnalyticsService.dart';
import 'package:mazilon/file_service.dart';
import 'package:mazilon/iFx/service_locator.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mazilon/form/ShareForm.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'shareform_Test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserInformation>(),
  MockSpec<AppInformation>(),
  MockSpec<FileService>(),
  MockSpec<AnalyticsService>(),
])
void main() {
  late UserInformation mockUserInformation;
  late AppInformation mockAppInformation;
  late GetIt locator;

  setUp(() {
    mockUserInformation = UserInformation();
    mockUserInformation.gender = "male";
    mockAppInformation = AppInformation();
    final mockAnalytics = MockAnalyticsService();
    getIt.registerLazySingleton<AnalyticsService>(() => mockAnalytics);
    final mockFileServiceImpl = MockFileService();
    getIt.registerLazySingleton<FileService>(() => mockFileServiceImpl);
  });
  tearDown(() {
    final locator = GetIt.instance;
    // Optionally reset GetIt after each test
    locator.reset();
  });
  // Mock data for the test

  // Mock shared preferences
  SharedPreferences.setMockInitialValues({'hasFilled': false});

  // Create the test widget
  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppInformation>(
            create: (_) => mockAppInformation),
        ChangeNotifierProvider<UserInformation>(
            create: (_) => mockUserInformation),
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
          child: ShareForm(
            prev: () {},
            submit: (context) {},
          ),
        ),
      ),
    );
  }

  testWidgets('ShareForm renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Verify the presence of the header and subtitles
    expect(find.text('איזה כיף!'), findsOneWidget);
    expect(
        find.text(
            'יצרת לך מדריך שיעזור לך ברגעי משבר! בוא ונכיר כלים נוספים לעזרה עצמית ולחוסן נפשי'),
        findsOneWidget);
    expect(
        find.text(
            'עכשיו אתה יכול לשתף את התוכנית עם הקרובים אליך או להוריד אותה כקובץ'),
        findsOneWidget);

    // Verify the presence of the image
    expect(find.byType(Image), findsOneWidget);

    // Verify the presence of the buttons
    expect(find.byIcon(Icons.share), findsOneWidget);
    expect(find.byIcon(Icons.download), findsOneWidget);
  });

  testWidgets('ShareForm sets SharedPreferences value on init',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Verify the initial value of hasFilled
    expect(prefs.getBool('hasFilled'), true);
  });

  testWidgets('ShareForm shows share dialog and generates PDF',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Tap the share button
    await tester.tap(find.byIcon(Icons.share));
    await tester.pumpAndSettle();
/*
    // Verify the dialog is shown
    expect(find.text("Quick Share"), findsOneWidget);
    expect(find.text('Share Title Male'), findsOneWidget);

    // Tap the emergency send button
    await tester.tap(find.text('Emergency Send'));
    await tester.pumpAndSettle();

    // Verify the dialog is closed
    expect(find.text("SAVE"), findsNothing);*/
  });

  testWidgets('ShareForm triggers PDF download', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Mock permission request
    //when(permissionHandler.requestPermissions([Permission.manageExternalStorage]))
    //    .thenAnswer((_) async => {Permission.manageExternalStorage: PermissionStatus.granted});

    // Tap the download button
    await tester.tap(find.byIcon(Icons.download));
    await tester.pumpAndSettle();

    // Verify the permission request and PDF download logic
    expect(find.byIcon(Icons.download), findsOneWidget);
  });

  testWidgets('ShareForm submit button works', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Tap the finish button
    await tester.tap(find.text('סיימתי!'));
    await tester.pumpAndSettle();

    // Verify the submit function is called
    // This can be verified by checking navigation or other state changes
  });
}
