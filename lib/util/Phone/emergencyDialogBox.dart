// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mazilon/util/Phone/phoneTextAndIcon.dart';
import 'package:mazilon/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// This widget is a dialog box for making emergency phone calls and sending WhatsApp messages.
class EmergencyDialogBox extends StatelessWidget {
  final String number; // The phone number to dial or message
  final int
      index; // Index used to retrieve appropriate text from AppInformation
  final bool hasWhatsApp;
  final bool hasLink;
  const EmergencyDialogBox(
      {super.key,
      required this.number,
      required this.index,
      required this.hasWhatsApp,
      required this.hasLink});

  @override
  Widget build(BuildContext context) {
    AppInformation appInfoProvider = Provider.of<AppInformation>(context);

    UserInformation userInfoProvider = Provider.of<UserInformation>(context);

    final gender = userInfoProvider.gender;
    return AlertDialog(
      // Title of the dialog box
      title: myText(
          AppLocalizations.of(context)!.select(gender),
          TextStyle(
              fontWeight: FontWeight.normal, fontSize: 18.sp > 40 ? 40 : 20.sp),
          null),
      // Content of the dialog box, which includes options to make a call or send a WhatsApp message
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                getTextIconWidget(
                  AppLocalizations.of(context)!.dialButton(gender),
                  () async {
                    await dialPhone(number);
                  },
                  Icons.phone,
                ),
                if (hasWhatsApp)
                  getTextIconWidget(AppLocalizations.of(context)!.whatsApp,
                      () async {
                    await openWhatsApp(number);
                  }, Icons.chat),

                if (hasLink)
                  getTextIconWidget(AppLocalizations.of(context)!.link,
                      () async {
                    await openSite(appInfoProvider
                        .phonePageTitles['emergencyDialogWebsite']![index]);
                  }, Icons.search),

                // Button to make a phone call
              ],
            ),
          ],
        ),
      ),
      // Back button to close the dialog box
      actions: <Widget>[
        TextButton(
          child: myText(
              AppLocalizations.of(context)!.backButton(gender),
              TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp > 30 ? 30 : 20.sp),
              null),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
