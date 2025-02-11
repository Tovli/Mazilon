import 'package:language_code/language_code.dart';

abstract class LocaleService {
  String getLocale();
  void setLocale(String? locale);
}

class LocaleServiceImpl implements LocaleService {
  static String? locale;

  static String getLocaleName() {
    String deviceLocale = LanguageCode.rawLocale.toString();
    switch (deviceLocale) {
      case "he_IL":
        return 'he';
      case "en_US":
        return 'en';
      default:
        return 'en';
    }
  }

  @override
  String getLocale() {
    return locale ?? getLocaleName();
  }

  @override
  void setLocale(String? newLocale) {
    locale = newLocale ?? getLocaleName();
  }
}
