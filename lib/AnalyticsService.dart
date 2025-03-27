import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

abstract class AnalyticsService {
  Future<void> init();
  Future<void> trackEvent(String eventName, [Map<String, dynamic>? properties]);
}

class MixPanelService implements AnalyticsService {
  late Mixpanel _mixpanel;
  bool _isInitialized = false;
  String key = "";
  @override
  Future<void> init() async {
    await dotenv.load(fileName: ".env");

    if (dotenv.env['MIXPANEL_PROJECT_TOKEN'] == null) {
      return;
    }
    key = dotenv.env['MIXPANEL_PROJECT_TOKEN'] as String;

    // Once you've called this method once, you can access `mixpanel` throughout the rest of your application.
    _mixpanel = await Mixpanel.init(key, trackAutomaticEvents: false);
    _isInitialized = true;
  }

  @override
  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? properties]) async {
    if (key == "") {
      return;
    }
    while (!_isInitialized) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    await _mixpanel.track(eventName, properties: properties);
  }

  Mixpanel get mixpanel => _mixpanel;
}
