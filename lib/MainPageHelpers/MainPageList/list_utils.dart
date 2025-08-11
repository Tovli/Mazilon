import 'package:flutter/material.dart';

import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mazilon/AnalyticsService.dart';
import 'package:mazilon/global_enums.dart';
import 'package:mazilon/util/userInformation.dart';

Map<String, dynamic> getLocalizedTextForLists(locale, gender, type) {
  switch (type) {
    case PagesCode.GratitudeJournal:
      return {
        'mainTitle': locale!.homePageThanksMainTitle(gender),
        'secondaryTitle': locale!.homePageThanksSecondaryTitle(gender),
        "icon": FontAwesome5.praying_hands
      };

    case PagesCode.QualitiesList:
      return {
        'mainTitle': locale!.homePageTraitsMainTitle(gender),
        'secondaryTitle': locale!.homePageTraitsSecondaryTitle(gender),
        "icon": Icons.diamond
      };
    default:
      return {'mainTitle': '', 'SecondaryTitle': '', "icon": Icons.diamond};
  }
}

List<String> todayThankYousFunc(List<String> thankYous, List<String> dates) {
  List<String> todayThankYous = [];
  DateTime now = DateTime.now();
  String formattedDate = intl.DateFormat('yyyy-MM-dd – kk:mm').format(now);

  for (int i = 0; i < dates.length; i++) {
    if (dates[i].substring(0, 10) == formattedDate.substring(0, 10)) {
      todayThankYous.add(thankYous[i]);
    }
  }
  return todayThankYous;
}

List<String> getListItems(PagesCode pageCode, UserInformation userInfoProvider,
    List<String> todayThankYous) {
  if (pageCode == PagesCode.GratitudeJournal) {
    return todayThankYous;
  } else {
    return userInfoProvider.positiveTraits;
  }
}

void addThankYou(String thankYou, UserInformation userInfoProvider,
    stateFunction, popupFunction) {
  List<String> thankYous_temp = userInfoProvider.thanks['thanks'] ?? [];
  List<String> dates_temp = userInfoProvider.thanks['dates'] ?? [];

  thankYous_temp.add(thankYou);

  DateTime now = DateTime.now();
  String formattedDate = intl.DateFormat('yyyy-MM-dd – kk:mm').format(now);
  dates_temp.add(formattedDate);
  stateFunction(thankYous_temp, dates_temp, userInfoProvider);

  if (todayThankYousFunc(userInfoProvider.thanks["thanks"] ?? [],
              userInfoProvider.thanks["dates"] ?? [])
          .length ==
      1) {
    popupFunction(userInfoProvider);
  }
  AnalyticsService mixPanelService = GetIt.instance<AnalyticsService>();
  mixPanelService.trackEvent(
    "Item added to Gratitude Journal",
  );
}

void addPositiveTrait(
    String positiveTrait, UserInformation userInfoProvider, stateFunction) {
  List<String> positiveTraits_temp = userInfoProvider.positiveTraits;
  positiveTraits_temp.add(positiveTrait);
  stateFunction(positiveTraits_temp);

  AnalyticsService mixPanelService = GetIt.instance<AnalyticsService>();
  mixPanelService.trackEvent(
    "Item added to Qualities List",
  );
}

void editPositiveTrait(
    String text, int index, UserInformation userInfoProvider, stateFunction) {
  List<String> positiveTraits = userInfoProvider.positiveTraits;

  stateFunction(positiveTraits, userInfoProvider);
}

void editThankYou(
    String text, int index, UserInformation userinfoProvider, stateFunction) {
  var thankYous_temp = userinfoProvider.thanks['thanks'] ?? [];
  thankYous_temp[index] = text;
  var thankYouDates = userinfoProvider.thanks['dates'] ?? [];
  stateFunction(thankYous_temp, userinfoProvider, thankYouDates);
}

void removeThankYou(
    int removeIndex, UserInformation userInfoProvider, stateFunction) {
  List<String> thankYous_temp = userInfoProvider.thanks['thanks'] ?? [];
  List<String> dates_temp = userInfoProvider.thanks['dates'] ?? [];

  thankYous_temp.removeAt(removeIndex);
  dates_temp.removeAt(removeIndex);
  stateFunction(
    thankYous_temp,
    dates_temp,
    userInfoProvider,
  );
}

void removePositiveTrait(
    int removeIndex, UserInformation userInfoProvider, stateFunction) {
  List<String> positiveTraits_temp = userInfoProvider.positiveTraits;
  positiveTraits_temp.removeAt(removeIndex);
  stateFunction(positiveTraits_temp, userInfoProvider);
}
