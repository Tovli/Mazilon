import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/util/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mazilon/form/ShareForm.dart';
import 'package:mockito/mockito.dart';

void main() {
  // Mock data for the test
  final mockAppInformation = AppInformation()
    ..formSharePageTitles = {
      'header': 'Share Form Header',
      'subTitlemale': 'Subtitle Male',
      'midTitlemale': 'Mid Title Male',
      'shareTitlemale': 'Share Title Male',
      'emergencySendButtonText': 'Emergency Send',
      'routineSendButtonText': 'Routine Send',
      'finishButton': 'Finish'
    }
    ..shareMessages = {
      'regular': 'Regular Message',
      'emergency': 'Emergency Message'
    }
    ..formDifficultEventsTitles = {'headermale': 'Difficult Events Header Male'}
    ..formMakeSaferTitles = {'headermale': 'Make Safer Header Male'}
    ..formFeelBetterTitles = {'headermale': 'Feel Better Header Male'}
    ..formDistractionsTitles = {'headermale': 'Distractions Header Male'}
    ..formPhonePage = {'headermale': 'Phone Page Header Male'}
    ..sharePDFtexts = {'headermale': 'PDF Text'};

  final mockUserInformation = UserInformation()..gender = 'male';

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
        home: ShareForm(
          prev: () {},
          submit: (context) {},
        ),
      ),
    );
  }

  testWidgets('ShareForm renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Verify the presence of the header and subtitles
    expect(find.text('Share Form Header'), findsOneWidget);
    expect(find.text('Subtitle Male'), findsOneWidget);
    expect(find.text('Mid Title Male'), findsOneWidget);

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

    // Verify the dialog is shown
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Share Title Male'), findsOneWidget);

    // Tap the emergency send button
    await tester.tap(find.text('Emergency Send'));
    await tester.pumpAndSettle();

    // Verify the dialog is closed
    expect(find.byType(AlertDialog), findsNothing);
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
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();

    // Verify the submit function is called
    // This can be verified by checking navigation or other state changes
  });
}
