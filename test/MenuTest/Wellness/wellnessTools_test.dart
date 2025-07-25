import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/AnalyticsService.dart';
import 'package:mazilon/global_enums.dart';
import 'package:mazilon/pages/FeelGood/image_picker_service_impl.dart';
import 'package:mazilon/iFx/service_locator.dart';
import 'package:mazilon/file_service.dart';

import 'package:mazilon/pages/WellnessTools/VideoPlayerPageFactory.dart';
import 'package:mazilon/pages/WellnessTools/more_videos_item.dart';
import 'package:mazilon/pages/home.dart';
import 'package:mazilon/pages/WellnessTools/wellnessTools.dart';
import 'package:mazilon/util/persistent_memory_service.dart';

import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mockito/annotations.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';

import '../TestMenu.dart';
import '../test_data.dart';
import 'FakeVideoPlayerPage.dart';
import 'wellnessTools_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FileService>(),
  MockSpec<VideoPlayerPageFactory>(),
  MockSpec<ImagePickerService>(),
  MockSpec<SharedPreferences>(),
  MockSpec<UserInformation>(),
  MockSpec<AppInformation>(),
  MockSpec<AnalyticsService>(),
  MockSpec<PersistentMemoryService>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WellnessTools Widget Tests', () {
    late MockSharedPreferences mockSharedPreferences;
    late UserInformation mockUserInformation;
    late AppInformation mockAppInformation;
    late GetIt locator;

    setUp(() {
      locator = GetIt.instance;

      // Reset getIt before each test
      locator.reset();
      final mockAnalytics = MockAnalyticsService();
      getIt.registerLazySingleton<AnalyticsService>(() => mockAnalytics);
      final mockFileServiceImpl = MockFileService();
      getIt.registerLazySingleton<FileService>(() => mockFileServiceImpl);
      final mockFactory = MockVideoPlayerPageFactory();
      final mockPersistentMemoryService = MockPersistentMemoryService();
      getIt.registerLazySingleton<PersistentMemoryService>(
          () => mockPersistentMemoryService);
      when(mockPersistentMemoryService.getItem(any, PersistentMemoryType.Bool))
          .thenAnswer((_) async => true);
      when(mockFactory.create(
        onFullScreenChanged: anyNamed('onFullScreenChanged'),
        videoData: anyNamed('videoData'),
      )).thenAnswer((Invocation invocation) {
        final onFullScreenChanged =
            invocation.namedArguments[const Symbol('onFullScreenChanged')]
                as Function(bool);
        final videoData = invocation.namedArguments[const Symbol('videoData')]
            as Map<String, List<String>>;
        return FakeVideoPlayerPage(
          onFullScreenChanged: onFullScreenChanged,
          videoData: videoData,
        );
      });

      getIt.registerSingleton<VideoPlayerPageFactory>(mockFactory);
      final imageFactory = MockImagePickerService();
      when(imageFactory.getOnlineImage(any))
          .thenAnswer((Invocation invocation) {
        return Container(key: const Key("Image"), child: const Text("Image"));
      });

      getIt.registerLazySingleton<ImagePickerService>(() => imageFactory);
      mockSharedPreferences = MockSharedPreferences();
      mockUserInformation = UserInformation();
      mockAppInformation = AppInformation();
      mockUserInformation.gender = "male";
      mockUserInformation.localeName = "he";
      getData(mockAppInformation);

      when(mockSharedPreferences.getBool('enteredBefore')).thenReturn(false);
    });
    testWidgets('Navigate to WellnessTools screen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(getMenuForTests(mockUserInformation, mockAppInformation));
      await tester.tap(find.text('תפריט'));
      await tester.pumpAndSettle();
      expect(find.byType(FractionallySizedBox), findsOneWidget);
      await tester.tap(find.text('כלי תמיכה'));
      await tester.pumpAndSettle();
      expect(find.byType(WellnessTools), findsOneWidget);
    });
    testWidgets('Navigate from WellnessTools screen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(getMenuForTests(mockUserInformation, mockAppInformation));
      await tester.tap(find.text('תפריט'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('כלי תמיכה'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('בית'));
      await tester.pumpAndSettle();
      expect(find.byType(Home), findsOneWidget);
    });
    testWidgets('Test Repeated Navigation to and from WellnessTools screen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(getMenuForTests(mockUserInformation, mockAppInformation));
      await tester.tap(find.text('תפריט'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('כלי תמיכה'));
      await tester.pumpAndSettle();
      expect(find.byType(WellnessTools), findsOneWidget);
      await tester.tap(find.text('בית'));
      await tester.pumpAndSettle();
      expect(find.byType(WellnessTools), findsNothing);
      expect(find.byType(Home), findsOneWidget);
      await tester.tap(find.text('תפריט'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('כלי תמיכה'));
      await tester.pumpAndSettle();
      expect(find.byType(Home), findsNothing);
      expect(find.byType(WellnessTools), findsOneWidget);
      await tester.tap(find.text('בית'));
      await tester.pumpAndSettle();
      expect(find.byType(Home), findsOneWidget);
      expect(find.byType(WellnessTools), findsNothing);
    });
    testWidgets('Test Structure of WellnessTools screen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(getMenuForTests(mockUserInformation, mockAppInformation));
      await tester.tap(find.text('תפריט'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('כלי תמיכה'));
      await tester.pumpAndSettle();
      expect(find.byType(FakeVideoPlayerPage), findsOneWidget);
      expect(find.byType(MoreVideosItem), findsWidgets);
      expect(find.byKey(const Key("Image")), findsOneWidget);
    });
    testWidgets('Test Texts inside WellnessTools screen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(getMenuForTests(mockUserInformation, mockAppInformation));
      await tester.tap(find.text('תפריט'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('כלי תמיכה'));
      await tester.pumpAndSettle();
      expect(find.text("Image"), findsOneWidget);
      expect(find.text('v1'), findsOneWidget);
      expect(find.text('v2'), findsOneWidget);
      expect(find.text('v1d'), findsOneWidget);
      expect(find.text('v2d'), findsNothing);
    });
    testWidgets('Test change video', (WidgetTester tester) async {
      await tester
          .pumpWidget(getMenuForTests(mockUserInformation, mockAppInformation));
      await tester.tap(find.text('תפריט'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('כלי תמיכה'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('v2'));
      await tester.pumpAndSettle();
      expect(find.text("Image"), findsOneWidget);
      expect(find.text('v1'), findsOneWidget);
      expect(find.text('v2'), findsOneWidget);
      expect(find.text('v1d'), findsNothing);
      expect(find.text('v2d'), findsOneWidget);
    });
  });
}
