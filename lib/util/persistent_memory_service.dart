import 'package:get_it/get_it.dart';
import 'package:mazilon/util/logger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersistentMemoryService {
  Future<void> setItem(String key, String type, dynamic value);
  Future<dynamic> getItem(
    String key,
    String type,
  );
  Future<void> reset();
}

class AndroidPersistentMemoryService implements PersistentMemoryService {
  @override
  Future<void> setItem(String key, String type, dynamic value) async {
    IncidentLoggerService loggerService =
        GetIt.instance<IncidentLoggerService>();
    if (key == "" || value == null) {
      loggerService.captureLog(
        'Invalid key or value for persistent memory service',
      );
    }

    try {
      var prefs = await SharedPreferences.getInstance();
      switch (type) {
        case 'String':
          print('Setting item: $key with value: $value');
          prefs.setString(key, value);
        case 'int':
          prefs.setInt(key, value);
        case 'double':
          prefs.setDouble(key, value);
        case 'bool':
          prefs.setBool(key, value);
        case 'StringList':
          prefs.setStringList(key, List<String>.from(value));
        default:
          throw Exception(
            'Unsupported type for persistent memory service: $type',
          );
      }
    } catch (error, stackTrace) {
      loggerService.captureLog(
        error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<dynamic> getItem(String key, String type) async {
    IncidentLoggerService loggerService =
        GetIt.instance<IncidentLoggerService>();
    try {
      var prefs = await SharedPreferences.getInstance();
      switch (type) {
        case 'String':
          return prefs.getString(key) ?? "";
        case 'int':
          return prefs.getInt(key) ?? 0;
        case 'double':
          return prefs.getDouble(key) ?? 0.0;
        case 'bool':
          return prefs.getBool(key) ?? false;
        case 'StringList':
          return prefs.getStringList(key) ?? [];
        default:
          throw Exception(
            'Unsupported type for persistent memory service: $type',
          );
      }
    } catch (error, stackTrace) {
      loggerService.captureLog(
        error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> reset() async {
    IncidentLoggerService loggerService =
        GetIt.instance<IncidentLoggerService>();
    try {
      var prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (error, stackTrace) {
      loggerService.captureLog(
        error,
        stackTrace: stackTrace,
      );
    }
  }
}
