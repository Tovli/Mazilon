import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

//this it the user's information class, with it we store and display it across the app
class UserInformation with ChangeNotifier {
  String gender;
  String name;
  String age;
  bool binary;
  bool disclaimerSigned;
  List<String> difficultEvents;
  List<String> makeSafer;
  List<String> feelBetter;
  List<String> distractions;
  bool loggedIn;
  String userId;
  List<String> notifications;
  UserInformation({
    this.gender = '',
    this.name = '',
    this.age = '',
    this.binary = false,
    this.difficultEvents = const [],
    this.notifications = const [],
    this.makeSafer = const [],
    this.feelBetter = const [],
    this.distractions = const [],
    this.disclaimerSigned = false,
    this.loggedIn = false,
    this.userId = '',
  });
  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'name': name,
      'age': age,
      'binary': binary,
      'disclaimerSigned': disclaimerSigned,
      'difficultEvents': difficultEvents,
      'makeSafer': makeSafer,
      'feelBetter': feelBetter,
      'distractions': distractions,
      'loggedIn': loggedIn,
      'userId': userId,
    };
  }

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    return UserInformation(
      gender: json['gender'] as String? ?? '',
      name: json['name'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      age: json['age'] as String? ?? '',
      binary: json['binary'] as bool? ?? false,
      loggedIn: json['loggedIn'] as bool? ?? false,
      disclaimerSigned: json['disclaimerSigned'] as bool? ?? false,
      difficultEvents:
          List<String>.from(json['difficultEvents'] as List? ?? []),
      makeSafer: List<String>.from(json['makeSafer'] as List? ?? []),
      feelBetter: List<String>.from(json['feelBetter'] as List? ?? []),
      distractions: List<String>.from(json['distractions'] as List? ?? []),
    );
  }
  void reset() {
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

  void updateNotifications(List<String> value) {
    notifications = [...value];
    notifyListeners();
  }

  void addNotification(String value) {
    notifications.add(value);
    notifyListeners();
  }
}
