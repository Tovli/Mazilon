import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mazilon/EmergencyNumbers.dart';
import 'package:mazilon/global_enums.dart';
import 'package:mazilon/l10n/app_localizations.dart';
import 'package:mazilon/util/Phone/emergencyDialogBox.dart';
import 'package:mazilon/util/Phone/phoneTextAndIcon.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/persistent_memory_service.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class FakePersistentMemoryService implements PersistentMemoryService {
  @override
  Future<dynamic> getItem(String key, PersistentMemoryType type) async {
    return null;
  }

  @override
  Future<void> reset() async {}

  @override
  Future<void> setItem(
      String key, PersistentMemoryType type, dynamic value) async {}
}

class FakeUrlLauncherPlatform extends UrlLauncherPlatform {
  String? lastLaunchedUrl;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async {
    return true;
  }

  @override
  Future<bool> launch(
    String url, {
    required bool useSafariVC,
    required bool useWebView,
    required bool enableJavaScript,
    required bool enableDomStorage,
    required bool universalLinksOnly,
    required Map<String, String> headers,
    String? webOnlyWindowName,
  }) async {
    lastLaunchedUrl = url;
    return true;
  }
}

Widget buildEmergencyDialogTestApp({
  required EmergencyDialogBox dialog,
  required UserInformation userInformation,
  required AppInformation appInformation,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<UserInformation>.value(value: userInformation),
      ChangeNotifierProvider<AppInformation>.value(value: appInformation),
    ],
    child: MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: const Locale('en'),
      home: ScreenUtilInit(
        designSize: const Size(360, 690),
        child: dialog,
      ),
    ),
  );
}

Widget buildEmergencyDialogRouteHostApp({
  required EmergencyDialogBox dialog,
  required UserInformation userInformation,
  required AppInformation appInformation,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<UserInformation>.value(value: userInformation),
      ChangeNotifierProvider<AppInformation>.value(value: appInformation),
    ],
    child: MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: const Locale('en'),
      home: ScreenUtilInit(
        designSize: const Size(360, 690),
        child: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => dialog,
                  );
                },
                child: const Text('Open Emergency Dialog'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  test('Israel emergency numbers include correct Eran phone + WhatsApp', () {
    final israel = countries['israel'];
    expect(israel, isNotNull);

    final eran = israel!.emergencyNumbers
        .firstWhere((entry) => entry['number'] == '1201');

    expect(eran['number'], '1201');
    expect(eran['whatsapp'], true);
    expect(eran['whatsappNumber'], '972528451201');
  });

  test('105 entry is call-only (no WhatsApp action)', () {
    final israel = countries['israel'];
    expect(israel, isNotNull);

    final entry105 =
        israel!.emergencyNumbers.firstWhere((entry) => entry['name'] == '105');

    expect(entry105['number'], '105');
    expect(entry105['whatsapp'], false);
    expect(entry105.containsKey('whatsappNumber'), isFalse);
  });

  test('Emergency numbers match reference data for AU/US/UK/EU', () {
    final usa = countries['usa'];
    final uk = countries['uk'];
    final eu = countries['eu'];
    final australia = countries['australia'];

    expect(usa, isNotNull);
    expect(uk, isNotNull);
    expect(eu, isNotNull);
    expect(australia, isNotNull);

    final usaEmergency = usa!.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'Emergency');
    expect(usaEmergency['number'], '911');

    final veterans = usa.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'Veterans Crisis Line');
    expect(veterans['number'], '18002738255');

    final trevor = usa.emergencyNumbers.firstWhere(
        (entry) => entry['name'] == 'The Trevor Project (for LGBTQ+ youth)');
    expect(trevor['number'], '18664887386');

    final lifeline = usa.emergencyNumbers.firstWhere(
        (entry) => entry['name'] == 'National Suicide Prevention Lifeline');
    expect(lifeline['number'], '988');
    expect(lifeline['link'], 'https://chat.988lifeline.org/');

    final crisisTextLine = usa.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'Crisis Text Line');
    expect(crisisTextLine['number'], '741741');

    final ukEmergency = uk!.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'Emergency');
    expect(ukEmergency['number'], '999');

    final samaritans = uk.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'Samaritans');
    expect(samaritans['number'], '116123');
    expect(samaritans['link'],
        'https://www.samaritans.org/how-we-can-help/contact-samaritan/');

    final shout =
        uk.emergencyNumbers.firstWhere((entry) => entry['name'] == 'Shout');
    expect(shout['number'], '85258');

    final calm = uk.emergencyNumbers.firstWhere((entry) =>
        entry['name'] == 'CALM (Campaign Against Living Miserably, for men)');
    expect(calm['number'], '0800585858');

    final papyrus = uk.emergencyNumbers.firstWhere(
        (entry) => entry['name'] == 'Papyrus (for people under 35)');
    expect(papyrus['number'], '08000684141');

    final euEmergency = eu!.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'European Emergency Number');
    expect(euEmergency['number'], '112');
    expect(euEmergency['link'], '');

    final mentalHealthEurope = eu.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'Mental Health Europe');
    expect(mentalHealthEurope['link'], 'https://mhe-sme.org/');

    final auEmergency = australia!.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'Emergency');
    expect(auEmergency['number'], '000');

    final lifelineAu = australia.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'Lifeline Australia');
    expect(lifelineAu['number'], '131114');
    expect(
        lifelineAu['link'], 'https://www.lifeline.org.au/chat?q=crisis-chat/');

    final beyondBlue = australia.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'Beyond Blue');
    expect(beyondBlue['number'], '1300224636');
    expect(beyondBlue['link'],
        'https://www.beyondblue.org.au/get-support/talk-to-a-counsellor/chat');

    final kidsHelpline = australia.emergencyNumbers.firstWhere(
        (entry) => entry['name'] == 'Kids Helpline (for people aged 5-25)');
    expect(kidsHelpline['number'], '1800551800');

    final mensLine = australia.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'MensLine Australia');
    expect(mensLine['number'], '1300789978');
  });

  test('All emergency entries have consistent and valid link fields', () {
    for (final country in countries.values) {
      for (final entry in country.emergencyNumbers) {
        expect(entry.containsKey('link'), isTrue,
            reason: 'Missing link key for ${country.id} / ${entry['name']}');
        if (entry['whatsapp'] == true) {
          final whatsappNumber =
              (entry['whatsappNumber'] ?? '').toString().trim();
          expect(whatsappNumber.isNotEmpty, isTrue,
              reason:
                  'whatsapp=true requires whatsappNumber for ${country.id} / ${entry['name']}');
        }

        final link = (entry['link'] ?? '').toString().trim();
        if (link.isEmpty) {
          continue;
        }

        final uri = Uri.tryParse(link);
        expect(uri, isNotNull,
            reason: 'Invalid URL for ${country.id} / ${entry['name']}');
        expect(uri!.hasScheme, isTrue,
            reason: 'Missing scheme in ${country.id} / ${entry['name']}');
        expect(uri.host.isNotEmpty, isTrue,
            reason: 'Missing host in ${country.id} / ${entry['name']}');
        expect(uri.scheme == 'https' || uri.scheme == 'http', isTrue,
            reason:
                'Unsupported URL scheme in ${country.id} / ${entry['name']}');
      }
    }
  });

  testWidgets('EmergencyDialogBox uses whatsappNumber for WhatsApp action',
      (tester) async {
    final originalPlatform = UrlLauncherPlatform.instance;
    final fakePlatform = FakeUrlLauncherPlatform();
    UrlLauncherPlatform.instance = fakePlatform;
    addTearDown(() {
      UrlLauncherPlatform.instance = originalPlatform;
    });

    final userInfo = UserInformation(
      gender: 'male',
      service: FakePersistentMemoryService(),
    );
    final appInfo = AppInformation();

    await tester.pumpWidget(
      buildEmergencyDialogTestApp(
        dialog: const EmergencyDialogBox(
          number: '105',
          whatsappNumber: '0521210105',
          link: '',
          hasWhatsApp: true,
          hasLink: false,
          canCall: false,
        ),
        userInformation: userInfo,
        appInformation: appInfo,
      ),
    );

    await tester.tap(find.byIcon(Icons.chat));
    await tester.pumpAndSettle();

    expect(fakePlatform.lastLaunchedUrl, 'https://wa.me/0521210105');
  });

  testWidgets('EmergencyDialogBox opens website link action', (tester) async {
    final originalPlatform = UrlLauncherPlatform.instance;
    final fakePlatform = FakeUrlLauncherPlatform();
    UrlLauncherPlatform.instance = fakePlatform;
    addTearDown(() {
      UrlLauncherPlatform.instance = originalPlatform;
    });

    final userInfo = UserInformation(
      gender: 'male',
      service: FakePersistentMemoryService(),
    );
    final appInfo = AppInformation();

    await tester.pumpWidget(
      buildEmergencyDialogTestApp(
        dialog: const EmergencyDialogBox(
          number: '988',
          whatsappNumber: '988',
          link: 'https://chat.988lifeline.org/',
          hasWhatsApp: false,
          hasLink: true,
          canCall: false,
        ),
        userInformation: userInfo,
        appInformation: appInfo,
      ),
    );

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(fakePlatform.lastLaunchedUrl, 'https://chat.988lifeline.org/');
  });

  testWidgets(
      'EmergencyDialogBox renders all three actions and label tap launches normalized link',
      (tester) async {
    final originalPlatform = UrlLauncherPlatform.instance;
    final fakePlatform = FakeUrlLauncherPlatform();
    UrlLauncherPlatform.instance = fakePlatform;
    addTearDown(() {
      UrlLauncherPlatform.instance = originalPlatform;
    });

    final userInfo = UserInformation(
      gender: 'male',
      service: FakePersistentMemoryService(),
    );
    final appInfo = AppInformation();

    await tester.pumpWidget(
      buildEmergencyDialogTestApp(
        dialog: const EmergencyDialogBox(
          number: '988',
          whatsappNumber: '741741',
          link: 'chat.988lifeline.org',
          hasWhatsApp: true,
          hasLink: true,
          canCall: true,
        ),
        userInformation: userInfo,
        appInformation: appInfo,
      ),
    );

    expect(find.byType(Wrap), findsOneWidget);
    expect(find.byIcon(Icons.phone), findsOneWidget);
    expect(find.byIcon(Icons.chat), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);

    // Tap the action label, not the icon, to verify full-row tappable behavior.
    await tester.tap(find.text('Link to site'));
    await tester.pumpAndSettle();

    expect(fakePlatform.lastLaunchedUrl, 'https://chat.988lifeline.org');
  });

  testWidgets('EmergencyDialogBox skips invalid link schemes safely',
      (tester) async {
    final originalPlatform = UrlLauncherPlatform.instance;
    final fakePlatform = FakeUrlLauncherPlatform();
    UrlLauncherPlatform.instance = fakePlatform;
    addTearDown(() {
      UrlLauncherPlatform.instance = originalPlatform;
    });

    final userInfo = UserInformation(
      gender: 'male',
      service: FakePersistentMemoryService(),
    );
    final appInfo = AppInformation();

    await tester.pumpWidget(
      buildEmergencyDialogTestApp(
        dialog: const EmergencyDialogBox(
          number: '988',
          whatsappNumber: '988',
          link: 'ftp://example.com/resource',
          hasWhatsApp: false,
          hasLink: true,
          canCall: false,
        ),
        userInformation: userInfo,
        appInformation: appInfo,
      ),
    );

    await tester.tap(find.text('Link to site'));
    await tester.pumpAndSettle();

    expect(fakePlatform.lastLaunchedUrl, isNull);
  });

  testWidgets('EmergencyDialogBox closes when launched from showDialog route',
      (tester) async {
    final originalPlatform = UrlLauncherPlatform.instance;
    final fakePlatform = FakeUrlLauncherPlatform();
    UrlLauncherPlatform.instance = fakePlatform;
    addTearDown(() {
      UrlLauncherPlatform.instance = originalPlatform;
    });

    final userInfo = UserInformation(
      gender: 'male',
      service: FakePersistentMemoryService(),
    );
    final appInfo = AppInformation();

    await tester.pumpWidget(
      buildEmergencyDialogRouteHostApp(
        dialog: const EmergencyDialogBox(
          number: '988',
          whatsappNumber: '988',
          link: 'chat.988lifeline.org',
          hasWhatsApp: false,
          hasLink: true,
          canCall: false,
        ),
        userInformation: userInfo,
        appInformation: appInfo,
      ),
    );

    await tester.tap(find.text('Open Emergency Dialog'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text('Link to site'));
    await tester.pumpAndSettle();

    expect(fakePlatform.lastLaunchedUrl, 'https://chat.988lifeline.org');
    expect(find.byType(AlertDialog), findsNothing);
  });

  test('dialPhone does not launch when phone dialing is unsupported', () async {
    final originalPlatform = UrlLauncherPlatform.instance;
    final fakePlatform = FakeUrlLauncherPlatform();
    final originalDialingSupportOverride = debugPhoneDialingSupportedOverride;
    UrlLauncherPlatform.instance = fakePlatform;
    debugPhoneDialingSupportedOverride = false;

    addTearDown(() {
      UrlLauncherPlatform.instance = originalPlatform;
      debugPhoneDialingSupportedOverride = originalDialingSupportOverride;
    });

    await dialPhone('911');

    expect(fakePlatform.lastLaunchedUrl, isNull);
  });
}
