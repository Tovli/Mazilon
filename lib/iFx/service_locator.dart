import 'package:get_it/get_it.dart';
import 'package:mazilon/pages/FeelGood/image_picker_service_impl.dart';
import 'package:mazilon/pages/WellnessTools/VideoPlayerPageFactory.dart';
import 'package:mazilon/util/sentry_service.dart';

// Initialize GetIt instance
final getIt = GetIt.instance;

void setupLocator() {
  // Register YoutubePlayer as a singleton for the VideoPlayerController interface
  getIt.registerLazySingleton<VideoPlayerPageFactory>(
      () => VideoPlayerPageFactoryImpl());
  getIt.registerLazySingleton<ImagePickerService>(
      () => ImagePickerServiceImpl());
  getIt.registerLazySingleton<SentryService>(() => SentryServiceImpl());
}
