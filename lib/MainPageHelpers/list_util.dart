import 'package:flutter/material.dart';

import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:mazilon/global_enums.dart';

Map<String, dynamic> getLocalizedText(locale, gender, type) {
  switch (type) {
    case PagesCode.GratitudeJournal:
      return {
        'mainTitle': locale!.homePageThanksMainTitle(gender),
        'SecondaryTitle': locale!.homePageThanksSecondaryTitle(gender),
        "icon": FontAwesome5.praying_hands
      };

    case PagesCode.QualitiesList:
      return {
        'mainTitle': locale!.homePageTraitsMainTitle(gender),
        'SecondaryTitle': locale!.homePageTraitsSecondaryTitle(gender),
        "icon": Icons.diamond
      };
    default:
      return {'mainTitle': '', 'SecondaryTitle': '', "icon": Icons.diamond};
  }
}
