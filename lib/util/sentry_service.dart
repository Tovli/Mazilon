import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class SentryService {
  Future<void> initializeSentry(Widget MyApp);
}

class SentryServiceImpl implements SentryService {
  @override
  Future<void> initializeSentry(Widget MyApp) async {
    try {
      await dotenv.load(fileName: ".env");
      if (dotenv.env['SENTRY_DSN'] == null) {
        print("sentry will not be initialized");
        runApp(MyApp);
      } else {
        print("sentry will be initialized");
        await SentryFlutter.init(
          (options) {
            options.dsn = dotenv.env['SENTRY_DSN'] ?? '';
          },
          appRunner: () => runApp(MyApp),
        );
      }
    } catch (e) {
      print("sentry will not be initialized,error");
      print(e);
      runApp(MyApp);
    }
  }
}