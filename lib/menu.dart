//import 'package:mazilon/pages/schedule.dart';

import 'package:flutter/material.dart';

import 'package:mazilon/pages/about.dart';
import 'package:mazilon/pages/FeelGood/feelGood.dart';
import 'package:mazilon/pages/WellnessTools/wellnessTools.dart';
import 'package:mazilon/pages/notifications/notification_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:mazilon/pages/home.dart';
import 'package:mazilon/pages/journal.dart';
import 'package:mazilon/pages/phone.dart';
import 'package:mazilon/pages/positive.dart';
import 'package:mazilon/pages/PersonalPlan/schedule2.dart';

import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Form/checkbox_model.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:mazilon/util/HomePage/bottomNavigationItem.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  final List<List<String>> collections;
  final List<String> collectionNames;
  final Map<String, CheckboxModel> checkboxModels;
  final PhonePageData phonePageData;
  final bool hasFilled;

  const Menu(
      {super.key,
      required this.collections,
      required this.collectionNames,
      required this.checkboxModels,
      required this.phonePageData,
      required this.hasFilled});

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
  void changeCurrentIndex(int index) {
    final userInformation =
        Provider.of<UserInformation>(context, listen: false);
    setState(() {
      current = index;
      //adding pages to menu here:
      if (index == 1) {
        currentScreen = Schedule(
          collections: widget.collections,
          collectionNames: widget.collectionNames,
          checkboxModels: widget.checkboxModels,
          phonePageData: widget.phonePageData,
          hasFilled: widget.hasFilled,
        );
      } else if (index == 2) {
        currentScreen = Positive();
      } else if (index == 3) {
        currentScreen = Journal();
      } else if (index == 4) {
        currentScreen = PhonePage(
            gender: userInformation.gender,
            phonePageData: widget.phonePageData);
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
            checkboxModels: widget.checkboxModels,
            collectionNames: widget.collectionNames,
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
      collections: widget.collections,
      collectionNames: widget.collectionNames,
      checkboxModels: widget.checkboxModels,
      phonePageData: widget.phonePageData,
      changeCurrentIndex: changeCurrentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInformation = Provider.of<UserInformation>(context);
    final appInfoProvider = Provider.of<AppInformation>(context);

    return PopScope(
      //this is the popscope widget that will handle the back button
      canPop: false,
      onPopInvoked: (didpop) async {
        if (didpop) {
          return;
        } else {
          changeCurrentIndex(0);
          currentScreen = Home(
            collections: widget.collections,
            collectionNames: widget.collectionNames,
            checkboxModels: widget.checkboxModels,
            phonePageData: widget.phonePageData,
            changeCurrentIndex: changeCurrentIndex,
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
                    currentScreen = PhonePage(
                        gender: userInformation.gender,
                        phonePageData: widget.phonePageData);
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
                        width: 200,
                        child: Align(
                          alignment: Alignment.centerLeft,
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
                                    alignment: Alignment.topLeft,
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
                                                  alignment: Alignment.topRight,
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
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: Text(appInfoProvider
                                                                    .extraMenuStrings[
                                                                'About'] ??
                                                            'אודות'),
                                                      ),
                                                      SizedBox(width: 20),
                                                      Icon(Icons.people),
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
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: Text('התראות'),
                                                      ),
                                                      SizedBox(width: 20),
                                                      Icon(Icons.people),
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
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: Text(appInfoProvider
                                                                    .extraMenuStrings[
                                                                'WellnessTools'] ??
                                                            'כלי תמיכה'),
                                                      ),
                                                      SizedBox(width: 20),
                                                      Icon(Icons.yard_outlined),
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
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: Text(appInfoProvider
                                                                    .extraMenuStrings[
                                                                'feelGood'] ??
                                                            "להרגיש טוב"),
                                                      ),
                                                      SizedBox(width: 20),
                                                      Icon(Icons
                                                          .emoji_emotions_outlined),
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
                                current == 5, Icons.menu, 'תפריט'),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 100,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                currentScreen = Schedule(
                                  collections: widget.collections,
                                  collectionNames: widget.collectionNames,
                                  checkboxModels: widget.checkboxModels,
                                  phonePageData: widget.phonePageData,
                                  hasFilled: widget.hasFilled,
                                );
                                current = 1;
                              });
                            },
                            child: bottomNavigationItem(
                                current == 1,
                                Icons.assignment,
                                appInfoProvider.personalPlanMainTitle[
                                    'PersonalPlanMainTitle-' +
                                        userInformation.gender])),
                      ),
                      Container(
                        width: 50,
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                currentScreen = Home(
                                  collections: widget.collections,
                                  collectionNames: widget.collectionNames,
                                  checkboxModels: widget.checkboxModels,
                                  phonePageData: widget.phonePageData,
                                  changeCurrentIndex: changeCurrentIndex,
                                );
                                current = 0;
                              });
                            },
                            child: bottomNavigationItem(
                                current == 0, Icons.home, 'בית')),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
