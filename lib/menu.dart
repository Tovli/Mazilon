//import 'package:mazilon/pages/schedule.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/AnalyticsService.dart';
import 'package:mazilon/global_enums.dart';
import 'package:mazilon/pages/about.dart';
import 'package:mazilon/pages/FeelGood/feelGood.dart';
import 'package:mazilon/pages/WellnessTools/wellnessTools.dart';
import 'package:mazilon/pages/notifications/notification_page.dart';
import 'package:mazilon/util/Form/retrieveInformation.dart';
import 'package:flutter/services.dart';
import 'package:mazilon/util/LP_extended_state.dart';
import 'package:mazilon/util/persistent_memory_service.dart';
import 'package:mazilon/pages/UserSettings.dart';

import 'package:mazilon/pages/home.dart';
import 'package:mazilon/pages/journal.dart';
import 'package:mazilon/pages/phone.dart';
import 'package:mazilon/pages/positive.dart';
import 'package:mazilon/pages/PersonalPlan/myPlanPageFull.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/styles.dart';

import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:mazilon/util/HomePage/bottomNavigationItem.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

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

class _MenuState extends LPExtendedState<Menu> {
  PagesCode current = PagesCode.Home;
  String version = "1.0.0";
  bool isFullScreen = false;
  late Widget currentScreen;

  //Function to set that the users has already opened the app before
  void loadFirstTime() async {
    PersistentMemoryService service = GetIt.instance<
        PersistentMemoryService>(); // Get the persistent memory service instance

    await service.setItem("enteredBefore", PersistentMemoryType.Bool, true);
  }

  void testingChange() async {
    PersistentMemoryService service = GetIt.instance<
        PersistentMemoryService>(); // Get the persistent memory service instance

    await service.setItem(
        "disclaimerConfirmed", PersistentMemoryType.Bool, true);
    var location =
        await service.getItem("location", PersistentMemoryType.String);

    if (location != null && location.toString().isNotEmpty) {
      debugPrint(location.toString());
    }
  }

//Function to check if the user wants to go full screen
  void setFullScreen(bool fullScreen) {
    setState(() {
      isFullScreen = fullScreen;
    });
  }

//Function to change the current displayed page in the "home"
  void changeCurrentIndex(BuildContext context, PagesCode index) {
    final appLocale = AppLocalizations.of(context)!;
    final userInformation =
        Provider.of<UserInformation>(context, listen: false);
    final gender = userInformation.gender;
    AnalyticsService mixPanelService = GetIt.instance<AnalyticsService>();

    setState(() {
      current = index;
      //adding pages to menu here:

      if (index == PagesCode.FullPlan) {
        mixPanelService.trackEvent(
          "Viewed full Personal Plan",
        );
        currentScreen = MyPlanPageFull(
          phonePageData: widget.phonePageData,
          hasFilled: widget.hasFilled,
          changeLocale: widget.changeLocale,
        );
      } else if (index == PagesCode.QualitiesList) {
        mixPanelService.trackEvent(
          "Viewed full Qualities List",
        );
        currentScreen = Positive();
      } else if (index == PagesCode.GratitudeJournal) {
        mixPanelService.trackEvent(
          "Viewed full Gratitude Journal",
        );
        currentScreen = Journal(
          fullSuggestionList:
              retrieveThanksList(appLocale, gender == "" ? "other" : gender),
        );
      } else if (index == PagesCode.EmergencyPhones) {
        currentScreen = PhonePage(phonePageData: widget.phonePageData);
      } else if (index == PagesCode.About) {
        currentScreen = About(version: version);
      } else if (index == PagesCode.NotificationPage) {
        if (!kIsWeb) {
          currentScreen = NotificationPage();
        }
      } else if (index == PagesCode.FeelGoodPage) {
        currentScreen = FeelGood();
      } /*else if (index == 9) {
        currentScreen = syncDevicesRealTime(
            collections: widget.collections,

            gender: userInformation.gender,
            phonePageData: widget.phonePageData);
      }*/
    });
  }

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  Widget displayNotificationButton(String gender, bool isWeb) {
    if (isWeb) {
      return const SizedBox.shrink();
    }

    return TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.notification_add),
          SizedBox(width: 20),
          Text(AppLocalizations.of(context)!.notifications(gender)),
        ],
      ),
      onPressed: () {
        setState(() {
          currentScreen = NotificationPage();

          current = PagesCode.NotificationPage;
        });
        Navigator.of(context).pop();
      },
    );
  }

  Map<String, List<String>> _filterVideoByLocal(
      Map<String, List<String>> videos) {
    var localizedVideos = {
      'videoId': <String>[],
      'videoHeadline': <String>[],
      'videoDescription': <String>[],
      'videoLocale': <String>[]
    };

    for (var i = 0; i < videos["videoLocale"]!.length; i++) {
      var video = videos["videoLocale"]![i];
      if (video == Localizations.localeOf(context).languageCode) {
        /*    'videoId': [],
    'videoHeadline': [],
    'videoDescription': [],
    'videoLocal': []*/
        localizedVideos['videoId']?.add(videos["videoId"]![i]);
        localizedVideos['videoHeadline']?.add(videos["videoHeadline"]![i]);
        localizedVideos['videoDescription']
            ?.add(videos["videoDescription"]![i]);
        localizedVideos['videoLocale']?.add(videos["videoLocale"]![i]);
      }
    }

    return localizedVideos;
  }

  Widget _buildHomeScreen() {
    return Home(
      phonePageData: widget.phonePageData,
      changeCurrentIndex: changeCurrentIndex,
      changeLocale: widget.changeLocale,
      openMainMenu: _showMainMenu,
    );
  }

  void _showWellnessTools(AppInformation appInfoProvider) {
    setState(() {
      currentScreen = WellnessTools(
          isFullScreen: isFullScreen,
          videoData: _filterVideoByLocal(appInfoProvider.wellnessVideos),
          setBool: setFullScreen);
      current = PagesCode.WellnessToolsPage;
    });
  }

  void _showMainMenu(BuildContext anchorContext) {
    final userInformation =
        Provider.of<UserInformation>(context, listen: false);
    final gender = userInformation.gender;
    final age = userInformation.age;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isRtl = appLocale.textDirection == "rtl";
    final maxMenuWidth = screenWidth - 24 < 260 ? screenWidth - 24 : 260.0;
    final minMenuWidth = maxMenuWidth < 180 ? maxMenuWidth : 180.0;
    final menuWidth = (screenWidth * (isRtl ? 0.38 : 0.45))
        .clamp(minMenuWidth, maxMenuWidth)
        .toDouble();
    final anchorBox = anchorContext.findRenderObject();
    final overlayBox = Overlay.of(context).context.findRenderObject();
    var menuLeft = isRtl ? 12.0 : screenWidth - menuWidth - 12.0;
    var menuTop = mediaQuery.padding.top + kToolbarHeight;

    if (anchorBox is RenderBox && overlayBox is RenderBox) {
      final anchorOffset =
          anchorBox.localToGlobal(Offset.zero, ancestor: overlayBox);

      menuLeft = isRtl
          ? anchorOffset.dx
          : anchorOffset.dx + anchorBox.size.width - menuWidth;
      menuTop = anchorOffset.dy + anchorBox.size.height + 8;
    }

    menuLeft = menuLeft.clamp(12.0, screenWidth - menuWidth - 12.0);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Stack(
          children: [
            Positioned(
              left: menuLeft,
              top: menuTop,
              width: menuWidth,
              child: Material(
                key: const Key('mainMenuDialog'),
                color: Colors.white,
                elevation: 24.0,
                shape: Border.all(
                  color: primaryPurple,
                  width: 2,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      textDirection:
                          isRtl ? TextDirection.ltr : TextDirection.rtl,
                      children: [
                        IconButton(
                          key: const Key('mainMenuCloseButton'),
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Expanded(
                          child: Align(
                            alignment: isRtl
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: TextButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.people),
                                  SizedBox(width: 20),
                                  Text(appLocale.homePageAbout(gender)),
                                ],
                              ),
                              onPressed: () {
                                setState(() {
                                  currentScreen = About(version: version);
                                  current = PagesCode.About;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    displayNotificationButton(gender, kIsWeb),
                    TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.settings),
                          SizedBox(width: 20),
                          Text(appLocale.settings(gender)),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserSettings(
                                    phonePageData: widget.phonePageData,
                                    username: userInformation.name,
                                    age: age,
                                    gender: gender,
                                    changeLocale: widget.changeLocale,
                                  )),
                        );
                      },
                    ),
                    TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.share),
                          SizedBox(width: 20),
                          Text(appLocale.shareButtonText),
                        ],
                      ),
                      onPressed: () async {
                        await SharePlus.instance.share(
                          ShareParams(
                            text:
                                '${appLocale.shareAppMessage}\n https://sites.google.com/mishol.org/matzilon/%D7%91%D7%99%D7%AA',
                            subject: 'Living Positively App',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    loadFirstTime();
    getVersion();
    super.initState();
    //this is the initial page
    currentScreen = _buildHomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    AnalyticsService mixPanelService = GetIt.instance<AnalyticsService>();
    final userInformation = Provider.of<UserInformation>(context);
    final appInfoProvider = Provider.of<AppInformation>(context);
    final gender = userInformation.gender;
    testingChange();

    return PopScope(
      //this is the popscope widget that will handle the back button
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        } else {
          if (current == PagesCode.Home) {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
          changeCurrentIndex(context, PagesCode.Home);
          currentScreen = _buildHomeScreen();
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
                    current = PagesCode.EmergencyPhones;
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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final navWidth = constraints.maxWidth;

                      return Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: appLocale.localeName == 'en'
                                ? navWidth / 6
                                : navWidth / 8,
                            alignment: appLocale.textDirection == "rtl"
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    currentScreen = _buildHomeScreen();
                                    current = PagesCode.Home;
                                  });
                                },
                                child: bottomNavigationItem(
                                    current == PagesCode.Home,
                                    Icons.home,
                                    appLocale.home(gender))),
                          ),
                          Container(
                            alignment: appLocale.textDirection == "rtl"
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            width: appLocale.localeName == 'en'
                                ? navWidth / 5
                                : navWidth / 4,
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    currentScreen = MyPlanPageFull(
                                      phonePageData: widget.phonePageData,
                                      hasFilled: widget.hasFilled,
                                      changeLocale: widget.changeLocale,
                                    );
                                    current = PagesCode.FullPlan;
                                  });
                                },
                                child: bottomNavigationItem(
                                    current == PagesCode.FullPlan,
                                    Icons.assignment,
                                    appLocale.personalPlanPageMyPlan(gender))),
                          ),
                          SizedBox(
                            width: navWidth / 9,
                          ),
                          Container(
                            alignment: appLocale.textDirection == "rtl"
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            width: navWidth / 4,
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    mixPanelService.trackEvent(
                                      "Viewed Feel Good Page",
                                    );
                                    currentScreen = FeelGood();
                                    current = PagesCode.FeelGoodPage;
                                  });
                                },
                                child: bottomNavigationItem(
                                    current == PagesCode.FeelGoodPage,
                                    Icons.emoji_emotions_outlined,
                                    AppLocalizations.of(context)!
                                        .homePageFeelGood(gender))),
                          ),
                          SizedBox(
                            width: appLocale.localeName == 'en'
                                ? navWidth / 4
                                : navWidth / 4.5,
                            child: Align(
                              alignment: appLocale.textDirection == "rtl"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  _showWellnessTools(appInfoProvider);
                                },
                                child: bottomNavigationItem(
                                    current == PagesCode.WellnessToolsPage,
                                    Icons.local_florist_outlined,
                                    appLocale.homePageWellnessTools(gender)),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
