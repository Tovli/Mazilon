import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mazilon/initialForm/initialFormPage1.dart';
import 'package:mazilon/initialForm/initialFormPage2.dart';
import 'package:mazilon/initialForm/toFormPage.dart';

import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';

import 'package:mazilon/initialForm/form.dart';

import 'package:mazilon/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../MenuTest/FeelGood/FeelGood_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserInformation>(),
  MockSpec<AppInformation>(),
  MockSpec<SharedPreferences>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('FeelGood Widget Tests', () {
    late MockSharedPreferences mockSharedPreferences;
    late UserInformation mockUserInformation;
    late AppInformation mockAppInformation;
    late PhonePageData phonePageData;
    setUp(() {
      mockUserInformation = UserInformation();
      mockAppInformation = AppInformation();
      mockUserInformation.gender = "male";
      mockUserInformation.disclaimerSigned = true;
      SharedPreferences.setMockInitialValues({'hasFilled': false});
      phonePageData = PhonePageData(
          header: '',
          phoneNames: [],
          phoneNumbers: [],
          subTitle: '',
          midTitle: '',
          phoneNameTitle: '',
          phoneNumberTitle: '',
          key: '',
          savedPhoneNames: [],
          savedPhoneNumbers: [],
          phoneDescription: []);

      mockSharedPreferences = MockSharedPreferences();
      when(mockSharedPreferences.getStringList('SavedPhoneNames'))
          .thenReturn([]);
      when(mockSharedPreferences.getStringList('SavedPhoneNumbers'))
          .thenReturn([]);
    });

    // Setup the test environment
    // SharedPreferences.setMockInitialValues({'hasFilled': false});

    Widget createTestWidget() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppInformation>.value(
              value: mockAppInformation),
          ChangeNotifierProvider<UserInformation>.value(
              value: mockUserInformation),
        ],
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('he'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ScreenUtilInit(
            designSize: const Size(360, 690),
            child: InitialFormProgressIndicator(
              phonePageData: phonePageData,
              changeLocale: (String locale) {},
            ),
          ),
        ),
      );
    }

    testWidgets('FormPageTemplate widget test', (WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<AppInformation>.value(
              value: mockAppInformation),
          ChangeNotifierProvider<UserInformation>.value(
              value: mockUserInformation),
        ],
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('he'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ScreenUtilInit(
            designSize: const Size(360, 690),
            child: InitialFormProgressIndicator(
              phonePageData: phonePageData,
              changeLocale: (String locale) {},
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      // Verify the initial state
      expect(find.byType(InitialFormPage1), findsOneWidget);
      expect(find.byType(InitialFormPage2), findsNothing);
      expect(find.byType(ToFormPage), findsNothing);

      // Tap the next button
      await tester.scrollUntilVisible(
        find.text('המשך'),
        500.0,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('המשך'));
      await tester.pumpAndSettle();

      // Verify the state after tapping next
      expect(find.byType(InitialFormPage1), findsNothing);
      expect(find.byType(InitialFormPage2), findsOneWidget);
      expect(find.byType(ToFormPage), findsNothing);

      // Tap the next button again
      await tester.scrollUntilVisible(
        find.text('המשך'),
        500.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('המשך'));
      await tester.pumpAndSettle();

      // Verify the state after tapping next
      expect(find.byType(InitialFormPage1), findsNothing);
      expect(find.byType(InitialFormPage2), findsNothing);
      expect(find.byType(ToFormPage), findsOneWidget);
    });
  });
}
