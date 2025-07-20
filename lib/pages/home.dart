//import 'package:mazilon/initialForm/toFormPage.dart';
//import 'package:mazilon/menu.dart';
//import 'package:mazilon/util/myTextButton.dart';
//import 'package:mazilon/util/Reminders/reminder.dart';
//import 'package:mazilon/MainPageHelpers/reminderWidget.dart';
//import 'package:mazilon/depricated/Warning/warningSignsWidget.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mazilon/global_enums.dart';

import 'package:mazilon/util/Form/retrieveInformation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mazilon/pages/UserSettings.dart';
import 'package:mazilon/MainPageHelpers/personalPlanWidget.dart';
import 'package:mazilon/MainPageHelpers/traitListWidget.dart';
import 'package:mazilon/MainPageHelpers/thanksListWidget.dart';
import 'package:mazilon/util/HomePage/inspirationalQuote.dart';
import 'package:mazilon/util/styles.dart';

import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:mazilon/util/HomePage/NameBar.dart';

import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/l10n/app_localizations.dart';

//the main page of the app
//allows navigation to all other pages
class Home extends StatefulWidget {
  PhonePageData phonePageData;
  final Function(BuildContext, PagesCode) changeCurrentIndex;
  final Function changeLocale;

  Home({
    super.key,
    required this.phonePageData,
    required this.changeCurrentIndex,
    required this.changeLocale,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String greetingString = '';
  String fileButtonString = '';

  List<String> traits = [];

  bool hasFilled = false;
  Map<String, dynamic> homeTitles = {};

//load information about the user from shared preferences
  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      hasFilled = prefs.getBool('hasFilled') ?? false;
    });
  }

//function to update the user information(name,age,gender) in shared preferences
  void updateUserData(newName, newGender, newAge, isNonBinary) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (newGender != '') {
      prefs.setString('gender', newGender);
    }
  }

  @override
  void initState() {
    loadData();
    checkLanguage("a");
    super.initState();
  }

//fuction to handle the removal of a thank you

//this selects what information to show in the personal plan widget boxes
  void setRandomPersonalWidgetText(userInfo, appLocale) {
    var random = Random();
    var randomHeader = random.nextInt(4);

    switch (randomHeader) {
      case 0:
        setState(() {
          homeTitles = {
            'SubTitle': appLocale.makeSaferSubTitle(userInfo.gender),
            'list': userInfo.makeSafer
          };
        });
        break;
      case 1:
        setState(() {
          homeTitles = {
            'SubTitle': appLocale.difficultEventsSubTitle(userInfo.gender),
            'list': userInfo.difficultEvents
          };
        });
        break;
      case 2:
        setState(() {
          homeTitles = {
            'SubTitle': appLocale.feelBetterSubTitle(userInfo.gender),
            'list': userInfo.feelBetter
          };
        });
        break;
      case 3:
        setState(() {
          homeTitles = {
            'SubTitle': appLocale.distractionsSubTitle(userInfo.gender),
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

  void checkLanguage(String string) {
    final regex = RegExp(r'[a-z]');
    final regexHebrew = RegExp(r'[\u0590-\u05FF]');
    if (regexHebrew.hasMatch("a"))
      print("has match");
    else
      print("no match");
    // return regex.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: true);
    final gender = userInfoProvider.gender;
    final age = userInfoProvider.age;
    final appLocale = AppLocalizations.of(context);

    //add random header and user-selected info from personal plan:
    setRandomPersonalWidgetText(userInfoProvider, appLocale);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: lightGray,
      ),
      backgroundColor: lightGray,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //This shows the "hello <username>" banner and settings button
              NameBar(
                  greetingString: appLocale!.homePageGreetings(gender),
                  icons: [
                    //settings button:
                    myTextButton(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserSettings(
                                  phonePageData: widget.phonePageData,
                                  username: userInfoProvider.name,
                                  age: age,
                                  gender: gender,
                                  updateData: updateUserData,
                                  changeLocale: widget.changeLocale,
                                )),
                      );
                    }, Icons.settings_outlined, primaryPurple)
                  ]),

              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Column(
                  children: [
                    //this is the Personal Plan widget section
                    PersonalPlanWidget(
                        text: homeTitles,
                        changeCurrentIndex: widget.changeCurrentIndex),
                    const SizedBox(
                      height: 20.0,
                    ),

                    //inspirational quote widget:

                    InspirationalQuote(
                        quotes: retrieveInspirationalQuotes(
                            appLocale, gender == "" ? "other" : gender)),

                    const SizedBox(height: 20),
                    //This is the main widget for the positive traits list
                    TraitListWidget(
                      onTabTapped: widget.changeCurrentIndex,
                    ),
                    const SizedBox(height: 20),
                    //This is the main widget for the thank yous list
                    ThanksListWidget(onTabTapped: widget.changeCurrentIndex),
                  ],
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
