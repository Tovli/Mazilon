import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mazilon/util/Sync/syncFunction.dart';

//this function is used to sync data from google drive
Future<void> syncData(transactionData, userInfoProvider, phonePageData) async {
  // Decrypt the data
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Convert the decrypted data to a Map
  final decryptedData = jsonDecode(transactionData) as Map<String, dynamic>;
  print(decryptedData);
  updateUserInfo(userInfoProvider, decryptedData['dataUser']);
  prefs.setStringList(
    'selectedItemsPersonalPlan-DifficultEvents',
    List<String>.from(Set.from(
            decryptedData['selectedItemsPersonalPlan-DifficultEvents'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );

  prefs.setStringList(
    'selectedItemsPersonalPlan-MakeSafer',
    List<String>.from(Set.from(
            decryptedData['selectedItemsPersonalPlan-MakeSafer'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );
  prefs.setStringList(
    'selectedItemsPersonalPlan-FeelBetter',
    List<String>.from(Set.from(
            decryptedData['selectedItemsPersonalPlan-FeelBetter'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );
  prefs.setStringList(
    'selectedItemsPersonalPlan-Distractions',
    List<String>.from(Set.from(
            decryptedData['selectedItemsPersonalPlan-Distractions'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );

  prefs.setStringList(
    'addedStringsPersonalPlan-DifficultEvents',
    List<String>.from(Set.from(
            decryptedData['addedStringsPersonalPlan-DifficultEvents'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );
  prefs.setStringList(
    'addedStringsPersonalPlan-MakeSafer',
    List<String>.from(
            Set.from(decryptedData['addedStringsPersonalPlan-MakeSafer'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );
  prefs.setStringList(
    'addedStringsPersonalPlan-FeelBetter',
    List<String>.from(Set.from(
            decryptedData['addedStringsPersonalPlan-FeelBetter'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );
  prefs.setStringList(
    'addedStringsPersonalPlan-Distractions',
    List<String>.from(Set.from(
            decryptedData['addedStringsPersonalPlan-Distractions'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );
  prefs.setStringList(
    'userSelectionPersonalPlan-DifficultEvents',
    List<String>.from(Set.from(
            decryptedData['userSelectionPersonalPlan-DifficultEvents'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );
  prefs.setStringList(
    'userSelectionPersonalPlan-MakeSafer',
    List<String>.from(Set.from(
            decryptedData['userSelectionPersonalPlan-MakeSafer'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );
  prefs.setStringList(
    'userSelectionPersonalPlan-FeelBetter',
    List<String>.from(Set.from(
            decryptedData['userSelectionPersonalPlan-FeelBetter'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );
  prefs.setStringList(
    'userSelectionPersonalPlan-Distractions',
    List<String>.from(Set.from(
            decryptedData['userSelectionPersonalPlan-Distractions'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );
  prefs.setStringList(
    'databaseItemsPersonalPlan-DifficultEvents',
    List<String>.from(Set.from(
            decryptedData['databaseItemsPersonalPlan-DifficultEvents'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );
  prefs.setStringList(
    'databaseItemsPersonalPlan-MakeSafer',
    List<String>.from(Set.from(
            decryptedData['databaseItemsPersonalPlan-MakeSafer'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );
  prefs.setStringList(
    'databaseItemsPersonalPlan-FeelBetter',
    List<String>.from(Set.from(
            decryptedData['databaseItemsPersonalPlan-FeelBetter'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );
  prefs.setStringList(
    'databaseItemsPersonalPlan-Distractions',
    List<String>.from(Set.from(
            decryptedData['databaseItemsPersonalPlan-Distractions'] ?? []))
        .map((item) => item.toString())
        .toList(),
  );

  phonePageData
      .updateFromJson(decryptedData['dataPhones'] as Map<String, dynamic>);

  // Perform the data sync
  // Use Provider or another state management solution to access userInfoProvider and phonePageData
  // Use the data to update the local state
}
