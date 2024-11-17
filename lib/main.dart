import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/iFx/service_locator.dart';
import 'package:mazilon/pages/notifications/notification_service.dart';
import 'package:mazilon/util/logger_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'util/Firebase/firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/pages/SignIn_Pages/introduction.dart';

import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/Firebase/firebase_functions.dart';
import 'package:mazilon/util/Form/checkbox_model.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:mazilon/initialForm/form.dart';

//testing:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazilon/disclaimerPage.dart';
import 'package:mazilon/pages/SignIn_Pages/firstPage.dart';
import 'package:firebase_database/firebase_database.dart';

List<String> checkboxCollectionNames = [
  'PersonalPlan-DifficultEvents',
  'PersonalPlan-MakeSafer',
  'PersonalPlan-FeelBetter',
  'PersonalPlan-Distractions',
  // Add the new table name
];

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (inputData == null ||
          !inputData.containsKey("text") ||
          !inputData.containsKey("timeHour") ||
          !inputData.containsKey("timeMinute") ||
          !inputData.containsKey("id")) {
        throw ArgumentError("Invalid input data for notification");
      }
      int number = Random().nextInt(inputData["text"].length);
      await NotificationsService.init();
      await NotificationsService.cancelNotifications(null);
      TimeOfDay calculatedTime = NotificationsService.calculateTime(
          inputData["timeHour"],
          inputData["timeMinute"]); // Calculate the time for the notification

      NotificationsService.scheduleNotification(
          calculatedTime, inputData["id"], inputData["text"][number]);
      return Future.value(true);
    } catch (error, stackTrace) {
      IncidentLoggerService loggerService =
          GetIt.instance<IncidentLoggerService>();
      await loggerService.captureException(error,
          stackTrace: stackTrace,
          exceptionData: {'name': 'inputData', 'value': inputData});
    }
    return Future.value(false);
  });
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();
  //REMOVE COMMENT ON FUTURE UPDATES FOR SYNC DEVICE FUNCTIONALITY
  // Initialize the second Firebase app for dbUsers
}

void main() async {
  await initializeApp();
  IncidentLoggerService sentryService = GetIt.instance<IncidentLoggerService>();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
  await sentryService.initializeSentry(
    MultiProvider(
      providers: [
        for (int i = 0; i < checkboxCollectionNames.length; i++)
          // Initialize the checkbox models
          ChangeNotifierProvider(
            create: (context) => CheckboxModel(checkboxCollectionNames[i],
                checkboxCollectionNames[i], "", "", "", ""),
          ),
        // Initialize the phonePageData provider
        ChangeNotifierProvider(
          create: (context) => PhonePageData(
              key: "PhonePage",
              phoneNames: [],
              phoneNumbers: [],
              header: "", // Blank for unknown field
              subTitle: "", // Blank for unknown field
              midTitle: "", // Blank for unknown field
              phoneNameTitle: "", // Blank for unknown field
              phoneNumberTitle: "", // Blank for unknown field
              savedPhoneNames: [], // Assuming empty list for unknown
              savedPhoneNumbers: [], // Assuming empty list for unknown
              phoneDescription: [] // Assuming empty list for unknown
              )
            ..loadItemsFromPrefs(), // Initialize phonePageData
        ),
        //REMOVE COMMENT ON FUTURE UPDATES FOR SYNC DEVICE FUNCTIONALITY
        // Initialize the FirebaseAppProvider for dbUsersApp-REALTIME DB

        // Initialize the APP information provider
        ChangeNotifierProvider(create: (context) => AppInformation()),
        // Initialize the User information provider
        ChangeNotifierProvider(create: (context) => UserInformation()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, CheckboxModel> checkboxModels = {};
  bool firsttime = false;

  List<List<String>> collections = [];
  bool _isInitialized = false;
  // adding checkboxmodel for the form add here:

  List<String> phonePageCollectionNames = [
    'PersonalPlan-PhonesPage',
  ];
  List<String> textCollectionNames = [];
  late Map<String, dynamic>
      personalPlanPhonesPageData; // Store the new table data
  late PhonePageData phonePageData;
  late Future<void> loadCollectionsFuture;
  late Future<Widget> futureWidget;
  List<String> homeTitles = [];

  AppInformation appInfo = AppInformation();

  bool hasFilled = false;
  void getHasFilled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      hasFilled = prefs.getBool('hasFilled') ?? false;
    });
  }

  void loadFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      firsttime = prefs.getBool('firstTime') ?? true;
    });
  }

  @override
  void initState() {
    getHasFilled();
    loadFirstTime();
    super.initState();
    personalPlanPhonesPageData = {
      'phoneName': <String>[],
      'emergencyPhones': <String>[],
      'phoneDescription': <String>[]
    }; // Initialize personalPlanPhonesPageData
  }

  @override
  void didChangeDependencies() {
    if (!_isInitialized) {
      phonePageData = Provider.of<PhonePageData>(context);
      _isInitialized = true;
    }
    super.didChangeDependencies();
  }

  void confirmDisclaimer(mycontext) {
    Navigator.pushAndRemoveUntil(
      mycontext,
      MaterialPageRoute(
          builder: (context) => InitialFormProgressIndicator(
                collections: collections,
                collectionNames: checkboxCollectionNames,
                checkboxModels: checkboxModels,
                phonePageData: phonePageData,
              )),
      (Route<dynamic> route) => false,
    );
  }

  ValueNotifier<Widget?> widgetNotifier = ValueNotifier<Widget?>(null);

  //app start this runs:
  @override
  Widget build(BuildContext context) {
    final appInfoProvider = Provider.of<AppInformation>(context, listen: false);
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);

    if (widgetNotifier.value == null) {
      Future.wait([
        //load from DB or from json:
        loadAppInformation(appInfoProvider, checkboxCollectionNames,
            collections, checkboxModels),
        loadUserInformation(userInfoProvider),
      ]).then((_) {
        //initialize which widget will run first:
        widgetNotifier.value = phonePageData != null
            //user filled data:
            ? FirstPage(
                collections: collections,
                collectionNames: checkboxCollectionNames,
                checkboxModels: checkboxModels,
                firsttime: firsttime,
                hasFilled: hasFilled,
                phonePageData: phonePageData)
            //first login:
            : const Center(child: Introduction());
      });
    }
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: ValueListenableBuilder<Widget?>(
            valueListenable: widgetNotifier,
            builder: (context, widget, child) {
              //widget running on success or intro in first login:
              return widget ?? const Center(child: Introduction());
            },
          ),
        ),
      ),
    );
  }
}
