//import 'package:mazilon/initialForm/toFormPage.dart';
//import 'package:mazilon/menu.dart';
//import 'package:mazilon/util/myTextButton.dart';
//import 'package:mazilon/util/Reminders/reminder.dart';
//import 'package:mazilon/MainPageHelpers/reminderWidget.dart';
//import 'package:mazilon/depricated/Warning/warningSignsWidget.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mazilon/pages/UserSettings.dart';
import 'package:mazilon/MainPageHelpers/personalPlanWidget.dart';
import 'package:mazilon/MainPageHelpers/traitListWidget.dart';
import 'package:mazilon/MainPageHelpers/thanksListWidget.dart';
import 'package:mazilon/util/HomePage/inspirationalQuote.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Form/checkbox_model.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:mazilon/util/HomePage/NameBar.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/Thanks/AddForm.dart';

import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';

//the main page of the app
//allows navigation to all other pages
class Home extends StatefulWidget {
  final List<List<String>> collections;
  final List<String> collectionNames;
  final Map<String, CheckboxModel> checkboxModels;
  PhonePageData phonePageData;
  final Function(int) changeCurrentIndex;

  Home({
    super.key,
    required this.collections,
    required this.collectionNames,
    required this.checkboxModels,
    required this.phonePageData,
    required this.changeCurrentIndex,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String greetingString = '';
  String fileButtonString = '';

  List<String> traits = [];
  List<String> thankYous = [];
  List<String> todayThankYous = [];
  int thankYousCounter = 0;
  List<String> thankYouDates = [];
  List<String> positiveTraits = [];
  List<String> threeLatestTraits = [];
  List<String> positiveDates = [];

  bool hasFilled = false;
  Map<String, dynamic> homeTitles = {};

//function to get the three latest traits
  List<String> threeLatestTraitsFunc(List<String> traits) {
    List<String> threeLatestTraits = [];
    if (traits.length <= 3) {
      threeLatestTraits = traits;
    } else {
      for (int i = traits.length - 3; i < traits.length; i++) {
        threeLatestTraits.add(traits[i]);
      }
    }
    return threeLatestTraits;
  }

//function to get the thank yous of today
  List<String> todayThankYousFunc(List<String> thankYous, List<String> dates) {
    List<String> todayThankYous = [];
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    for (int i = 0; i < dates.length; i++) {
      if (dates[i].substring(0, 10) == formattedDate.substring(0, 10)) {
        todayThankYous.add(thankYous[i]);
      }
    }

    return todayThankYous;
  }

//pop up to show after adding a thank you item
// it triggers only after the first one each day
  void showThankYouPopup() {
    Future.delayed(const Duration(seconds: 0), () {
      final appInfoProvider =
          Provider.of<AppInformation>(context, listen: false);
      final userInfoProvider =
          Provider.of<UserInformation>(context, listen: false);
      final gender = userInfoProvider.gender;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(''),
            content: Text(
              appInfoProvider.journalPopUpText['thankyouPopup-' + gender] ?? '',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15.sp),
              textAlign: TextAlign.center,
            ),
            //  ' כל הכבוד 😊 זאת הדרך לחזק את שריר האושר החיובי שלך. ההמלצה היא כל יום להודות לפחות על 5 דברים בחיים שלך. יישר כוח וניפגש שוב מחר 💜'),
            actions: <Widget>[
              TextButton(
                child:
                    Text(appInfoProvider.popupBack['popupBack' + gender] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        )),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

//load information about the user from shared preferences
  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      thankYous = prefs.getStringList('thankYous') ?? [];
      positiveTraits = prefs.getStringList('positiveTraits') ?? [];
      hasFilled = prefs.getBool('hasFilled') ?? false;

      thankYouDates = prefs.getStringList('dates') ?? [];
      todayThankYous = todayThankYousFunc(thankYous, thankYouDates);
      threeLatestTraits = threeLatestTraitsFunc(positiveTraits);
    });
  }

//function to update the user information(name,age,gender) in shared preferences
  void updateUsername(newName, newGender, newAge) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('binary', newGender == 'לא בינארי');
    prefs.setString('name', newName);
    if (newGender != '') {
      prefs.setString('gender', newGender);
    }
    if (newAge != '') {
      prefs.setString('age', newAge);
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

//function that adds a thank you to prefs and changes the state
  void addThankYou(
    String thankYou,
  ) async {
    thankYousCounter =
        thankYousCounter < 6 ? thankYousCounter + 1 : thankYousCounter;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> thankYous_temp = prefs.getStringList('thankYous') ?? [];
    List<String> dates_temp = prefs.getStringList('dates') ?? [];

    thankYous_temp.add(thankYou);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    dates_temp.add(formattedDate);

    setState(() {
      prefs.setStringList('thankYous', thankYous_temp);
      thankYous = thankYous_temp;

      prefs.setStringList('dates', dates_temp);
      thankYouDates = dates_temp;
      todayThankYous = todayThankYousFunc(thankYous, thankYouDates);
    });
    if (thankYousCounter == 1) {
      showThankYouPopup();
    }
  }

//function to change a thank you
  void changeThankYou(String text, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      thankYous[index] = text;
      prefs.setStringList('thankYous', thankYous);
      todayThankYous = todayThankYousFunc(thankYous, thankYouDates);
    });
  }

//fuction to show the add form for a thank you
  void addThanksNotification() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddForm(
              add: addThankYou,
              index: 0,
              edit: changeThankYou,
              text: '',
              formTitle: 'תודה');
        });
  }

//fuction to show the edit form for a thank you
  void editThanksNotification(String text, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddForm(
              add: addThankYou,
              index: index,
              edit: changeThankYou,
              text: text,
              formTitle: 'תודה');
        });
  }

//fuction to handle the removal of a thank you
  void removeThankYou(int removeIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> thankYous_temp = prefs.getStringList('thankYous') ?? [];
    List<String> dates_temp = prefs.getStringList('dates') ?? [];

    thankYous_temp.removeAt(removeIndex);
    dates_temp.removeAt(removeIndex);
    setState(() {
      prefs.setStringList('thankYous', thankYous_temp);
      thankYous = thankYous_temp;

      prefs.setStringList('dates', dates_temp);
      thankYouDates = dates_temp;
      todayThankYous = todayThankYousFunc(thankYous, thankYouDates);
    });
  }

//function that adds a trait you to prefs and changes the state
  void addPositiveTrait(String positiveTrait) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> positiveTraits_temp =
        prefs.getStringList('positiveTraits') ?? [];
    List<String> positiveDates_temp =
        prefs.getStringList('positiveDates') ?? [];

    positiveTraits_temp.add(positiveTrait);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    positiveDates_temp.add(formattedDate);

    setState(() {
      prefs.setStringList('positiveTraits', positiveTraits_temp);
      positiveTraits = positiveTraits_temp;

      prefs.setStringList('positiveDates', positiveDates_temp);
      positiveDates = positiveDates_temp;
      threeLatestTraits = threeLatestTraitsFunc(positiveTraits);
    });
  }

//fuction to show the add form for a trait
  void addTraitNotification() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddForm(
            add: addPositiveTrait,
            index: 0,
            edit: changePositiveTrait,
            text: '',
            formTitle: 'מעלה',
          );
        });
  }

//function to handle a change in a trait
  void changePositiveTrait(String text, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      positiveTraits[index] = text;
      prefs.setStringList('positiveTraits', positiveTraits);
      threeLatestTraits = threeLatestTraitsFunc(positiveTraits);
    });
  }

//fuction to handle the removal of a trait
  void removePositiveTrait(int removeIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> positiveTraits_temp =
        prefs.getStringList('positiveTraits') ?? [];
    List<String> positiveDates_temp =
        prefs.getStringList('positiveDates') ?? [];
    positiveTraits_temp.removeAt(removeIndex);
    positiveDates_temp.removeAt(removeIndex);
    setState(() {
      prefs.setStringList('positiveTraits', positiveTraits_temp);
      positiveTraits = positiveTraits_temp;

      prefs.setStringList('positiveDates', positiveDates_temp);
      positiveDates = positiveDates_temp;
      threeLatestTraits = threeLatestTraitsFunc(positiveTraits);
    });
  }

//fuction to show the change form for a thank you
  void editTraitNotification(String text, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddForm(
            add: addPositiveTrait,
            index: index,
            edit: changePositiveTrait,
            text: text,
            formTitle: 'מעלה',
          );
        });
  }

//this selects what information to show in the personal plan widget boxes
  void setRandomPersonalWidgetText(userInfo, appInfo) {
    var random = Random();
    var randomHeader = random.nextInt(4);

    switch (randomHeader) {
      case 0:
        setState(() {
          homeTitles = {
            'SubTitle':
                appInfo.formMakeSaferTitles['subTitle${userInfo.gender}'],
            'list': userInfo.makeSafer
          };
        });
        break;
      case 1:
        setState(() {
          homeTitles = {
            'SubTitle':
                appInfo.formDifficultEventsTitles['subTitle${userInfo.gender}'],
            'list': userInfo.difficultEvents
          };
        });
        break;
      case 2:
        setState(() {
          homeTitles = {
            'SubTitle':
                appInfo.formFeelBetterTitles['subTitle${userInfo.gender}'],
            'list': userInfo.feelBetter
          };
        });
        break;
      case 3:
        setState(() {
          homeTitles = {
            'SubTitle':
                appInfo.formDistractionsTitles['subTitle${userInfo.gender}'],
            'list': userInfo.distractions
          };
        });
        break;
      default:
        setState(() {
          homeTitles = {'SubTitle': '', 'list': []};
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appInfoProvider = Provider.of<AppInformation>(context);
    final userInfoProvider = Provider.of<UserInformation>(context);
    final gender = userInfoProvider.gender;
    final age = userInfoProvider.age;
    //add random header and user-selected info from personal plan:
    setRandomPersonalWidgetText(userInfoProvider, appInfoProvider);

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: lightGray,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //This shows the "hello <username>" banner and settings button
              NameBar(
                  username: userInfoProvider.name,
                  greetingString: appInfoProvider.homeTitleGreeting,
                  icons: [
                    //settings button:
                    myTextButton(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserSettings(
                                collections: widget.collections,
                                collectionNames: widget.collectionNames,
                                checkboxModels: widget.checkboxModels,
                                phonePageData: widget.phonePageData,
                                username: userInfoProvider.name,
                                age: age,
                                gender: gender,
                                updateData: updateUsername,
                                titles:
                                    appInfoProvider.personalInformationForm)),
                      );
                    }, Icons.settings_outlined, primaryPurple)
                  ]),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Column(
                  children: [
                    //TEMP --------------------------------------------------------
                    //TOOD: all load functions were replaces with preload and variable homeTitles
                    //TODO: need to delete load aux functions from each widget
                    //TODO: not doing yet to not ruin main merge
                    /*ReminderWidget(
                      reminders: reminders,
                      add: addReminder,
                      reminderMainTitle: widget.appInfo.reminderMainTitle!,
                      reminderSubTitle: widget.appInfo.reminderSubTitle!,
                    ),*/

                    //this is the Personal Plan widget section
                    PersonalPlanWidget(
                        text: homeTitles,
                        changeCurrentIndex: widget.changeCurrentIndex),
                    const SizedBox(
                      height: 20.0,
                    ),
                    /* WarningSignsWidget(
                        warnings: warnings,
                        add: addWarning,
                        warningMainTitle:
                            widget.appInfo.warningHomePageTitles!['mainTitle']!,
                        warningSubTitle: widget.appInfo.warningHomePageTitles![
                            'secondaryTitle-' + gender]!),
                    SizedBox(height: 20),*/
                    //
                    //inspirational quote widget:
                    InspirationalQuote(
                        quotes: appInfoProvider.homePageInspirationalQuotes[
                            'quotes-${userInfoProvider.gender}']!),

                    const SizedBox(height: 20),
                    //This is the main widget for the positive traits list
                    TraitListWidget(
                      traits: threeLatestTraits,
                      add: addTraitNotification,
                      addSuggested: addPositiveTrait,
                      edit: editTraitNotification,
                      remove: removePositiveTrait,
                      traitListLength: positiveTraits.length,
                      onTabTapped: widget.changeCurrentIndex,
                    ),
                    const SizedBox(height: 20),
                    //This is the main widget for the thank yous list
                    ThanksListWidget(
                        thanks: todayThankYous,
                        add: addThanksNotification,
                        addSuggested: addThankYou,
                        edit: editThanksNotification,
                        remove: removeThankYou,
                        thanksListLength: thankYous.length,
                        onTabTapped: widget.changeCurrentIndex),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
