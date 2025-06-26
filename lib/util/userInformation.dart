import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

//this it the user's information class, with it we store and display it across the app
class UserInformation with ChangeNotifier {
  String localeName;
  String gender;
  String name;
  String age;
  String location;
  bool binary;
  bool disclaimerSigned;
  List<String> difficultEvents;
  List<String> positiveTraits;
  List<String> makeSafer;
  List<String> feelBetter;
  List<String> distractions;
  bool loggedIn;
  String userId;
  int notificationMinute;
  int notificationHour;
  Map<String, List<String>> thanks;

  UserInformation({
    this.location = '',
    this.thanks = const <String, List<String>>{},
    this.positiveTraits = const [],
    this.localeName = '',
    this.notificationHour = 12,
    this.notificationMinute = 0,
    this.gender = '',
    this.name = '',
    this.age = '',
    this.binary = false,
    this.difficultEvents = const [],
    this.makeSafer = const [],
    this.feelBetter = const [],
    this.distractions = const [],
    this.disclaimerSigned = false,
    this.loggedIn = false,
    this.userId = '',
  });

  void reset(String locale) {
    location = '';
    notificationHour = 12;
    notificationMinute = 0;
    gender = '';
    name = '';
    age = '';
    binary = false;
    disclaimerSigned = false;
    difficultEvents = [];
    makeSafer = [];
    feelBetter = [];
    distractions = [];
    loggedIn = false;
    userId = '';
    thanks = {};
    positiveTraits = [];
    localeName = locale;

    notifyListeners();
  }

  void updateGender(String text) {
    void saveGender(String value) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('gender', value);
    }

    gender = text;
    saveGender(text);
    notifyListeners();
  }

  void updateName(String text) {
    void saveName(String value) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('name', value);
    }

    name = text;
    saveName(text);
    notifyListeners();
  }

  void updateAge(String text) {
    void saveAge(String value) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('age', value);
    }

    age = text;
    saveAge(text);
    notifyListeners();
  }

  void updateBinary(bool value) {
    void saveBinary(bool value) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('binary', value);
    }

    binary = value;
    saveBinary(value);
    notifyListeners();
  }

  void updateDifficultEvents(List<String> value) {
    difficultEvents = value;
    notifyListeners();
  }

  void updateMakeSafer(List<String> value) {
    makeSafer = value;
    notifyListeners();
  }

  void updateFeelBetter(List<String> value) {
    feelBetter = value;
    notifyListeners();
  }

  void updateDistractions(List<String> value) {
    distractions = value;
    notifyListeners();
  }

  void updateDisclaimerSigned(bool value) {
    disclaimerSigned = value;
    notifyListeners();
  }

  void updateLoggedIn(bool value) {
    loggedIn = value;
    notifyListeners();
  }

  void updateUserId(String value) {
    userId = value;
    notifyListeners();
  }

  void updateNotificationHour(int value) {
    notificationHour = value;
    notifyListeners();
  }

  void updateNotificationMinute(int value) {
    notificationMinute = value;
    notifyListeners();
  }

  void updateLocaleName(String value) {
    localeName = value;
    notifyListeners();
  }

  void updatePositiveTraits(List<String> value) {
    Future<void> savePositiveTraits(List<String> value) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('positiveTraits', value);
    }

    positiveTraits = [...value];
    savePositiveTraits(value);
    notifyListeners();
  }

  void updateThanks(Map<String, List<String>> value) {
    Future<void> saveThanks(List<String> thanks, List<String> dates) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('thankYous', thanks);
      prefs.setStringList('dates', dates);
    }

    thanks = {"thanks": value["thanks"] ?? [], "dates": value["dates"] ?? []};
    saveThanks(value["thanks"] ?? [], value["dates"] ?? []);
    notifyListeners();
  }

  void updateLocation(String value) {
    location = value;

    notifyListeners();
  }
}
