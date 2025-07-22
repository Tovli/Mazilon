import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/AnalyticsService.dart';
import 'package:mazilon/global_enums.dart';
import 'package:mazilon/pages/FeelGood/add_Image_item.dart';
import 'package:mazilon/pages/FeelGood/feelGood.dart';
import 'package:mazilon/pages/FeelGood/image_display_item.dart';

import 'package:mazilon/pages/FeelGood/image_picker_service_impl.dart';
import 'package:mazilon/iFx/service_locator.dart';

import 'package:mazilon/pages/WellnessTools/VideoPlayerPageFactory.dart';

import 'package:mazilon/pages/home.dart';
import 'package:mazilon/file_service.dart';
import 'package:mazilon/util/persistent_memory_service.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mockito/annotations.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';

import '../TestMenu.dart';
import '../test_data.dart';

import 'feelGood_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<VideoPlayerPageFactory>(),
  MockSpec<FileService>(),
  MockSpec<ImagePickerService>(),
  MockSpec<SharedPreferences>(),
  MockSpec<UserInformation>(),
  MockSpec<AppInformation>(),
  MockSpec<AnalyticsService>(),
  MockSpec<PersistentMemoryService>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FeelGood Widget Tests', () {
    late MockSharedPreferences mockSharedPreferences;
    late UserInformation mockUserInformation;
    late AppInformation mockAppInformation;

    late GetIt locator;

    setUp(() {
      locator = GetIt.instance;

      // Reset getIt before each test
      locator.reset();
      final mockFileServiceImpl = MockFileService();
      final mockAnalytics = MockAnalyticsService();
      getIt.registerLazySingleton<AnalyticsService>(() => mockAnalytics);
      getIt.registerLazySingleton<FileService>(() => mockFileServiceImpl);

      final mockPersistentMemoryService = MockPersistentMemoryService();

      // Set up mock behaviors for PersistentMemoryService
      when(mockPersistentMemoryService.getItem(any, any))
          .thenAnswer((_) async => null);
      when(mockPersistentMemoryService.getItem(any, PersistentMemoryType.Bool))
          .thenAnswer((_) async => true);
      when(mockPersistentMemoryService.setItem(any, any, any))
          .thenAnswer((_) async {});
      when(mockPersistentMemoryService.reset()).thenAnswer((_) async {});

      // Register PersistentMemoryService with GetIt
      getIt.registerLazySingleton<PersistentMemoryService>(
          () => mockPersistentMemoryService);

      final mockFactory = MockVideoPlayerPageFactory();
      getIt.registerSingleton<VideoPlayerPageFactory>(mockFactory);
      final imageFactory = MockImagePickerService();
      getIt.registerLazySingleton<ImagePickerService>(() => imageFactory);
      when(imageFactory.displayImage(any, fit: anyNamed('fit')))
          .thenAnswer((Invocation invocation) {
        final String path = invocation.positionalArguments[0] as String;
        return Container(
            key: Key(path),
            child: Text(
              path,
            ));
      });
      when(imageFactory.loadImagePaths(any))
          .thenAnswer((Invocation invocation) async {
        List<String> list = invocation.positionalArguments[0] as List<String>;
        list.addAll([]);
      });
      when(imageFactory.deleteImage(any, any))
          .thenAnswer((Invocation invocation) async {
        final index = invocation.positionalArguments[0] as int;
        List<String> list = invocation.positionalArguments[1] as List<String>;
        list.removeAt(index);
        //list.addAll(['test1', 'test2']);
      });
      when(imageFactory.getImage(any, any))
          .thenAnswer((Invocation invocation) async {
        List<String> list = invocation.positionalArguments[1] as List<String>;

        list.addAll(['added']);
      });

      mockSharedPreferences = MockSharedPreferences();
      mockUserInformation = UserInformation();
      mockAppInformation = AppInformation();
      mockUserInformation.gender = "male";
      mockUserInformation.localeName = "he";
      getData(mockAppInformation);
      when(mockSharedPreferences.getBool('enteredBefore')).thenReturn(false);
    });

    testWidgets('Navigate to FeelGood screen', (WidgetTester tester) async {
      await tester
          .pumpWidget(getMenuForTests(mockUserInformation, mockAppInformation));

      await tester.tap(find.text('להרגיש טוב'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byType(FeelGood), findsOneWidget);
      expect(find.byType(ImageAddItem), findsWidgets);
      expect(find.byType(ImageDisplay), findsNothing);
    });
    testWidgets('Navigate back from FeelGood screen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(getMenuForTests(mockUserInformation, mockAppInformation));

      await tester.tap(find.text('תפריט'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byType(FractionallySizedBox), findsOneWidget);
      await tester.tap(find.text('להרגיש טוב'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.text('בית'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byType(Home), findsOneWidget);
    });
    testWidgets('Test adding photo from Camera', (WidgetTester tester) async {
      await tester
          .pumpWidget(getMenuForTests(mockUserInformation, mockAppInformation));

      await tester.tap(find.text('להרגיש טוב'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byKey(const Key("addImgButtonText")), findsOneWidget);
      await tester.tap(find.byKey(const Key("addImgButtonText")));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byKey(const Key("cameraButtonText")), findsOneWidget);
      await tester.tap(find.byKey(const Key("cameraButtonText")));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('added'), findsWidgets);
      expect(find.byType(ImageDisplay), findsOneWidget);
      expect(find.byType(ImageAddItem), findsOneWidget);
    });
    testWidgets('Test Adding Photo Gallery', (WidgetTester tester) async {
      await tester
          .pumpWidget(getMenuForTests(mockUserInformation, mockAppInformation));

      await tester.tap(find.text('להרגיש טוב'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.byKey(const Key("addImgButtonText")));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byKey(const Key("galleryButtonText")), findsOneWidget);
      await tester.tap(find.byKey(const Key("galleryButtonText")));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('added'), findsWidgets);
      expect(find.byType(ImageDisplay), findsOneWidget);
      expect(find.byType(ImageAddItem), findsOneWidget);
    });
    testWidgets('Delete photos', (WidgetTester tester) async {
      await tester
          .pumpWidget(getMenuForTests(mockUserInformation, mockAppInformation));

      await tester.tap(find.text('להרגיש טוב'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.byKey(const Key("addImgButtonText")));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.byKey(const Key("cameraButtonText")));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.text('added'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byKey(const Key('deleteButtonIcon')), findsOneWidget);
      await tester.tap(find.byKey(const Key('deleteButtonIcon')));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byKey(const Key('deleteButtonText')), findsOneWidget);
      await tester.tap(find.byKey(const Key('deleteButtonText')));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('added'), findsNothing);
      expect(find.byType(ImageDisplay), findsNothing);
      expect(find.byType(ImageAddItem), findsWidgets);
    });
  });
}
