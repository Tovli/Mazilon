import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';

import 'package:mazilon/pages/FormAnswer.dart';
import 'package:mazilon/util/Form/retrieveInformation.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/form/formpagetemplate.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([AppInformation, UserInformation])
void main() {
  testWidgets('FormPageTemplate widget test', (WidgetTester tester) async {
    // Mocking providers and dependencies
    final mockAppInfo = AppInformation();
    final mockUserInfo = UserInformation()..gender = 'male';

    when(mockUserInfo.gender).thenReturn('Male');

    // Providing mock data to displayInformation
    when(retrieveInformation(mockAppInfo, any, any)).thenReturn({
      'header': 'Test Header',
      'subTitle': 'Test SubTitle',
      'midTitle': 'Test MidTitle',
      'midSubTitle': 'Test MidSubTitle',
      'showMoreButtonText': 'Show More',
      'nextButtonText': 'Next',
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppInformation>.value(value: mockAppInfo),
          ChangeNotifierProvider<UserInformation>.value(value: mockUserInfo),
        ],
        child: MaterialApp(
          home: FormPageTemplate(
            next: () {},
            prev: () {},
            collectionName: 'collection1',
          ),
        ),
      ),
    );

    // Verifying initial UI elements
    expect(find.text('Test Header'), findsOneWidget);
    expect(find.text('Test SubTitle'), findsOneWidget);
    expect(find.text('Test MidTitle'), findsOneWidget);
    expect(find.text('Test MidSubTitle'), findsOneWidget);
    expect(find.text('Show More'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Verifying interactions
    await tester.enterText(find.byType(TextField), 'New Suggestion');
    await tester.tap(find.text('הוספה'));
    await tester.pump();

    await tester.tap(find.text('Show More'));
    await tester.pump();

    await tester.tap(find.text('Next'));
    await tester.pump();
  });
}
