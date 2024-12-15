import 'package:flutter/foundation.dart';

//this it the user's information class, with it we store and display it across the app
class UserInformation with ChangeNotifier {
  String localeName;
  String gender;
  String name;
  String age;
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

  void reset() {
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
    localeName = 'he';

    notifyListeners();
  }

  void updateGender(String text) {
    gender = text;
    notifyListeners();
  }

  void updateName(String text) {
    name = text;

    notifyListeners();
  }

  void updateAge(String text) {
    age = text;
    notifyListeners();
  }

  void updateBinary(bool value) {
    binary = value;
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
    positiveTraits = [...value];
    notifyListeners();
  }

  void updateThanks(Map<String, List<String>> value) {
    thanks = value.map((key, list) => MapEntry(key, List<String>.from(list)));
    notifyListeners();
  }
}
