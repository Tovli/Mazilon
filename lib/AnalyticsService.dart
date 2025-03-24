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
    print(dotenv.env);
    if (dotenv.env['MIXPANEL_PROJECT_TOKEN'] == null) {
      print("not analytics");

      return;
    }
    key = dotenv.env['MIXPANEL_PROJECT_TOKEN'] as String;
    print(key);
    // Once you've called this method once, you can access `mixpanel` throughout the rest of your application.
    _mixpanel = await Mixpanel.init(key, trackAutomaticEvents: false);
    _isInitialized = true;
  }

  @override
  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? properties]) async {
    if (key == "") {
      print("no analytics");
      return;
    }
    while (!_isInitialized) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    await _mixpanel.track(eventName, properties: properties);
    print("tracked");
  }

  Mixpanel get mixpanel => _mixpanel;
}

class MixpanelProvider with ChangeNotifier {
  late Mixpanel _mixpanel;
  bool _isInitialized = false;
  Future<void> initMixpanel() async {
    // Once you've called this method once, you can access `mixpanel` throughout the rest of your application.
    _mixpanel = await Mixpanel.init("e38d39b73bc076129d0a5390af41fc24",
        trackAutomaticEvents: false);
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? properties]) async {
    while (!_isInitialized) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    await _mixpanel.track(eventName, properties: properties);
  }

  Mixpanel get mixpanel => _mixpanel;
}
