import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class IncidentLoggerService {
  Future<void> initializeSentry(Widget myApp);
  Future<void> captureLog(dynamic exception,
      {StackTrace? stackTrace, dynamic exceptionData});
}

class SentryServiceImpl implements IncidentLoggerService {
  @override
  Future<void> initializeSentry(Widget myApp) async {
    try {
      await dotenv.load(fileName: "dotenv");
      final sentryDsn = dotenv.env['SENTRY_DSN']?.trim();
      if (sentryDsn == null || sentryDsn.isEmpty) {
        debugPrint("sentry will not be initialized");
        runApp(myApp);
      } else {
        debugPrint("sentry will be initialized");
        await SentryFlutter.init(
          (options) {
            options.dsn = sentryDsn;
          },
          appRunner: () => runApp(myApp),
        );
      }
    } catch (e, stackTrace) {
      debugPrint("sentry will not be initialized,error");
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      runApp(myApp);
    }
  }

  @override
  Future<void> captureLog(dynamic log,
      {StackTrace? stackTrace, dynamic exceptionData}) async {
    if (Sentry.isEnabled) {
      if (exceptionData != null &&
          exceptionData.containsKey("name") &&
          exceptionData.containsKey("value")) {
        Sentry.configureScope((scope) {
          scope.setContexts('${exceptionData["name"]}', exceptionData["value"]);
        });
      }
      await Sentry.captureException(
        log,
        stackTrace: stackTrace,
      );
      return;
    }
  }
}
