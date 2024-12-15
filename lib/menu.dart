//import 'package:mazilon/pages/schedule.dart';

import 'package:flutter/material.dart';
import 'package:mazilon/lists.dart';

import 'package:mazilon/pages/about.dart';
import 'package:mazilon/pages/FeelGood/feelGood.dart';
import 'package:mazilon/pages/WellnessTools/wellnessTools.dart';
import 'package:mazilon/pages/notifications/notification_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:mazilon/pages/home.dart';
import 'package:mazilon/pages/journal.dart';
import 'package:mazilon/pages/phone.dart';
import 'package:mazilon/pages/positive.dart';
import 'package:mazilon/pages/PersonalPlan/myPlanPageFull.dart';

import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/styles.dart';

import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:mazilon/util/HomePage/bottomNavigationItem.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Menu extends StatefulWidget {
  final PhonePageData phonePageData;
  final bool hasFilled;
  final Function changeLocale;

  const Menu(
      {super.key,
      required this.phonePageData,
      required this.hasFilled,
      required this.changeLocale});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int current = 0;

  bool isFullScreen = false;
  late Widget currentScreen;
  //Function to set that the users has already opened the app before
  void loadFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('firstTime', false);
  }

//Function to check if the user wants to go full screen
  void setFullScreen(bool fullScreen) {
    setState(() {
      isFullScreen = fullScreen;
    });
  }

//Function to change the current displayed page in the "home"
  void changeCurrentIndex(BuildContext context, int index) {
    final userInformation =
        Provider.of<UserInformation>(context, listen: false);
    final gender = userInformation.gender;
    setState(() {
      current = index;
      //adding pages to menu here:
      if (index == 1) {
        currentScreen = MyPlanPageFull(
          phonePageData: widget.phonePageData,
          hasFilled: widget.hasFilled,
          changeLocale: widget.changeLocale,
        );
      } else if (index == 2) {
        currentScreen = Positive();
      } else if (index == 3) {
        currentScreen = Journal(
          fullSuggestionList: thanksList[AppLocalizations.of(context)!
              .localeName]![gender == "" ? "other" : gender]!,
        );
      } else if (index == 4) {
        currentScreen = PhonePage(phonePageData: widget.phonePageData);
      } else if (index == 5) {
        //we dont want current screen to change here
      } else if (index == 6) {
        currentScreen = About();
      } else if (index == 9) {
        currentScreen = NotificationPage();
      } else if (index == 7) {
        //currentScreen =
        //    WellnessTools( videoData: appInfoProvider.wellnessVideos,setBool: setFullScreen, isFullScreen: isFullScreen);
      } else if (index == 8) {
        currentScreen = FeelGood();
      } /*else if (index == 9) {
        currentScreen = syncDevicesRealTime(
            collections: widget.collections,

            gender: userInformation.gender,
            phonePageData: widget.phonePageData);
      }*/
    });
  }

  @override
  void initState() {
    loadFirstTime();

    super.initState();
    //this is the initial page
    currentScreen = Home(
      phonePageData: widget.phonePageData,
      changeCurrentIndex: changeCurrentIndex,
      changeLocale: widget.changeLocale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInformation = Provider.of<UserInformation>(context);
    final appInfoProvider = Provider.of<AppInformation>(context);
    final gender = userInformation.gender;
    print(gender);
    print("this is the gender: ${gender}");
    print(userInformation.difficultEvents);
    print(gender == '');
    return PopScope(
      //this is the popscope widget that will handle the back button
      canPop: false,
      onPopInvoked: (didpop) async {
        if (didpop) {
          return;
        } else {
          changeCurrentIndex(context, 0);
          currentScreen = Home(
            phonePageData: widget.phonePageData,
            changeCurrentIndex: changeCurrentIndex,
            changeLocale: widget.changeLocale,
          );
        }
      },
      child: Scaffold(
        backgroundColor: appWhite,
        resizeToAvoidBottomInset: false,
        body: currentScreen,
        //when full screen don't show the SOS button
        floatingActionButton: isFullScreen
            ? null
            : FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: const Color.fromARGB(255, 33, 1, 101),
                foregroundColor: appWhite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.phone),
                    myAutoSizedText(
                        'SOS',
                        TextStyle(
                          // for testing remove the .sp IDK why, // adjust the size as needed
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        null,
                        20),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    currentScreen =
                        PhonePage(phonePageData: widget.phonePageData);
                    current = 4;
                  });
                },
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //when full screen don't show the bottom navigation bar
        bottomNavigationBar: isFullScreen
            ? null
            : BottomAppBar(
                elevation: 0,
                color: appWhite,
                shape: const CircularNotchedRectangle(),
                notchMargin: 10,
                child: Container(
                  color: appWhite,
                  height: 60,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 70,
                        alignment:
                            AppLocalizations.of(context)!.textDirection == "rtl"
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                currentScreen = Home(
                                  phonePageData: widget.phonePageData,
                                  changeCurrentIndex: changeCurrentIndex,
                                  changeLocale: widget.changeLocale,
                                );
                                current = 0;
                              });
                            },
                            child: bottomNavigationItem(
                                current == 0,
                                Icons.home,
                                AppLocalizations.of(context)!.home(gender))),
                      ),
                      Container(
                        alignment:
                            AppLocalizations.of(context)!.textDirection == "rtl"
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                        width: 100,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                currentScreen = MyPlanPageFull(
                                  phonePageData: widget.phonePageData,
                                  hasFilled: widget.hasFilled,
                                  changeLocale: widget.changeLocale,
                                );
                                current = 1;
                              });
                            },
                            child: bottomNavigationItem(
                                current == 1,
                                Icons.assignment,
                                AppLocalizations.of(context)!
                                    .personalPlanPageMyPlan(gender))),
                      ),
                      Container(
                        width: 200,
                        child: Align(
                          alignment:
                              AppLocalizations.of(context)!.textDirection ==
                                      "rtl"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: MaterialLocalizations.of(context)
                                    .modalBarrierDismissLabel,
                                barrierColor: Colors.black45,
                                transitionDuration:
                                    const Duration(milliseconds: 200),
                                pageBuilder: (BuildContext buildContext,
                                    Animation animation,
                                    Animation secondaryAnimation) {
                                  return FractionallySizedBox(
                                    heightFactor: 0.85,
                                    widthFactor: 0.6,
                                    alignment: AppLocalizations.of(context)!
                                                .textDirection ==
                                            "rtl"
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: Align(
                                      alignment: Alignment
                                          .bottomCenter, // Change alignment to bottom center
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Material(
                                          color: Colors.white,
                                          elevation: 24.0,
                                          shape: Border.all(
                                            color: primaryPurple,
                                            width: 2,
                                          ),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Align(
                                                  alignment: AppLocalizations
                                                                  .of(context)!
                                                              .textDirection ==
                                                          "rtl"
                                                      ? Alignment.topRight
                                                      : Alignment.topLeft,
                                                  child: IconButton(
                                                    icon: Icon(Icons.close),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                                TextButton(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(Icons.people),
                                                      SizedBox(width: 20),
                                                      Text(AppLocalizations.of(
                                                              context)!
                                                          .homePageAbout(
                                                              gender)),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      currentScreen = About();
                                                      current = 6;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(Icons
                                                          .notification_add),
                                                      SizedBox(width: 20),
                                                      Text(AppLocalizations.of(
                                                              context)!
                                                          .notifications(
                                                              gender)),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      currentScreen =
                                                          NotificationPage();

                                                      current = 10;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(Icons.yard_outlined),
                                                      SizedBox(width: 20),
                                                      Text(AppLocalizations.of(
                                                              context)!
                                                          .homePageWellnessTools(
                                                              gender)),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      currentScreen = WellnessTools(
                                                          isFullScreen:
                                                              isFullScreen,
                                                          videoData:
                                                              appInfoProvider
                                                                  .wellnessVideos,
                                                          setBool:
                                                              setFullScreen);
                                                      current = 7;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(Icons
                                                          .emoji_emotions_outlined),
                                                      SizedBox(width: 20),
                                                      Text(AppLocalizations.of(
                                                              context)!
                                                          .homePageFeelGood(
                                                              gender)),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      currentScreen =
                                                          FeelGood();
                                                      current = 8;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                              setState(() {
                                current = 5;
                              });
                            },
                            child: bottomNavigationItem(
                                current == 5,
                                Icons.menu,
                                AppLocalizations.of(context)!.menu(gender)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
