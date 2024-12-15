import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/menu.dart';
import 'package:mazilon/util/Form/formPagePhoneModel.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget getMenuForTests(
    UserInformation mockUserInformation, AppInformation mockAppInformation) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<UserInformation>.value(value: mockUserInformation),
      ChangeNotifierProvider<AppInformation>.value(value: mockAppInformation),
    ],
    child: MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('he'),
      localizationsDelegates: [
        AppLocalizations.localizationsDelegates[0],
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      home: ScreenUtilInit(
        designSize: const Size(360, 690),
        child: Menu(
          phonePageData: PhonePageData(
            key: 'phonePageData',
            header: 'header',
            subTitle: 'subTitle',
            midTitle: 'midTitle',
            phoneNameTitle: 'phoneNameTitle',
            phoneNumberTitle: 'phoneNumberTitle',
            phoneNames: [],
            phoneNumbers: [],
            savedPhoneNames: [],
            savedPhoneNumbers: [],
            phoneDescription: [],
          ),
          changeLocale: (String locale) {},
          hasFilled: false,
        ),
      ),
    ),
  );
}
