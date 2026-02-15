import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mazilon/global_enums.dart';
import 'package:mazilon/l10n/app_localizations.dart';
import 'package:mazilon/util/Phone/EmergencyPhones.dart';
import 'package:mazilon/util/Phone/phoneTextAndIcon.dart';
import 'package:mazilon/util/persistent_memory_service.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class _FakePersistentMemoryService implements PersistentMemoryService {
  @override
  Future<dynamic> getItem(String key, PersistentMemoryType type) async => null;

  @override
  Future<void> reset() async {}

  @override
  Future<void> setItem(
    String key,
    PersistentMemoryType type,
    dynamic value,
  ) async {}
}

class _FakeUrlLauncherPlatform extends UrlLauncherPlatform {
  String? lastLaunchedUrl;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

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

Future<void> _pumpEmergencyGrid(
  WidgetTester tester,
  UserInformation userInformation, {
  Widget? body,
}) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<UserInformation>.value(
      value: userInformation,
      child: MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        locale: const Locale('en', 'US'),
        home: Scaffold(
          body: body ?? const EmergencyPhonesGrid(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('EmergencyPhonesGrid resolves expected layout at each breakpoint',
      (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.devicePixelRatio = 1.0;

    final userInfo = UserInformation(
      location: 'US',
      service: _FakePersistentMemoryService(),
    );

    const testCases = <(double, int, double)>[
      (1600.0, 3, 2.8),
      (1400.0, 2, 2.7),
      (1000.0, 2, 2.3),
      (760.0, 2, 1.8),
      (500.0, 1, 2.8),
      (499.0, 1, 1.8),
    ];

    for (final testCase in testCases) {
      final width = testCase.$1;
      final expectedCrossAxisCount = testCase.$2;
      final expectedAspectRatio = testCase.$3;

      tester.view.physicalSize = Size(width, 1200.0);
      await _pumpEmergencyGrid(tester, userInfo);

      final gridView = tester.widget<GridView>(find.byType(GridView));
      final gridDelegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

      expect(
        gridDelegate.crossAxisCount,
        expectedCrossAxisCount,
        reason: 'Unexpected crossAxisCount for width=$width',
      );
      expect(
        gridDelegate.childAspectRatio,
        expectedAspectRatio,
        reason: 'Unexpected childAspectRatio for width=$width',
      );
    }
  });

  testWidgets(
      'EmergencyPhonesGrid uses parent constraints for breakpoints via LayoutBuilder',
      (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.devicePixelRatio = 1.0;

    // Keep viewport wide and constrain only the grid parent width.
    tester.view.physicalSize = const Size(1200.0, 1200.0);

    final userInfo = UserInformation(
      location: 'US',
      service: _FakePersistentMemoryService(),
    );

    await _pumpEmergencyGrid(
      tester,
      userInfo,
      body: const Center(
        child: SizedBox(
          width: 500,
          child: EmergencyPhonesGrid(),
        ),
      ),
    );

    final gridView = tester.widget<GridView>(find.byType(GridView));
    final gridDelegate =
        gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

    // Width=500 should match the xs breakpoint map (1, 2.8).
    expect(gridDelegate.crossAxisCount, 1);
    expect(gridDelegate.childAspectRatio, 2.8);
  });

  testWidgets(
      'Emergency call-only card is inert when phone dialing is unsupported',
      (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.devicePixelRatio = 1.0;

    final originalPlatform = UrlLauncherPlatform.instance;
    final fakePlatform = _FakeUrlLauncherPlatform();
    final originalDialingSupportOverride = debugPhoneDialingSupportedOverride;
    UrlLauncherPlatform.instance = fakePlatform;
    debugPhoneDialingSupportedOverride = false;

    addTearDown(() {
      UrlLauncherPlatform.instance = originalPlatform;
      debugPhoneDialingSupportedOverride = originalDialingSupportOverride;
    });

    final userInfo = UserInformation(
      location: 'US',
      service: _FakePersistentMemoryService(),
    );

    tester.view.physicalSize = const Size(500, 1200.0);
    await _pumpEmergencyGrid(tester, userInfo);

    await tester.tap(find.text('Emergency'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(fakePlatform.lastLaunchedUrl, isNull);
  });
}
