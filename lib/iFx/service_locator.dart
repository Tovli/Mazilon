import 'package:get_it/get_it.dart';
import 'package:mazilon/pages/FeelGood/image_picker_service_impl.dart';
import 'package:mazilon/pages/WellnessTools/VideoPlayerPageFactory.dart';
import 'package:mazilon/file_service.dart';
import 'package:mazilon/util/logger_service.dart';

// Initialize GetIt instance
final getIt = GetIt.instance;

void setupLocator() {
  // Register YoutubePlayer as a singleton for the VideoPlayerController interface
  getIt.registerLazySingleton<VideoPlayerPageFactory>(
      () => VideoPlayerPageFactoryImpl());
  getIt.registerLazySingleton<ImagePickerService>(
      () => ImagePickerServiceImpl());
  getIt.registerLazySingleton<FileService>(() => FileServiceImpl());
  getIt.registerLazySingleton<LoggerService>(() => SentryServiceImpl());
}
