class TypeUtils {
  static List<String> castToStringList(dynamic value) {
    return (value as List<dynamic>?)?.cast<String>() ?? <String>[];
  }

  /// Safely cast a dynamic value to String
  /// Returns an empty string if the value is null
  static String castToString(dynamic value) {
    return value?.toString() ?? '';
  }
}
