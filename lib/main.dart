import 'dart:math';
import 'package:mazilon/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/Locale/locale_service.dart';
import 'package:mazilon/iFx/service_locator.dart';
import 'package:mazilon/AnalyticsService.dart';
import 'package:mazilon/pages/notifications/notification_service.dart';
import 'package:mazilon/util/logger_service.dart';
import 'package:mazilon/util/persistent_memory_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'util/Firebase/firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import '/pages/SignIn_Pages/introduction.dart';
import 'package:workmanager/workmanager.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/Firebase/firebase_functions.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:upgrader/upgrader.dart';
import 'package:mazilon/util/LP_extended_state.dart';
//testing:
import 'package:mazilon/pages/SignIn_Pages/firstPage.dart';

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
      await NotificationsService.cancelNotifications(null, cancelWorker: false);
      TimeOfDay calculatedTime = NotificationsService.calculateTime(
          inputData["timeHour"],
          inputData["timeMinute"]); // Calculate the time for the notification

      NotificationsService.scheduleNotification(
          calculatedTime, inputData["id"], inputData["text"][number]);

      return Future.value(true);
    } catch (error, stackTrace) {
      IncidentLoggerService loggerService =
          GetIt.instance<IncidentLoggerService>();
      await loggerService.captureLog(error,
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late Mixpanel mixpanel;
  bool enteredBefore = true;
  String localeName = '';
  bool _initializationStarted = false; // Add this flag

  bool _isInitialized = false;
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
  DateTime? _startTime;
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _endSession(); // Ensure session ends when widget is disposed
    super.dispose();
  }

  void _startSession() {
    AnalyticsService mixPanelService = GetIt.instance<AnalyticsService>();
    mixPanelService.trackEvent("Session started");
    _startTime = DateTime.now(); // Store session start time
  }

  void _endSession() {
    if (_startTime == null) return;

    final endTime = DateTime.now();
    final duration =
        endTime.difference(_startTime!).inSeconds; // Calculate session length
    print("duration: " + duration.toString());
    AnalyticsService mixPanelService = GetIt.instance<AnalyticsService>();
    mixPanelService.trackEvent("Session Ended", {
      "duration_seconds": duration,
    });

    _startTime = null; // Reset for next session
  }

  void _pauseSession() {
    if (_startTime == null) return;

    final endTime = DateTime.now();
    final duration =
        endTime.difference(_startTime!).inSeconds; // Calculate session length

    AnalyticsService mixPanelService = GetIt.instance<AnalyticsService>();
    mixPanelService.trackEvent("Session Paused", {
      "duration_seconds": duration,
    });

    _startTime = null; // Reset for next session
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startSession(); // App is active
    } else if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      _endSession(); // App is inactive or closed
    }
  }

  void getHasFilled() async {
    try {
      PersistentMemoryService service = GetIt.instance<
          PersistentMemoryService>(); // Get the persistent memory service instance

      await service.setItem("disclaimerConfirmed", "bool", true);
      var hasFilledValue = await service.getItem("hasFilled", "bool") ?? false;
      setState(() {
        hasFilled = hasFilledValue;
      });
    } catch (e) {
      print('Error in getHasFilled: $e');
      // Set default value on error
      setState(() {
        hasFilled = false;
      });
    }
  }

  Future<void> setLocale() async {
    print('setLocale() called');
    try {
      LocaleService localeService = GetIt.instance<LocaleService>();

      PersistentMemoryService service = GetIt.instance<
          PersistentMemoryService>(); // Get the persistent memory service instance
      await service.setItem("disclaimerConfirmed", "bool", true);
      String? prefsLocale = await service.getItem('localeName', 'String');

      print('prefsLocale from service: $prefsLocale');

      setState(() {
        localeService.setLocale(prefsLocale != "" ? prefsLocale! : 'en');
        localeName = localeService.getLocale();
        print('localeName set to: $localeName');
      });
    } catch (e) {
      print('Error in setLocale: $e');
      // Set default locale on error
      LocaleService localeService = GetIt.instance<LocaleService>();
      setState(() {
        localeService.setLocale('en');
        localeName = 'en';
        print('localeName set to default: en');
      });
    }
  }

  void loadFirstTime() async {
    try {
      PersistentMemoryService service = GetIt.instance<
          PersistentMemoryService>(); // Get the persistent memory service instance

      var enteredBeforeValue =
          await service.getItem('enteredBefore', 'bool') ?? true;

      setState(() {
        enteredBefore = enteredBeforeValue;
      });
    } catch (e) {
      print('Error in load enteredBeforeValue: $e');
      // Set default value on error
      setState(() {
        enteredBefore = false;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    AnalyticsService mixPanelService = GetIt.instance<AnalyticsService>();
    mixPanelService.init();
    getHasFilled();
    loadFirstTime();
    super.initState();
    _startSession();
    //initMixpanel();
    personalPlanPhonesPageData = {
      'phoneName': <String>[],
      'emergencyPhones': <String>[],
      'phoneDescription': <String>[]
    }; // Initialize personalPlanPhonesPageData
  }

  Future<void> initMixpanel() async {
    // Once you've called this method once, you can access `mixpanel` throughout the rest of your application.
    mixpanel = await Mixpanel.init("e38d39b73bc076129d0a5390af41fc24",
        trackAutomaticEvents: false);
  }

  @override
  void didChangeDependencies() {
    if (!_isInitialized) {
      phonePageData = Provider.of<PhonePageData>(context);
      _isInitialized = true;
    }
    super.didChangeDependencies();
  }

  void changeLocale(String locale) {
    LocaleService localeService = GetIt.instance<LocaleService>();
    setState(() {
      localeService.setLocale(locale);
    });
  }

  ValueNotifier<Widget?> widgetNotifier = ValueNotifier<Widget?>(null);

  //app start this runs:
  @override
  Widget build(BuildContext context) {
    LocaleService localeService = GetIt.instance<LocaleService>();
    final appInfoProvider = Provider.of<AppInformation>(context, listen: false);
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);

    if (widgetNotifier.value == null && !_initializationStarted) {
      _initializationStarted = true; // Prevent multiple initialization attempts
      print('Starting app initialization...');
      Future.wait([
        //load from DB or from json:
        loadAppInformation(appInfoProvider),
        loadUserInformation(userInfoProvider, localeService.getLocale()),
        setLocale()
      ]).then((_) {
        print('App initialization completed successfully');
        print(
            'firsttime: $enteredBefore, hasFilled: $hasFilled, localeName: $localeName');

        //initialize which widget will run first:
        widgetNotifier.value = FirstPage(
            firsttime: !enteredBefore,
            hasFilled: hasFilled,
            changeLocale: changeLocale,
            phonePageData: phonePageData);
        print('Widget set to FirstPage');
      }).catchError((error, stackTrace) {
        // Handle errors and provide a fallback widget
        print('Error loading app data: $error');
        IncidentLoggerService loggerService =
            GetIt.instance<IncidentLoggerService>();
        loggerService.captureLog(error, stackTrace: stackTrace);

        // Fallback to Introduction page on error
        widgetNotifier.value = const Center(child: Introduction());
        print('Widget set to Introduction due to error');
      });
    }

    print(
        'Build called - localeName: $localeName, widgetNotifier.value: ${widgetNotifier.value}');

    if (localeName == '') {
      print('Showing loading indicator');
      return const Center(child: CircularProgressIndicator());
    }

    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (context, child) => MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale(localeService.getLocale()),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        home: UpgradeAlert(
          child: Scaffold(
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
      ),
    );
  }
}
