import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mazilon/global_enums.dart';
import 'package:mazilon/l10n/app_localizations.dart';
import 'package:mazilon/util/Phone/EmergencyPhones.dart';
import 'package:mazilon/util/persistent_memory_service.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';

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

Future<void> _pumpEmergencyGrid(
  WidgetTester tester,
  UserInformation userInformation,
) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<UserInformation>.value(
      value: userInformation,
      child: MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        locale: const Locale('en', 'US'),
        home: const Scaffold(
          body: EmergencyPhonesGrid(),
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
}
