import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mazilon/EmergencyNumbers.dart';
import 'package:mazilon/global_enums.dart';
import 'package:mazilon/l10n/app_localizations.dart';
import 'package:mazilon/util/Phone/emergencyDialogBox.dart';
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
  Future<void> setItem(String key, PersistentMemoryType type, dynamic value) async {}
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

void main() {
  test('Israel emergency numbers include correct Eran phone + WhatsApp', () {
    final israel = countries['israel'];
    expect(israel, isNotNull);

    final eran = israel!.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'ער\"ן');

    expect(eran['number'], '1201');
    expect(eran['whatsapp'], true);
    expect(eran['whatsappNumber'], '972528451201');
  });

  test('105 entry uses WhatsApp chat number 0521210105', () {
    final israel = countries['israel'];
    expect(israel, isNotNull);

    final entry105 = israel!.emergencyNumbers
        .firstWhere((entry) => entry['name'] == '105');

    expect(entry105['number'], '105');
    expect(entry105['whatsapp'], true);
    expect(entry105['whatsappNumber'], '0521210105');
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

    final usaEmergency =
        usa!.emergencyNumbers.firstWhere((entry) => entry['name'] == 'Emergency');
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

    final crisisTextLine = usa.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'Crisis Text Line');
    expect(crisisTextLine['number'], '741741');

    final ukEmergency =
        uk!.emergencyNumbers.firstWhere((entry) => entry['name'] == 'Emergency');
    expect(ukEmergency['number'], '999');

    final samaritans =
        uk.emergencyNumbers.firstWhere((entry) => entry['name'] == 'Samaritans');
    expect(samaritans['number'], '116123');

    final shout =
        uk.emergencyNumbers.firstWhere((entry) => entry['name'] == 'Shout');
    expect(shout['number'], '85258');

    final calm = uk.emergencyNumbers.firstWhere((entry) =>
        entry['name'] == 'CALM (Campaign Against Living Miserably, for men)');
    expect(calm['number'], '0800585858');

    final papyrus = uk.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'Papyrus (for people under 35)');
    expect(papyrus['number'], '08000684141');

    final euEmergency = eu!.emergencyNumbers.firstWhere(
        (entry) => entry['name'] == 'European Emergency Number');
    expect(euEmergency['number'], '112');

    final mentalHealthEurope = eu.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'Mental Health Europe');
    expect(mentalHealthEurope['link'], 'https://mhe-sme.org/');

    final auEmergency = australia!.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'Emergency');
    expect(auEmergency['number'], '000');

    final lifelineAu = australia.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'Lifeline Australia');
    expect(lifelineAu['number'], '131114');

    final beyondBlue = australia.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'Beyond Blue');
    expect(beyondBlue['number'], '1300224636');

    final kidsHelpline = australia.emergencyNumbers.firstWhere(
        (entry) => entry['name'] == 'Kids Helpline (for people aged 5-25)');
    expect(kidsHelpline['number'], '1800551800');

    final mensLine = australia.emergencyNumbers
        .firstWhere((entry) => entry['name'] == 'MensLine Australia');
    expect(mensLine['number'], '1300789978');
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
}
