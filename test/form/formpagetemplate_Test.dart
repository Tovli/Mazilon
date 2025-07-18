import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/form/formpagetemplate.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:mazilon/l10n/app_localizations.dart';
import 'formpagetemplate_Test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserInformation>(),
  MockSpec<AppInformation>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FeelGood Widget Tests', () {
    late UserInformation mockUserInformation;
    late AppInformation mockAppInformation;
    setUp(() {
      mockUserInformation = UserInformation();
      mockUserInformation.gender = "male";
      mockAppInformation = AppInformation();
    });
    testWidgets('FormPageTemplate widget test', (WidgetTester tester) async {
      // Mocking providers and dependencies

      // Providing mock data to displayInformation

      await tester.pumpWidget(
        MultiProvider(
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
              child: FormPageTemplate(
                next: () {},
                prev: () {},
                collectionName: 'PersonalPlan-DifficultEvents',
              ),
            ),
          ),
        ),
      );

      // Verifying initial UI elements
      expect(find.text('תזכורות לטריגרים נפוצים וגורמי הסלמה'), findsOneWidget);
      expect(find.text('גורמים ואירועים שהקשו עלי בעבר'), findsOneWidget);
      expect(find.text('אין לך רעיון? הנה כמה הצעות'), findsOneWidget);
      expect(find.text('לחץ כדי להוסיף אפשרויות המתאימות לך לתכנית האישית שלך'),
          findsOneWidget);
      expect(find.text('להציג עוד'), findsOneWidget);
      expect(find.text('המשך'), findsOneWidget);

      // Verifying interactions
      await tester.enterText(find.byType(TextField), 'New Suggestion');
      await tester.tap(find.text('הוספה'));
      await tester.pump();

      await tester.tap(find.text('להציג עוד'));
      await tester.pump();

      await tester.tap(find.text('המשך'));
      await tester.pump();
    });
  });
}
