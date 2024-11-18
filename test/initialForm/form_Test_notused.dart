import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mazilon/initialForm/initialFormPage1.dart';
import 'package:mazilon/initialForm/initialFormPage2.dart';
import 'package:mazilon/initialForm/toFormPage.dart';
import 'package:mazilon/menu.dart';
import 'package:mazilon/util/Form/checkbox_model.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/disclaimerPage.dart';
import 'package:mazilon/util/styles.dart';

import 'package:mazilon/initialForm/form.dart';

void main() {
  // Mock data for testing
  List<List<String>> collections = [];
  List<String> collectionNames = [];
  Map<String, CheckboxModel> checkboxModels = {};
  PhonePageData phonePageData = PhonePageData(
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

  // Mock providers
  final appInformation = AppInformation();
  final userInformation = UserInformation();

  // Setup the test environment
  setUpAll(() async {
    SharedPreferences.setMockInitialValues(
        {}); // Initialize empty SharedPreferences for testing
  });

  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppInformation>.value(value: appInformation),
        ChangeNotifierProvider<UserInformation>.value(value: userInformation),
      ],
      child: MaterialApp(
        home: InitialFormProgressIndicator(
          collections: collections,
          collectionNames: collectionNames,
          checkboxModels: checkboxModels,
          phonePageData: phonePageData,
        ),
      ),
    );
  }

  testWidgets('InitialFormProgressIndicator navigation test',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Verify the initial state
    expect(find.byType(InitialFormPage1), findsOneWidget);
    expect(find.byType(InitialFormPage2), findsNothing);
    expect(find.byType(ToFormPage), findsNothing);

    // Tap the next button
    await tester.tap(find.text('דלג/י'));
    await tester.pumpAndSettle();

    // Verify the state after tapping next
    expect(find.byType(InitialFormPage1), findsNothing);
    expect(find.byType(InitialFormPage2), findsOneWidget);
    expect(find.byType(ToFormPage), findsNothing);

    // Tap the next button again
    await tester.tap(find.text('דלג/י'));
    await tester.pumpAndSettle();

    // Verify the state after tapping next
    expect(find.byType(InitialFormPage1), findsNothing);
    expect(find.byType(InitialFormPage2), findsNothing);
    expect(find.byType(ToFormPage), findsOneWidget);
  });
}
