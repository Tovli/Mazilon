// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/util/logger_service.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mazilon/util/Form/checkbox_model.dart';
import 'package:mazilon/util/SignIn/popup_toast.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:firebase_core/firebase_core.dart';

//This is where we handle all of the data fetching for the app
//be it from the server or from the local storage
class FirebaseAuthService {
  final FirebaseAuth _auth;

  FirebaseAuthService(FirebaseApp app)
      : _auth = FirebaseAuth.instanceFor(app: app);

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (error, stackTrace) {
      if (error.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        IncidentLoggerService loggerService =
            GetIt.instance<IncidentLoggerService>();
        await loggerService.captureException(
          error,
          stackTrace: stackTrace,
        );
        showToast(message: 'An error occurred');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return credential.user;
    } on FirebaseAuthException catch (error, stackTrace) {
      if (error.code == 'user-not-found' || error.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred');
        IncidentLoggerService loggerService =
            GetIt.instance<IncidentLoggerService>();
        await loggerService.captureException(
          error,
          stackTrace: stackTrace,
        );
      }
    }
    return null;
  }
}

class Warning {
  final String text;
  final List<String> warnings;

  Warning({required this.text, required this.warnings});
}

Future<void> loadCollections(
  checkboxCollectionNames,
  collections,
  checkboxModels,
  appInfo,
) async {
  print('loadCollections started');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  print(checkboxCollectionNames);
  // Load the collections from the database for checkboxes:
  for (String collectionName in checkboxCollectionNames) {
    String dbName = '${collectionName.split('-')[1]}-Sug';
    final doc = await FirebaseFirestore.instance.collection(dbName).get();
    List<String> collection = [];
    for (var doc in doc.docs) {
      collection.add(doc.get('content'));
    }
    prefs.setStringList('databaseItems$collectionName', collection);
    collections.add(collection);
    // Create a CheckboxModel for each collection
    CheckboxModel model = CheckboxModel(
      collectionName,
      collectionName,
      '',
      '',
      '',
      '',
    );
    checkboxModels[collectionName] = model;
    // Load the values from the SharedPreferences

    List<String> addedStrings =
        prefs.getStringList('addedStrings$collectionName') ?? [];

    model.addItem(addedStrings);
    model.loadDatabaseItems(collection);
  }
}

//upon adding user information, the load function will need to be updated
//use or create functions in userinfo class to update the user information:
Future<void> loadUserInformation(UserInformation userInfo) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  userInfo.updateName(prefs.getString('name') ?? '');
  userInfo.updateGender(prefs.getString('gender') ?? '');
  userInfo.updateBinary(prefs.getBool('binary') ?? false);
  userInfo.updateLoggedIn(prefs.getBool('loggedIn') ?? false);
  userInfo.updateAge(prefs.getString('age') ?? '');
  userInfo.updateUserId(prefs.getString('userId') ?? '');
  List<String> fieldNames = [
    'userSelectionPersonalPlan-DifficultEvents',
    'userSelectionPersonalPlan-MakeSafer',
    'userSelectionPersonalPlan-FeelBetter',
    'userSelectionPersonalPlan-Distractions'
  ];
  userInfo.updateDifficultEvents(prefs.getStringList(fieldNames[0]) ?? []);
  userInfo.updateMakeSafer(prefs.getStringList(fieldNames[1]) ?? []);
  userInfo.updateFeelBetter(prefs.getStringList(fieldNames[2]) ?? []);
  userInfo.updateDistractions(prefs.getStringList(fieldNames[3]) ?? []);

  userInfo
      .updateDisclaimerSigned(prefs.getBool('disclaimerConfirmed') ?? false);
  userInfo.updateNotificationMinute(prefs.getInt('notificationMinute') ?? 0);
  userInfo.updateNotificationHour(prefs.getInt('notificationHour') ?? 12);
}

//upon adding CMS(rowy) texts, this will need to be updated:
//1. add the new variable to the appInfo class
//2. add the new variable to the createJson function
//3. add the new variable to the loadAppInfoFromJson function
//4. add the new variable to the loadAppFromFirebase function:
//json created only on updated version of rowy data
Map<String, dynamic> createJson(
  AppInformation appInfo,
) {
  Map<String, dynamic> json = {
    'reminderMainTitle': appInfo.reminderMainTitle,
    'reminderSubTitle': appInfo.reminderSubTitle,
    'homeTitleGreeting': appInfo.homeTitleGreeting,
    'personalPlanMainTitle': appInfo.personalPlanMainTitle,
    'personalPlanSubTitle': appInfo.personalPlanSubTitle,
    'traitMainTitle': appInfo.traitMainTitle,
    'traitSubTitle': appInfo.traitSubTitle,
    'journalMainTitle': appInfo.journalMainTitle,
    'othersuggestions': appInfo.othersuggestions,
    'journalSubTitle': appInfo.journalSubTitle,
    'journalPopUpText': appInfo.journalPopUpText,
    'positiveTraitsPopUpText': appInfo.positiveTraitsPopUpText,
    'returnToPlanStrings': appInfo.returnToPlanStrings,
    'personalInformationForm': appInfo.personalInformationForm,
    'signUpLoginPage': appInfo.signUpLoginPage,
    'introductionFormFirstPage': appInfo.introductionFormFirstPage,
    'introductionFormSecondPage': appInfo.introductionFormSecondPage,
    'introductionFormLastPage': appInfo.introductionFormLastPage,
    'warningHomePageTitles': appInfo.warningHomePageTitles,
    'traitsHomePageTitles': appInfo.traitsHomePageTitles,
    'formPhonePage': appInfo.formPhonePage,
    'shareMessages': appInfo.shareMessages,
    'formDifficultEventsTitles': appInfo.formDifficultEventsTitles,
    'formDistractionsTitles': appInfo.formDistractionsTitles,
    'formFeelBetterTitles': appInfo.formFeelBetterTitles,
    'formMakeSaferTitles': appInfo.formMakeSaferTitles,
    'formSharePageTitles': appInfo.formSharePageTitles,
    'thanksSuggestionsList': appInfo.thanksSuggestionsList,
    'positiveTraitsSuggestionsList': appInfo.positiveTraitsSuggestionsList,
    'homePageInspirationalQuotes': appInfo.homePageInspirationalQuotes,
    'phonePageTitles': appInfo.phonePageTitles,
    'lastUpdated': DateTime.now().toString(),
    'appVersion': appInfo.appVersion,
    'MakeSaferSug': appInfo.MakeSaferSug,
    'FeelBetterSug': appInfo.FeelBetterSug,
    'DistractionsSug': appInfo.DistractionsSug,
    'DifficultEventsSug': appInfo.DifficultEventsSug,
    'sharePDFtexts': appInfo.sharePDFtexts,
    'aboutPageText': appInfo.aboutPageText,
    'disclaimerPageText': appInfo.disclaimerText,
    'disclaimerPageNext': appInfo.disclaimerNext,
    'wellnessVideos': appInfo.wellnessVideos,
    'formSkipButtonText': appInfo.formSkipButtonText,
    'feelGoodPageTitles': appInfo.feelGoodPageTitles,
    'extraMenuStrings': appInfo.extraMenuStrings,
    'syncPages': appInfo.syncPages,
    'popupBack': appInfo.popupBack,
    'addFormStrings': appInfo.addFormStrings,
    'addThanksFormStrings': appInfo.addThanksFormStrings,
    'addFormPageTemplateStrings': appInfo.addFormPageTemplateStrings,
    'IntroductionRestart': appInfo.IntroductionRestart,
  };
  return json;
}

//upon adding CMS(rowy) texts, this will need to be updated:
//1. add the new variable to the appInfo class
//2. add the new variable to the createJson function
//3. add the new variable to the loadAppInfoFromJson function using update function created in appinfo class
//4. add the new variable to the loadAppFromFirebase function
Future<bool> loadAppInfoFromJson(
  AppInformation appInfo,
  String path,
  checkboxCollectionNames,
  collections,
  checkboxModels,
) async {
  //Get app version from firestore

  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('VersionManager').get();
  String appVersion = '';
  for (var doc in snapshot.docs) {
    Map<String, dynamic> d = doc.data() as Map<String, dynamic>? ?? {};
    appVersion = d['version'];
  }

  //if a json exists
  File file = File(path);
  if (await file.exists()) {
    try {
      String fileContent = await file.readAsString();
      Map<String, dynamic> json = jsonDecode(fileContent);
      String storedVersion = json['appVersion'];
      //check if the versions match
      if (storedVersion != appVersion) {
        return false;
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      for (String collectionName in checkboxCollectionNames) {
        String appInfoName = '${collectionName.split('-')[1]}Sug';
        //List<String> collection = [];

        List<String> collection = json[appInfoName].cast<String>();
        //.map((doc) => (doc.data() as Map<String, dynamic>)['content'] as String)
        // .toList();

        prefs.setStringList('databaseItems$collectionName', collection);

        //collections.add(collection);
        // Create a CheckboxModel for each collection
        collections.add(collection);
        CheckboxModel model = CheckboxModel(
          collectionName,
          collectionName,
          '',
          '',
          '',
          '',
        );
        checkboxModels[collectionName] = model;
        // Load the values from the SharedPreferences
        List<String> addedStrings =
            prefs.getStringList('addedStrings$collectionName') ?? [];
        model.addItem(addedStrings);
        model.loadDatabaseItems(collection);
      }

      print("data is still new, no need to update it");
      appInfo.updateReminderMainTitle(json['reminderMainTitle']);
      appInfo.updateReminderSubTitle(json['reminderSubTitle']);
      appInfo.updateHomeTitleGreeting(json['homeTitleGreeting']);
      appInfo.updatePersonalPlanMainTitle(
          json['personalPlanMainTitle'].cast<String, String>());

      appInfo.updatePersonalPlanSubTitle(
          json['personalPlanSubTitle'].cast<String, String>());
      appInfo
          .updateTraitMainTitle(json['traitMainTitle'].cast<String, String>());

      appInfo.updateTraitSubTitle(json['traitSubTitle'].cast<String, String>());

      appInfo.updateJournalMainTitle(
          json['journalMainTitle'].cast<String, String>());
      appInfo.updateOtherSuggestions(
          json['othersuggestions'].cast<String, String>());
      appInfo.updateJournalSubTitle(
          json['journalSubTitle'].cast<String, String>());

      appInfo.updateJournalPopUpText(
          json['journalPopUpText'].cast<String, String>());
      appInfo.updatePopupBack(json['popupBack'].cast<String, String>());

      appInfo.updatePositiveTraitsPopUpText(
          json['positiveTraitsPopUpText'].cast<String, String>());

      appInfo.updateThanksSuggestionsList(
          json['thanksSuggestionsList'].cast<String>());
      appInfo.updateReturnToPlanStrings(
          json['returnToPlanStrings'].cast<String, String>());
      appInfo.updatePersonalInformationForm(
          json['personalInformationForm'].cast<String, String>());
      appInfo.updateSignUpLoginPage(
          json['signUpLoginPage'].cast<String, String>());
      appInfo.updateIntroductionFormFirstPage(
          json['introductionFormFirstPage'].cast<String, String>());

      appInfo.updateIntroductionFormSecondPage(
          json['introductionFormSecondPage'].cast<String, String>());
      appInfo.updateIntroductionFormLastPage(
          json['introductionFormLastPage'].cast<String, String>());
      appInfo.updateWarningHomePageTitles(
          json['warningHomePageTitles'].cast<String, String>());
      appInfo.updateTraitsHomePageTitles(
          json['traitsHomePageTitles'].cast<String, String>());
      appInfo.updateFormPhonePage(json['formPhonePage'].cast<String, String>());
      appInfo.updateShareMessages(json['shareMessages'].cast<String, String>());
      appInfo
          .updateAddFormStrings(json['addFormStrings'].cast<String, String>());

      appInfo.updateAddThanksFormStrings(
          json['addThanksFormStrings'].cast<String, String>());
      appInfo.updateAddFormPageTemplateStrings(
          json['addFormPageTemplateStrings'].cast<String, String>());
      appInfo.updateFormDifficultEventsTitles(
          json['formDifficultEventsTitles'].cast<String, String>());
      appInfo.updateFormDistractionsTitles(
          json['formDistractionsTitles'].cast<String, String>());
      appInfo.updateFormFeelBetterTitles(
          json['formFeelBetterTitles'].cast<String, String>());
      appInfo.updateFormMakeSaferTitles(
          json['formMakeSaferTitles'].cast<String, String>());

      appInfo.updateFormSharePageTitles(
          json['formSharePageTitles'].cast<String, String>());

      appInfo.updateIntroductionRestart(
          json['IntroductionRestart'].cast<String, String>());

      appInfo.updatePositiveTraitsSuggestionsList(
          (json['positiveTraitsSuggestionsList'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, List<String>.from(value))));

      appInfo.updateHomePageInspirationalQuotes(
          (json['homePageInspirationalQuotes'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, List<String>.from(value))));

      appInfo.updatePhonePageTitles(
          (json['phonePageTitles'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, List<String>.from(value))));

      appInfo.updateLastUpdated(DateTime.now());
      appInfo.updateSharePDFtexts(json['sharePDFtexts'].cast<String, String>());
      appInfo.updateAboutPageText(json['aboutPageText'].cast<String, String>());
      appInfo.updateDisclaimerPageText(json['disclaimerPageText']);
      appInfo.updateDisclaimerPageNext(json['disclaimerPageNext']);

      Map<String, List<String>> wellnessVideos =
          (json['wellnessVideos'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, List<String>.from(value)));
      /*List<Map<String, String>> wellnessVideos = (json['welnessVideos'] as List)
          .map((item) => Map<String, String>.from(item))
          .toList();*/
      appInfo.updateWellnessVideos(wellnessVideos);
      appInfo.updateFormSkipButtonText(
          json['formSkipButtonText'].cast<String, String>());
      appInfo.updateFeelGoodPageTitles(
          json['feelGoodPageTitles'].cast<String, String>());
      appInfo.updateExtraMenuStrings(
          json['extraMenuStrings'].cast<String, String>());

      appInfo.updateSyncPages(json['syncPages'].cast<String, String>());

      return true;
    } catch (error, stackTrace) {
      IncidentLoggerService loggerService =
          GetIt.instance<IncidentLoggerService>();
      await loggerService.captureException(
        error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
  return false;
}

//upon adding CMS(rowy) texts, this will need to be updated:
//1. add the new variable to the appInfo class
//2. add the new variable to the createJson function
//3. add the new variable to the loadAppInfoFromJson function using update function created in appinfo class
//4. add the new variable to the loadAppFromFirebase function:
//4.1. add the new variable to the firestore query or isolate it after pulling all data
//4.2. add the new variable to the switch statement or get the specific item from the firestore query
//4.3. add the new variable to the map that will be used to update the appInfo class
//4.4. add the new variable to the appInfo.update function
Future<void> loadAppFromFirebase(
  AppInformation appInfo,
  checkboxCollectionNames,
  collections,
  checkboxModels,
) async {
  print('fetching app info from firebase');

  //InitialFormFirstPage
  Map<String, String> IFFP = {};
  //InitialFormSecondPage
  Map<String, String> IFSP = {};
  //InitialFormThirdPage
  Map<String, String> IFTP = {};
  //UserSettingsPage
  Map<String, String> userSettingsPage = {};
  //FormDifficultEvents
  Map<String, String> FPDE = {};
  //FormDistractions
  Map<String, String> FPD = {};
  //FormMakeSafer
  Map<String, String> FPMS = {};
  //FormFeelBetter
  Map<String, String> FPFB = {};
  //FormSharePage
  Map<String, String> FPSH = {};
  //FormPhonePage
  Map<String, String> FPPH = {};
  //PersonalPlanPage
  Map<String, String> PPP = {};
  //ExtraMenuStrings
  Map<String, String> EMS = {};
  //SignUpLoginPage
  Map<String, String> SULP = {};
  //AddFormStrings
  Map<String, String> AFS = {};
  //AddThanksFormStrings
  Map<String, String> ATFS = {};

  //AddFormPageTemplateStrings
  Map<String, String> AFPTS = {};

  //IntroductionRestart
  Map<String, String> IR = {};
  Map<String, String> PPMT = {};
  Map<String, String> PPST = {};
  Map<String, String> TMT = {};
  Map<String, String> TST = {};
  Map<String, String> JMT = {};
  Map<String, String> JST = {};
  Map<String, String> JPUT = {};
  Map<String, String> PPPU = {};
  Map<String, String> BT = {};
  Map<String, String> OS = {};
  var doc = await FirebaseFirestore.instance.collectionGroup('subgroup').get();
  doc.docs.forEach((element) {
    Map<String, dynamic> data = element.data();

    if (data.containsKey('page')) {
      switch (data['page']) {
        //add me here(if the name of the table in rowy ends with 'page')
        case 'SignupLogin':
          SULP['${data['fieldName']}-'] = data['general'];
          SULP['${data['fieldName']}-male'] = data['male'];
          SULP['${data['fieldName']}-female'] = data['female'];
          break;
        case 'UserSettings':
          userSettingsPage['${data['fieldName']}-'] = data['general'];
          userSettingsPage['${data['fieldName']}-male'] = data['male'];
          userSettingsPage['${data['fieldName']}-female'] = data['female'];
          break;
        case 'IntroductionFormFirstPage':
          IFFP['${data['fieldName']}-'] = data['general'];
          IFFP['${data['fieldName']}-male'] = data['male'];
          IFFP['${data['fieldName']}-female'] = data['female'];
          break;
        case 'IntroductionFormSecondPage':
          IFSP['${data['fieldName']}-'] = data['general'];
          IFSP['${data['fieldName']}-male'] = data['male'];
          IFSP['${data['fieldName']}-female'] = data['female'];
          break;
        case 'IntroductionFormLastPage':
          if (data['fieldName'] == 'mainTitle') {
            IFTP[data['fieldName']] = data['general'];
          } else {
            IFTP['${data['fieldName']}-'] = data['general'];
            IFTP['${data['fieldName']}-male'] = data['male'];
            IFTP['${data['fieldName']}-female'] = data['female'];
          }
          break;

        case 'DifficultEvents':
          switch (data['fieldName']) {
            case 'nextButton':
            case 'ShowMoreButton':
              FPDE[data['fieldName']] = data['general'];
              break;
            default:
              FPDE[data['fieldName']] = data['general'];
              FPDE['${data['fieldName']}female'] = data['female'];
              FPDE['${data['fieldName']}male'] = data['male'];
          }
          break;
        case 'Distractions':
          switch (data['fieldName']) {
            case 'nextButton':
            case 'ShowMoreButton':
              FPD[data['fieldName']] = data['general'];
              break;
            default:
              FPD[data['fieldName']] = data['general'];
              FPD['${data['fieldName']}female'] = data['female'];
              FPD['${data['fieldName']}male'] = data['male'];
          }
          break;
        case 'FeelBetter':
          switch (data['fieldName']) {
            case 'nextButton':
            case 'ShowMoreButton':
              FPFB[data['fieldName']] = data['general'];
              break;
            default:
              FPFB[data['fieldName']] = data['general'];
              FPFB['${data['fieldName']}female'] = data['female'];
              FPFB['${data['fieldName']}male'] = data['male'];
          }
          break;
        case 'MakeSafer':
          switch (data['fieldName']) {
            case 'nextButton':
            case 'ShowMoreButton':
              FPMS[data['fieldName']] = data['general'];
              break;
            default:
              FPMS[data['fieldName']] = data['general'];
              FPMS['${data['fieldName']}female'] = data['female'];
              FPMS['${data['fieldName']}male'] = data['male'];
          }
          break;

        case 'PhonesPage':
          FPPH[data['fieldName']] = data['general'];
          FPPH['${data['fieldName']}male'] = data['male'];
          FPPH['${data['fieldName']}female'] = data['female'];
          break;
        case 'PersonalPlanPage':
          PPP[data['fieldName']] = data['general'];
          PPP['${data['fieldName']}male'] = data['male'];
          PPP['${data['fieldName']}female'] = data['female'];
          break;
        case 'HomePage':
          switch (data['fieldName']) {
            case 'PersonalPlanMainTitle':
              PPMT['${data['fieldName']}-'] = data['general'];
              PPMT['${data['fieldName']}-male'] = data['male'];
              PPMT['${data['fieldName']}-female'] = data['female'];

              break;
            case 'PersonalPlanSecondaryTitle':
              PPST['${data['fieldName']}-'] = data['general'];
              PPST['${data['fieldName']}-male'] = data['male'];
              PPST['${data['fieldName']}-female'] = data['female'];

              break;
            case 'TraitsMainTitle':
              TMT['${data['fieldName']}-'] = data['general'];
              TMT['${data['fieldName']}-male'] = data['male'];
              TMT['${data['fieldName']}-female'] = data['female'];

              break;
            case 'TraitsSecondaryTitle':
              TST['${data['fieldName']}-'] = data['general'];
              TST['${data['fieldName']}-male'] = data['male'];
              TST['${data['fieldName']}-female'] = data['female'];

              break;
            case 'ThanksMainTitle':
              JMT['${data['fieldName']}-'] = data['general'];
              JMT['${data['fieldName']}-male'] = data['male'];
              JMT['${data['fieldName']}-female'] = data['female'];

              break;
            case 'ThanksSecondaryTitle':
              JST['${data['fieldName']}-'] = data['general'];
              JST['${data['fieldName']}-male'] = data['male'];
              JST['${data['fieldName']}-female'] = data['female'];

              break;
            case 'othersuggestions':
              OS['${data['fieldName']}-'] = data['general'];
              OS['${data['fieldName']}-male'] = data['male'];
              OS['${data['fieldName']}-female'] = data['female'];
            case 'thankyouPopup':
              JPUT['${data['fieldName']}-'] = data['general'];
              JPUT['${data['fieldName']}-male'] = data['male'];
              JPUT['${data['fieldName']}-female'] = data['female'];

              break;
            case 'PositiveTraitPopup':
              PPPU['${data['fieldName']}-'] = data['general'];
              PPPU['${data['fieldName']}-male'] = data['male'];
              PPPU['${data['fieldName']}-female'] = data['female'];

              break;
            case 'Back':
              BT['${data['fieldName']}-'] = data['general'];
              BT['${data['fieldName']}-male'] = data['male'];
              BT['${data['fieldName']}-female'] = data['female'];
              appInfo.updatePopupBack(BT);
            case 'Greetings':
              appInfo.homeTitleGreeting = data['general'];
              break;
            case 'Sync':
            case 'FeelGood':
            case 'WellnessTools':
            case 'About':
              EMS[data['fieldName']] = data['general'];

            default:
          }

          break;
        case 'SharePage':
          switch (data['fieldName']) {
            case 'emergencySendButtonText':
            case 'routineSendButtonText':
            case 'finishButton':
            case 'header':
              FPSH[data['fieldName']] = data['general'];
              break;
            default:
              FPSH[data['fieldName']] = data['general'];
              FPSH['${data['fieldName']}female'] = data['female'];
              FPSH['${data['fieldName']}male'] = data['male'];
          }

          break;
        case 'AddForm':
          AFS['${data['fieldName']}-'] = data['general'];
          AFS['${data['fieldName']}-male'] = data['male'];
          AFS['${data['fieldName']}-female'] = data['female'];
          break;
        case 'AddThanksForm':
          ATFS['${data['fieldName']}-'] = data['general'];
          ATFS['${data['fieldName']}-male'] = data['male'];
          ATFS['${data['fieldName']}-female'] = data['female'];
          break;

        case 'AddFormPageTemplate':
          AFPTS['${data['fieldName']}-'] = data['general'];
          AFPTS['${data['fieldName']}-male'] = data['male'];
          AFPTS['${data['fieldName']}-female'] = data['female'];
          break;
        case 'IntroductionRestart':
          IR['${data['fieldName']}-'] = data['general'];
          IR['${data['fieldName']}-male'] = data['male'];
          IR['${data['fieldName']}-female'] = data['female'];
          break;
        default:
      }
    }
  });

  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('VersionManager').get();

  for (var doc in snapshot.docs) {
    Map<String, dynamic> d = doc.data() as Map<String, dynamic>? ?? {};
    appInfo.updateAppVersion(d['version']);
  }

  appInfo.updateOtherSuggestions(OS);
  appInfo.updatePopupBack(BT);
  appInfo.updateTraitMainTitle(TMT);
  appInfo.updateJournalMainTitle(JMT);
  appInfo.updateTraitSubTitle(TST);
  appInfo.updateJournalSubTitle(JST);
  appInfo.updateJournalPopUpText(JPUT);
  appInfo.updatePositiveTraitsPopUpText(PPPU);
  appInfo.updatePersonalPlanMainTitle(PPMT);
  appInfo.updatePersonalPlanSubTitle(PPST);
  appInfo.updateIntroductionFormFirstPage(IFFP);
  appInfo.updateIntroductionFormSecondPage(IFSP);
  appInfo.updatePersonalInformationForm(userSettingsPage);
  appInfo.updateSignUpLoginPage(SULP);
  appInfo.updateIntroductionFormLastPage(IFTP);
  appInfo.updateFormDifficultEventsTitles(FPDE);
  appInfo.updateFormDistractionsTitles(FPD);
  appInfo.updateFormFeelBetterTitles(FPFB);
  appInfo.updateReturnToPlanStrings(PPP);
  appInfo.updateFormMakeSaferTitles(FPMS);
  appInfo.updateFormSharePageTitles(FPSH);
  appInfo.updateFormPhonePage(FPPH);
  appInfo.updateExtraMenuStrings(EMS);
  appInfo.updateAddFormStrings(AFS);
  appInfo.updateAddThanksFormStrings(ATFS);
  appInfo.updateAddFormPageTemplateStrings(AFPTS);
  appInfo.updateIntroductionRestart(IR);

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  for (String collectionName in checkboxCollectionNames) {
    String dbName = '${collectionName.split('-')[1]}-Sug';
    String appInfoName = '${collectionName.split('-')[1]}Sug';
    final doc = await FirebaseFirestore.instance.collection(dbName).get();
    List<String> collection = [];
    for (var doc in doc.docs) {
      collection.add(doc.get('content'));
    }
    switch (appInfoName) {
      case 'DifficultEventsSug':
        appInfo.updateDifficultEventsSug(collection);
        break;
      case 'DistractionsSug':
        appInfo.updateDistractionsSug(collection);
        break;
      case 'FeelBetterSug':
        appInfo.updateFeelBetterSug(collection);

        break;
      case 'MakeSaferSug':
        appInfo.updateMakeSaferSug(collection);

        break;
      default:
    }

    prefs.setStringList('databaseItems$collectionName', collection);
    collections.add(collection);
    // Create a CheckboxModel for each collection
    CheckboxModel model = CheckboxModel(
      collectionName,
      collectionName,
      '',
      '',
      '',
      '',
    );
    checkboxModels[collectionName] = model;
    // Load the values from the SharedPreferences
    List<String> addedStrings =
        prefs.getStringList('addedStrings$collectionName') ?? [];

    model.addItem(addedStrings);
    model.loadDatabaseItems(collection);
  }

  List<String> thanksSuggestionsList = await getThanksSuggestionsList();
  Map<String, List<String>> positiveTraitsSuggestionsList =
      await getPositiveTraitsSuggestionsList();
  Map<String, String> warningHomePageTitles = await getAllWarningData();
  Map<String, String> traitsHomePageTitles = await getAllTraitsData();
  Map<String, List<String>> homePageInspirationalQuotes =
      await getHomePageInspirationalQuotes();
  Map<String, String> shareMessages = await updateShareTexts();
  Map<String, List<String>> phonePageTitles = await updatePhonePageTitles();
  Map<String, String> sharePDFtext = await updateSharePDFtexts();
  Map<String, String> aboutPageText = await updateAboutPageText();
  Map<String, String> syncPages = await getSyncPages();
  Map<String, List<String>> wellnessVideos = await getWellnessVideos();
  List<String> disclaimerPageText = await getDisclaimerPageText();
  Map<String, String> formSkipButtonText =
      await getPersonalPlanSaveButtonText();
  Map<String, String> feelGoodPageTitles = await getFeelGoodPageTitles();
  //or add manually here using await and creating a function fetching a specific database item^

  appInfo.updateSyncPages(syncPages);
  appInfo.updateSharePDFtexts(sharePDFtext);
  appInfo.updateAboutPageText(aboutPageText);
  appInfo.updateWarningHomePageTitles(warningHomePageTitles);
  appInfo.updateTraitsHomePageTitles(traitsHomePageTitles);
  appInfo.updateHomePageInspirationalQuotes(homePageInspirationalQuotes);
  appInfo.updateShareMessages(shareMessages);
  appInfo.updateThanksSuggestionsList(thanksSuggestionsList);
  appInfo.updatePositiveTraitsSuggestionsList(positiveTraitsSuggestionsList);
  appInfo.updatePhonePageTitles(phonePageTitles);
  appInfo.updateWellnessVideos(wellnessVideos);
  appInfo.updateDisclaimerPageText(disclaimerPageText[0]);
  appInfo.updateDisclaimerPageNext(disclaimerPageText[1]);
  appInfo.updateFormSkipButtonText(formSkipButtonText);
  appInfo.updateFeelGoodPageTitles(feelGoodPageTitles);
  String json = jsonEncode(createJson(appInfo));
  // print(json);
  if (!kIsWeb) {
    Directory directory2 = await getApplicationDocumentsDirectory();
    File('${directory2.path}/data.json').writeAsString(json);
  }
}

Future<void> loadAppInformation(AppInformation appInfo, checkboxCollectionNames,
    collections, checkboxModels) async {
  try {
    if (!kIsWeb) {
      Directory directory = await getApplicationDocumentsDirectory();

      bool loaded = await loadAppInfoFromJson(
        appInfo,
        '${directory.path}/data.json',
        checkboxCollectionNames,
        collections,
        checkboxModels,
      );
      if (loaded) return;
    }
    await loadAppFromFirebase(
        appInfo, checkboxCollectionNames, collections, checkboxModels);
    return;
  } catch (error, stackTrace) {
    IncidentLoggerService loggerService =
        GetIt.instance<IncidentLoggerService>();
    await loggerService.captureException(
      error,
      stackTrace: stackTrace,
    );
    await loadAppFromFirebase(
        appInfo, checkboxCollectionNames, collections, checkboxModels);
    // setReady();
    return;
  }
}

Future<String> getJournalMainTitle() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('homePage-titles')
      .doc('zzzzzzzzzzzzzzzzzzzy')
      .get();
  return doc.get('mainTitles');
  //return (doc.data() as Map<String, dynamic>)['journalTitle'];
}

Future<String> getJournalSeocndaryTitle() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('homePage-titles')
      .doc('zzzzzzzzzzzzzzzzzzzy')
      .get();
  return doc.get('secondaryTitle');
  //return (doc.data() as Map<String, dynamic>)['journalTitle'];
}

Future<String> getTraitMainTitle() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('homePage-titles')
      .doc('zzzzzzzzzzzzzzzzzzzx')
      .get();
  return doc.get('mainTitles');
  //return (doc.data() as Map<String, dynamic>)['journalTitle'];
}

Future<Map<String, String>> getPersonalInfo() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('PersonalInformation-Form')
      .doc('zzzzzzzzzzzzzzzzzzzy')
      .get();
  return {
    "name": doc.get('name'),
    "gender": doc.get('gender'),
    "age": doc.get('age')
  };
  //return (doc.data() as Map<String, dynamic>)['journalTitle'];
}

Future<Map<String, String>> getIntroductionFormFirstPage() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('IntroductionForm_FirstPage')
      .doc('zzzzzzzzzzzzzzzzzzzy')
      .get();
  return {
    "mainTitle": doc.get('mainTitle'),
    "subTitle1": doc.get('subTitle1'),
    "subTitle2": doc.get('subTitle2')
  };
  //return (doc.data() as Map<String, dynamic>)['journalTitle'];
}

Future<Map<String, String>> getIntroductionFormSecondPage() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('IntroductionForm_SecondPage')
      .doc('zzzzzzzzzzzzzzzzzzzy')
      .get();
  return {
    "mainTitle": doc.get('mainTitle'),
    "subTitle": doc.get('subTitle'),
  };
  //return (doc.data() as Map<String, dynamic>)['journalTitle'];
}

Future<Map<String, String>> getIntroductionFormLastPage() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('IntroductionForm_LastPage')
      .doc('zzzzzzzzzzzzzzzzzzzy')
      .get();
  return {
    "mainTitle": doc.get('mainTitle'),
    "subTitle1-": doc.get('subTitle1'),
    "subTitle2-": doc.get('subTitle2'),
    "subTitle1-male": doc.get('subTitle1Male'),
    "subTitle2-male": doc.get('subTitle2Male'),
    "subTitle1-female": doc.get('subTitle1Female'),
    "subTitle2-female": doc.get('subTitle2Female'),
  };
  //return (doc.data() as Map<String, dynamic>)['journalTitle'];
}

Future<String> getTraitSeocndaryTitle() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('homePage-titles')
      .doc('zzzzzzzzzzzzzzzzzzzx')
      .get();
  return doc.get('secondaryTitle');
  //return (doc.data() as Map<String, dynamic>)['journalTitle'];
}

Future<Map<String, String>> getAllTraitsData() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('homePage-titles')
      .doc('zzzzzzzzzzzzzzzzzzzx')
      .get();
  return {
    'mainTitle': doc.get('mainTitles'),
    'secondaryTitle-': doc.get('secondaryTitle'),
    'secondaryTitle-male': doc.get('secondaryTitleMale'),
    'secondaryTitle-female': doc.get('secondaryTitleFemale')
  };
}

Future<Map<String, String>> getAllWarningData() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('homePage-titles')
      .doc('zzzzzzzzzzzzzzzzzzzw')
      .get();
  return {
    'mainTitle': doc.get('mainTitles'),
    'secondaryTitle-': doc.get('secondaryTitle'),
    'secondaryTitle-male': doc.get('secondaryTitleMale'),
    'secondaryTitle-female': doc.get('secondaryTitleFemale')
  };
}

Future<String> getPersonalPlanMainTitle() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('homePage-titles')
      .doc('zzzzzzzzzzzzzzzzzzzv')
      .get();
  return doc.get('mainTitles');
  //return (doc.data() as Map<String, dynamic>)['journalTitle'];
}

Future<String> getPersonalPlanSecondaryTitle() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('homePage-titles')
      .doc('zzzzzzzzzzzzzzzzzzzv')
      .get();
  return doc.get('secondaryTitle');
  //return (doc.data() as Map<String, dynamic>)['journalTitle'];
}

Future<Warning> fetchWarnings() async {
  final QuerySnapshot result =
      await FirebaseFirestore.instance.collection('warning-suggestions').get();
  final List<DocumentSnapshot> documents = result.docs;
  List<String> warnings =
      documents.map((doc) => doc.get('suggestions') as String).toList();
  var rng = new Random();
  var randomNumber = rng.nextInt(warnings.length);
  String text = warnings[randomNumber];
  return Warning(text: text, warnings: warnings);
}

Future<List<String>> getThanksSuggestionsList() async {
  CollectionReference thanksSuggestions =
      FirebaseFirestore.instance.collection('Thanks-suggestions');
  QuerySnapshot snapshot = await thanksSuggestions.get();
  List<String> suggestionsList = snapshot.docs
      .map((doc) => doc.get('suggestions'))
      .toList()
      .cast<String>();
  return suggestionsList;
}

Future<Map<String, List<String>>> getPositiveTraitsSuggestionsList() async {
  final doc = await FirebaseFirestore.instance
      .collection('positiveTraits-suggestions')
      .get();
  List<String> traits = [];
  List<String> traitsF = [];
  List<String> traitsM = [];
  for (var doc in doc.docs) {
    traits.add(doc.get('generalSuggestions'));
    traitsF.add(doc.get('femaleSuggestions'));
    traitsM.add(doc.get('maleSuggestions'));
  }

  return {"traits": traits, "traits-female": traitsF, "traits-male": traitsM};
}

Future<String> getMainTitle(bool male) async {
  String docIdMale = 'zzzzzzzzzzzzzzzzzzzy';
  String docIdFemale = 'zzzzzzzzzzzzzzzzzzzx';
  String docId = male ? docIdMale : docIdFemale;

  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('PhonePage-titles')
      .doc(docId)
      .get();
  return doc.get('mainTitle');
}

Future<String> getContactsTitle(bool male) async {
  String docIdMale = 'zzzzzzzzzzzzzzzzzzzy';
  String docIdFemale = 'zzzzzzzzzzzzzzzzzzzx';
  String docId = male ? docIdMale : docIdFemale;
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('PhonePage-titles')
      .doc(docId)
      .get();
  return doc.get('contactsTitle');
}

Future<String> getEmergancyTitle(bool male) async {
  String docIdMale = 'zzzzzzzzzzzzzzzzzzzy';
  String docIdFemale = 'zzzzzzzzzzzzzzzzzzzx';
  String docId = male ? docIdMale : docIdFemale;
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('PhonePage-titles')
      .doc(docId)
      .get();
  return doc.get('emergencyNumbersTitle');
}

Future<String> getJournalTitle() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('Journal-title')
      .doc('zzzzzzzzzzzzzzzzzzzy')
      .get();
  return doc.get('title');
  //return (doc.data() as Map<String, dynamic>)['journalTitle'];
}

Future<String> getAboutPageText() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('AboutPage-Text')
      .doc('zzzzzzzzzzzzzzzzzzzx')
      .get();
  return doc.get('aboutPageText');
}

Future<List<String>> getDisclaimerPageText() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('Disclaimer-Page-Text')
      .doc('zzzzzzzzzzzzzzzzzzzy')
      .get();

  return [doc.get('disclaimerText'), doc.get('next')];
}

Future<String> getGreetingString() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('homePage-strings')
      .doc('zzzzzzzzzzzzzzzzzzzy')
      .get();
  return doc.get('homePageGreeting');
}

Future<Map<String, String>> getReturnToPlan() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('PersonalPlan_FullPage')
      .doc('6kLyHj3X7tpOh6uQ0K6w')
      .get();

  return {
    "alreadyFilled": doc.get("alreadyFilled"),
    "didntFill": doc.get("didntFill")
  };
}

Future<String> getReminderMainTitle() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('homePage-titles')
      .doc('zzzzzzzzzzzzzzzzzzzu')
      .get();
  return doc.get('mainTitles');
  //return (doc.data() as Map<String, dynamic>)['journalTitle'];
}

Future<String> getReminderSeocndaryTitle() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('homePage-titles')
      .doc('zzzzzzzzzzzzzzzzzzzu')
      .get();
  return doc.get('secondaryTitle');
  //return (doc.data() as Map<String, dynamic>)['journalTitle'];
}

Future<String> getJournalPopUpText() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('Popups-texts')
      .doc('zzzzzzzzzzzzzzzzzzzy')
      .get();
  return doc.get('thankYouPopupText');
}

Future<String> getPositiveTraitsPopUpText() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('Popups-texts')
      .doc('zzzzzzzzzzzzzzzzzzzy')
      .get();
  return doc.get('thankYouPopupText');
}

Future<Map<String, String>> getPersonalPlanSaveButtonText() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('PersonalPlan_SaveButton')
      .doc('zzzzzzzzzzzzzzzzzzzy')
      .get();
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  String femaleText = data['female'];
  String maleText = data['male'];
  String generalText = data['general'];

  return {
    'female': femaleText,
    'male': maleText,
    'general': generalText,
  };
}

Future<Map<String, List<String>>> getHomePageInspirationalQuotes() async {
  final doc = await FirebaseFirestore.instance
      .collection('HomePage-InspirationalQuotes')
      .get();
  List<String> quotes = [];
  List<String> quotesF = [];
  List<String> quotesM = [];
  for (var doc in doc.docs) {
    quotes.add(doc.get('quotes'));
    quotesF.add(doc.get('quotesFemale'));
    quotesM.add(doc.get('quotesMale'));
  }

  return {"quotes-": quotes, "quotes-female": quotesF, "quotes-male": quotesM};
}

Future<List<String>> updateTest1() async {
  final doc2 = await FirebaseFirestore.instance
      .collection('HomePage-InspirationalQuotes')
      .doc('zzzzzzzzzzzzzzzzzzzu')
      .get();
  String a = doc2.get("quotes");

  return [a];
}

Future<Map<String, String>> updateShareTexts() async {
  final doc2 = await FirebaseFirestore.instance
      .collection('ShareTexts')
      .doc('zzzzzzzzzzzzzzzzzzzy')
      .get();

  return {"emergency": doc2.get("emergency"), "regular": doc2.get("regular")};
}

Future<Map<String, String>> getFeelGoodPageTitles() async {
  final doc2 = await FirebaseFirestore.instance
      .collection('feelGoodPageTitles')
      .doc('zzzzzzzzzzzzzzzzzzzy')
      .get();

  final data = doc2.data() as Map<String, dynamic>;

  return {
    "header": data["header"],
    "subHeader": data["subHeader"],
    "alertButtonTitle": data["alertButtonTitle"],
    "addImgButtonText": data["addImgButtonText"],
    "cameraButtonText": data["cameraButtonText"],
    "cancelDeleteButtonText": data["cancelDeleteButtonText"],
    "deleteButtonText": data["deleteButtonText"],
    "galleryButtonText": data["galleryButtonText"],
  };
}

Future<Map<String, String>> updatePhoneFormTitles() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('PersonalPlan-PhonesPage')
      .get();
  if (snapshot.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }
  final snapshot2 =
      await FirebaseFirestore.instance.collection('FormPage-PhonesPage').get();

  if (snapshot.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }
  if (snapshot2.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }
  Map<String, String> result = {};
  for (var doc in snapshot2.docs) {
    result[doc.data()['fieldName']] = doc.data()['general'];
    result[doc.data()['fieldName'] + 'female'] = doc.data()['female'];
    result[doc.data()['fieldName'] + 'male'] = doc.data()['male'];
  }

  return result;
}

Future<Map<String, List<String>>> updatePhonePageTitles() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('PhonePage-titles').get();
  if (snapshot.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }

  Map<String, dynamic> data = snapshot.docs[0].data();
  Map<String, dynamic> data2 = snapshot.docs[1].data();
  Map<String, dynamic> data3 = snapshot.docs[2].data();
  return {
    'mainTitle': [data2['mainTitle'] as String],
    'mainTitleFemale': [data['mainTitle'] as String],
    'mainTitleGeneral': [data3['mainTitle'] as String],
    'contactsTitle': [data2['contactsTitle'] as String],
    'contactsTitleFemale': [data['contactsTitle'] as String],
    'contactsTitleGeneral': [data3['contactsTitle'] as String],
    'emergencyNumbersTitle': [data2['emergencyNumbersTitle'] as String],
    'emergencyNumbersTitleFemale': [data['emergencyNumbersTitle'] as String],
    'emergencyNumbersTitleGeneral': [data3['emergencyNumbersTitle'] as String],
    'emergencyPhones': [
      snapshot.docs[0]['emergencyPhones'] as String,
      snapshot.docs[1]['emergencyPhones'] as String,
      snapshot.docs[2]['emergencyPhones'] as String,
      snapshot.docs[3]['emergencyPhones'] as String,
    ],
    'phoneName': [
      snapshot.docs[0]['phoneName'] as String,
      snapshot.docs[1]['phoneName'] as String,
      snapshot.docs[2]['phoneName'] as String,
      snapshot.docs[3]['phoneName'] as String,
    ],
    'phoneDescription': [
      snapshot.docs[0]['phoneDescription'] as String,
      snapshot.docs[1]['phoneDescription'] as String,
      snapshot.docs[2]['phoneDescription'] as String,
      snapshot.docs[3]['phoneDescription'] as String,
    ],
    'emergencyDialogChooseTitle': [
      snapshot.docs[0]['emergencyDialogChooseTitle'] as String,
      snapshot.docs[1]['emergencyDialogChooseTitle'] as String,
      snapshot.docs[2]['emergencyDialogChooseTitle'] as String,
      snapshot.docs[3]['emergencyDialogChooseTitle'] as String,
    ],
    'emergencyDialogChooseTitleFemale': [
      snapshot.docs[0]['emergencyDialogChooseTitleFemale'] as String,
      snapshot.docs[1]['emergencyDialogChooseTitleFemale'] as String,
      snapshot.docs[2]['emergencyDialogChooseTitleFemale'] as String,
      snapshot.docs[3]['emergencyDialogChooseTitleFemale'] as String,
    ],
    'emergencyDialogChooseTitleGeneral': [
      snapshot.docs[0]['emergencyDialogChooseTitleGeneral'] as String,
      snapshot.docs[1]['emergencyDialogChooseTitleGeneral'] as String,
      snapshot.docs[2]['emergencyDialogChooseTitleGeneral'] as String,
      snapshot.docs[3]['emergencyDialogChooseTitleGeneral'] as String,
    ],
    'emergencyDialogWhatsapp': [
      snapshot.docs[0]['emergencyDialogWhatsapp'] as String,
      snapshot.docs[1]['emergencyDialogWhatsapp'] as String,
      snapshot.docs[2]['emergencyDialogWhatsapp'] as String,
      snapshot.docs[3]['emergencyDialogWhatsapp'] as String,
    ],
    'emergencyDialogDial': [
      snapshot.docs[0]['emergencyDialogDial'] as String,
      snapshot.docs[1]['emergencyDialogDial'] as String,
      snapshot.docs[2]['emergencyDialogDial'] as String,
      snapshot.docs[3]['emergencyDialogDial'] as String,
    ],
    'emergencyDialogWebsite': [
      snapshot.docs[0]['emergencyDialogWebsite'] as String,
      snapshot.docs[1]['emergencyDialogWebsite'] as String,
      snapshot.docs[2]['emergencyDialogWebsite'] as String,
      snapshot.docs[3]['emergencyDialogWebsite'] as String,
    ],
    'emergencyDialogBack': [
      snapshot.docs[0]['emergencyDialogBack'] as String,
      snapshot.docs[1]['emergencyDialogBack'] as String,
      snapshot.docs[2]['emergencyDialogBack'] as String,
      snapshot.docs[3]['emergencyDialogBack'] as String,
    ],
    'emergencyDialogWebsiteTitle': [
      snapshot.docs[0]['emergencyDialogWebsiteTitle'] as String,
      snapshot.docs[1]['emergencyDialogWebsiteTitle'] as String,
      snapshot.docs[2]['emergencyDialogWebsiteTitle'] as String,
      snapshot.docs[3]['emergencyDialogWebsiteTitle'] as String,
    ],
  };
}

Future<Map<String, String>> updateFormDifficultEventsTitles() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('PersonalPlan-DifficultEvents')
      .get();

  final snapshot2 = await FirebaseFirestore.instance
      .collection('FormPage-DifficultEvents')
      .get();

  if (snapshot.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }
  if (snapshot2.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }
  Map<String, String> result = {};
  for (var doc in snapshot2.docs) {
    result[doc.data()['fieldName']] = doc.data()['general'];
    result[doc.data()['fieldName'] + 'female'] = doc.data()['female'];
    result[doc.data()['fieldName'] + 'male'] = doc.data()['male'];
  }

  return result;
}

Future<Map<String, String>> updateFormDistractionsTitles() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('PersonalPlan-Distractions')
      .get();
  if (snapshot.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }
  final snapshot2 = await FirebaseFirestore.instance
      .collection('FormPage-Distractions')
      .get();

  if (snapshot.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }
  if (snapshot2.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }
  Map<String, String> result = {};
  for (var doc in snapshot2.docs) {
    result[doc.data()['fieldName']] = doc.data()['general'];
    result[doc.data()['fieldName'] + 'female'] = doc.data()['female'];
    result[doc.data()['fieldName'] + 'male'] = doc.data()['male'];
  }

  return result;
}

Future<Map<String, String>> updateFormFeelBetterTitles() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('PersonalPlan-FeelBetter')
      .get();
  if (snapshot.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }
  final snapshot2 =
      await FirebaseFirestore.instance.collection('FormPage-FeelBetter').get();

  if (snapshot.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }
  if (snapshot2.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }
  Map<String, String> result = {};
  for (var doc in snapshot2.docs) {
    result[doc.data()['fieldName']] = doc.data()['general'];
    result[doc.data()['fieldName'] + 'female'] = doc.data()['female'];
    result[doc.data()['fieldName'] + 'male'] = doc.data()['male'];
  }
  return result;
}

Future<Map<String, String>> updateFormMakeSaferTitles() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('PersonalPlan-MakeSafer')
      .get();
  final snapshot2 =
      await FirebaseFirestore.instance.collection('FormPage-MakeSafer').get();

  if (snapshot.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }
  if (snapshot2.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }
  Map<String, String> result = {};
  for (var doc in snapshot2.docs) {
    result[doc.data()['fieldName']] = doc.data()['general'];
    result[doc.data()['fieldName'] + 'female'] = doc.data()['female'];
    result[doc.data()['fieldName'] + 'male'] = doc.data()['male'];
  }
  return result;
}

Future<Map<String, String>> updateFormSharePageTitles() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('PersonalPlan-SharePage')
      .get();
  if (snapshot.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }

  Map<String, dynamic> data = snapshot.docs[0].data();
  return {
    'header': data['header'] as String,
    'headerFemale': data['headerFemale'] as String,
    'subTitle': data['subTitle'] as String,
    'subTitleFemale': data['subTitleFemale'] as String,
    'midTitle': data['midTitle'] as String,
    'midTitleFemale': data['midTitleFemale'] as String,
    'finishButton': data['finishButton'] as String,
    'shareTitle': data['shareTitle'] as String,
    'shareTitleFemale': data['shareTitleFemale'] as String,
    'emergencySendButtonText': data['emergencySendButtonText'] as String,
    'routineSendButtonText': data['routineSendButtonText'] as String,
  };
}

Future<List<String>> updatePhonePersonalPlanText() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Phone-PersonalPlanText')
      .get();
  final snapshot2 =
      await FirebaseFirestore.instance.collection('FormPage-MakeSafer').get();

  if (snapshot.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }
  if (snapshot2.docs.isEmpty) {
    throw Exception('No documents found in collection');
  }

  List<String> data = [];
  for (var doc in snapshot.docs) {
    data.add(doc.data()['data']);
  }
  return data;
}

Future<Map<String, String>> updateSharePDFtexts() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('SharePDFtexts').get();
  Map<String, String> value = {};

  for (var i = 0; i < snapshot.docs.length; i++) {
    value[snapshot.docs[i].get('fieldName')] =
        snapshot.docs[i].get('content') as String;
  }

  return value;
}

Future<Map<String, String>> updateAboutPageText() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('AboutPage-Text').get();
  Map<String, String> value = {};
  value['englishText'] = snapshot.docs[0].get('aboutPageText') as String;
  value['aboutPageTitle1'] =
      snapshot.docs[1].get('aboutPageTextTitle') as String;
  value['aboutPageText1'] = snapshot.docs[1].get('aboutPageText') as String;
  value['aboutPageTitle2'] =
      snapshot.docs[2].get('aboutPageTextTitle') as String;
  value['aboutPageText2'] = snapshot.docs[2].get('aboutPageText') as String;

  return value;
}

Future<Map<String, List<String>>> getWellnessVideos() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('Wellness-Videos').get();
  Map<String, List<String>> data = {
    'videoId': [],
    'videoHeadline': [],
    'videoDescription': [],
  };

  for (var i = 0; i < snapshot.docs.length; i++) {
    data['videoId']?.add(snapshot.docs[i].get('videoId'));
    data['videoHeadline']?.add(snapshot.docs[i].get('videoHeadline'));
    data['videoDescription']?.add(snapshot.docs[i].get('videoDescription'));
  }
  return data;
}

Future<Map<String, String>> getSyncPages() async {
  Map<String, String> data = {};
  final snapshot =
      await FirebaseFirestore.instance.collection('SyncPages').get();

  for (var doc in snapshot.docs) {
    data[doc.data()['fieldName']] = doc.data()['general'];
    data[doc.data()['fieldName'] + 'female'] = doc.data()['female'];
    data[doc.data()['fieldName'] + 'male'] = doc.data()['male'];
  }
  return data;
}
