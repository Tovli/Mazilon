import 'package:shared_preferences/shared_preferences.dart';

//this creates the json that is need with the user's information
Future<Map<String, dynamic>> getData(userInfoProvider, phonePageData) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  //var uuid = Uuid();
  var data = {
    'dataUser': userInfoProvider.toJson(),
    'dataPhones': phonePageData.toJson(),
    'selectedItemsPersonalPlan-DifficultEvents':
        prefs.getStringList('selectedItemsPersonalPlan-DifficultEvents'),
    'selectedItemsPersonalPlan-MakeSafer':
        prefs.getStringList('selectedItemsPersonalPlan-MakeSafer'),
    'selectedItemsPersonalPlan-FeelBetter':
        prefs.getStringList('selectedItemsPersonalPlan-FeelBetter'),
    'selectedItemsPersonalPlan-Distractions':
        prefs.getStringList('selectedItemsPersonalPlan-Distractions'),
    'addedStringsPersonalPlan-DifficultEvents':
        prefs.getStringList('addedStringsPersonalPlan-DifficultEvents'),
    'addedStringsPersonalPlan-MakeSafer':
        prefs.getStringList('addedStringsPersonalPlan-MakeSafer'),
    'addedStringsPersonalPlan-FeelBetter':
        prefs.getStringList('addedStringsPersonalPlan-FeelBetter'),
    'addedStringsPersonalPlan-Distractions':
        prefs.getStringList('addedStringsPersonalPlan-Distractions'),
    'userSelectionPersonalPlan-DifficultEvents':
        prefs.getStringList('userSelectionPersonalPlan-DifficultEvents'),
    'userSelectionPersonalPlan-MakeSafer':
        prefs.getStringList('userSelectionPersonalPlan-MakeSafer'),
    'userSelectionPersonalPlan-FeelBetter':
        prefs.getStringList('userSelectionPersonalPlan-FeelBetter'),
    'userSelectionPersonalPlan-Distractions':
        prefs.getStringList('userSelectionPersonalPlan-Distractions'),
    'databaseItemsPersonalPlan-DifficultEvents':
        prefs.getStringList('databaseItemsPersonalPlan-DifficultEvents'),
    'databaseItemsPersonalPlan-MakeSafer':
        prefs.getStringList('databaseItemsPersonalPlan-MakeSafer'),
    'databaseItemsPersonalPlan-FeelBetter':
        prefs.getStringList('databaseItemsPersonalPlan-FeelBetter'),
    'databaseItemsPersonalPlan-Distractions':
        prefs.getStringList('databaseItemsPersonalPlan-Distractions'),
  };
  return data;
}
