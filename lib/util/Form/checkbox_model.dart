// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckboxModel with ChangeNotifier {
  //database items boolean list marking which of the items from the database are chosen by the user in the form:
  List<bool> selectedItems = [];
  //items added by the user in the form INCLUDING the items from the database marked as 'true' in selectedItems:
  List<String> addedStrings = [];
  //items from the database:
  List<String> databaseItems = [];

  String header;
  String subTitle;
  String midTitle;
  String midSubTitle;
  String formKey;
  int length = 3;
  String get getFormKey => formKey;
  CheckboxModel(this.formKey, String collectionName, this.header, this.subTitle,
      this.midTitle, this.midSubTitle) {
    //NOTICE WHEN ADDING NEW FORMS: the formKey should be the same as the collectionName
    formKey = collectionName;
    init();
  }
  void reset() {
    addedStrings = [];
    selectedItems = List<bool>.filled(databaseItems.length, false);
    notifyListeners();
  }

  Future<void> init() async {
    loadDatabaseItems([]);
    loadSelectedItems();
    //loadAddedStrings();
  }

  void editItem(int index, String text) {
    String oldText = addedStrings[index];
    addedStrings[index] = text;
    if (databaseItems.contains(oldText) && oldText != text) {
      selectedItems[databaseItems.indexOf(oldText)] = false;
    }
    notifyListeners();
  }

  void updateProperties(String newHeader, String newSubTitle,
      String newMidTitle, String newMidSubTitle) {
    header = newHeader;
    subTitle = newSubTitle;
    midTitle = newMidTitle;
    midSubTitle = newMidSubTitle;
    notifyListeners();
  }

  void deleteitem(int index) {
    String text = addedStrings[index];

    addedStrings.removeAt(index);
    if (databaseItems.contains(text)) {
      selectedItems[databaseItems.indexOf(text)] = false;
    }
    saveSelectedItems();
    notifyListeners();
  }

  void addItem(List<String> item) {
    addedStrings = ([...addedStrings, ...item]);
    //print(item);
    notifyListeners();
  }

  void increase() {
    /*print(databaseItems.length);
    print(selectedItems.length);
    print(addedStrings.length);*/
    if (length < databaseItems.length) {
      length = length + 1;
      notifyListeners();
    }
  }
  /*void loadAddedStrings() async {
    final prefs = await SharedPreferences.getInstance();
    addedStrings = (prefs.getStringList('addedStrings' + formKey) ?? []);
    notifyListeners();
  }*/

  Future<void> loadSelectedItems() async {
    final prefs = await SharedPreferences.getInstance();
    selectedItems.clear(); // Clear the list before loading
    var list = prefs.getStringList('selectedItems$formKey');
    selectedItems = List<bool>.filled(databaseItems.length, false);
    if (list != null) {
      if (list.length != databaseItems.length) {
        for (int i = 0; i < list.length; i++) {
          selectedItems[i] = list[i] == "true";
        }
      }
    }
  }

  void createSelection(userInfo) async {
    final prefs = await SharedPreferences.getInstance();

    //databaseItems = (prefs.getStringList('databaseItems' + formKey) ?? []);
    print(formKey);

    switch (formKey) {
      case 'PersonalPlan-DifficultEvents':
        print(userInfo.difficultEvents);
        userInfo.difficultEvents = [...addedStrings];

        break;
      case 'PersonalPlan-MakeSafer':
        userInfo.makeSafer = [...addedStrings];
        break;
      case 'PersonalPlan-FeelBetter':
        userInfo.feelBetter = [...addedStrings];
        break;
      case 'PersonalPlan-Distractions':
        userInfo.distractions = [...addedStrings];
        break;
      default:
    }
    prefs.setStringList('userSelection$formKey', [...addedStrings]);
    prefs.setStringList('addedStrings$formKey', [...addedStrings]);

    //await loadSelectedItems();
    notifyListeners();
  }

  void addDatabaseItems(item) async {
    databaseItems = [...databaseItems, item];
    selectedItems.add(false);
    final prefs = await SharedPreferences.getInstance();

    //databaseItems = (prefs.getStringList('databaseItems' + formKey) ?? []);
    prefs.setStringList('databaseItems$formKey', [...databaseItems]);
    //await loadSelectedItems();
    notifyListeners();
  }

  void loadDatabaseItems(items) {
    databaseItems.clear();
    databaseItems = [...items];

    notifyListeners();
  }

  void saveSelectedItems() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedItems$formKey',
        selectedItems.map((item) => item ? 'true' : 'false').toList());
    notifyListeners();
  }


  bool isSelected(int index) {
    // Ensure the index is valid for databaseItems.
    if (index < databaseItems.length) {
      String item = databaseItems[index];

      // Check if the item is in addedStrings and not supposed to be selected.
      if (addedStrings.contains(item)) {
        // If the item is in addedStrings, it should be selected.
        return true;
      } else {
        // If the item is not in addedStrings, its selection status is determined by selectedItems.
        // Ensure index is valid for selectedItems as well.
        if (index < selectedItems.length) {
          return selectedItems[index];
        } else {
          // If the index is out of bounds for selectedItems, it's not selected.
          return false;
        }
      }
    } else {
      // If the index is out of bounds for databaseItems, it's not selected.
      return false;
    }
  }

  void setSelected(int index, bool value, String item) {
    if (index < databaseItems.length) {
      selectedItems[index] = value;
    }
    if (value == true) {
      addedStrings.add(item);
    } else {
      addedStrings.remove(item);
    }
    //TODO: update addedStrings
    saveSelectedItems();
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

}
