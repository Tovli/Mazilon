// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mazilon/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:provider/provider.dart';

// This widget is a dialog box for making emergency phone calls and sending WhatsApp messages.
class EmergencyDialogBox extends StatelessWidget {
  final String number; // The phone number to dial or message
  final int index; // Index used to retrieve appropriate text from AppInformation

  const EmergencyDialogBox(
      {super.key, required this.number, required this.index});

  @override
  Widget build(BuildContext context) {
    AppInformation appInfoProvider = Provider.of<AppInformation>(context);
    UserInformation userInfoProvider = Provider.of<UserInformation>(context);

    return AlertDialog(
      // Title of the dialog box
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: myText(
              userInfoProvider.gender == 'male'
                  ? appInfoProvider
                  .phonePageTitles['emergencyDialogChooseTitle']![index]
                  : userInfoProvider.gender == 'female'
                  ? appInfoProvider.phonePageTitles[
              'emergencyDialogChooseTitleFemale']![index]
                  : appInfoProvider.phonePageTitles[
              'emergencyDialogChooseTitleGeneral']![index],
              TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18.sp > 40 ? 40 : 20.sp),
              null),
        ),
      ),
      // Content of the dialog box, which includes options to make a call or send a WhatsApp message
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: myText(
                      appInfoProvider
                          .phonePageTitles['emergencyDialogDial']![index],
                      TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.sp > 35 ? 35 : 20.sp),
                      null),
                ),
                // Button to make a phone call
                GestureDetector(
                  child: CircleAvatar(
                    radius: 20, // adjust as needed
                    backgroundColor: primaryPurple,
                    foregroundColor: Colors.white,
                    child:
                    const Icon(Icons.phone, size: 20), // adjust as needed
                  ),
                  onTap: () async {
                    String url = 'tel:$number';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      print('Could not launch $url');
                    }
                  },
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: myText(
                      appInfoProvider
                          .phonePageTitles['emergencyDialogWhatsapp']![index],
                      TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.sp > 35 ? 35 : 20.sp),
                      null),
                ),
                // Button to send a WhatsApp message
                GestureDetector(
                  child: CircleAvatar(
                    radius: 20, // adjust as needed
                    backgroundColor: primaryPurple,
                    foregroundColor: appWhite,
                    child: const Icon(Icons.chat, size: 20), // adjust as needed
                  ),
                  onTap: () async {
                    String url = 'https://wa.me/$number';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      print('Could not launch $url');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      // Back button to close the dialog box
      actions: <Widget>[
        TextButton(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: myText(
                appInfoProvider.phonePageTitles['emergencyDialogBack']![index],
                TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp > 30 ? 30 : 20.sp),
                null),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

// This widget is a dialog box for making emergency phone calls without WhatsApp option.
class EmergencyDialogBoxNoWhatsapp extends StatelessWidget {
  final String number; // The phone number to dial
  final int index; // Index used to retrieve appropriate text from AppInformation

  const EmergencyDialogBoxNoWhatsapp(
      {super.key, required this.number, required this.index});

  @override
  Widget build(BuildContext context) {
    AppInformation appInfoProvider = Provider.of<AppInformation>(context);
    UserInformation userInfoProvider = Provider.of<UserInformation>(context);

    return AlertDialog(
      // Title of the dialog box
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: myText(
            userInfoProvider.gender == 'male'
                ? appInfoProvider
                .phonePageTitles['emergencyDialogChooseTitle']![index]
                : userInfoProvider.gender == 'female'
                ? appInfoProvider.phonePageTitles[
            'emergencyDialogChooseTitleFemale']![index]
                : appInfoProvider.phonePageTitles[
            'emergencyDialogChooseTitleGeneral']![index],
            TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18.sp > 40 ? 40 : 20.sp),
            null),
      ),
      // Content of the dialog box, which includes only the option to make a call
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: myText(
                      appInfoProvider
                          .phonePageTitles['emergencyDialogDial']![index],
                      TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.sp > 35 ? 35 : 20.sp),
                      null),
                ),
                // Button to make a phone call
                GestureDetector(
                  child: CircleAvatar(
                    radius: 20, // adjust as needed
                    backgroundColor: primaryPurple,
                    foregroundColor: Colors.white,
                    child:
                    const Icon(Icons.phone, size: 20), // adjust as needed
                  ),
                  onTap: () async {
                    String url = 'tel:$number';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      // Back button to close the dialog box
      actions: <Widget>[
        TextButton(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: myText(
                appInfoProvider.phonePageTitles['emergencyDialogBack']![index],
                TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp > 30 ? 30 : 20.sp),
                null),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

// This widget is a dialog box for making emergency phone calls with an additional website link option.
class EmergencyDialogBoxWithLink extends StatelessWidget {
  final String number; // The phone number to dial
  final int index; // Index used to retrieve appropriate text and link from AppInformation

  const EmergencyDialogBoxWithLink(
      {super.key, required this.number, required this.index});

  @override
  Widget build(BuildContext context) {
    AppInformation appInfoProvider = Provider.of<AppInformation>(context);
    UserInformation userInfoProvider = Provider.of<UserInformation>(context);

    return AlertDialog(
      // Title of the dialog box
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: myText(
            userInfoProvider.gender == 'male'
                ? appInfoProvider
                .phonePageTitles['emergencyDialogChooseTitle']![index]
                : userInfoProvider.gender == 'female'
                ? appInfoProvider.phonePageTitles[
            'emergencyDialogChooseTitleFemale']![index]
                : appInfoProvider.phonePageTitles[
            'emergencyDialogChooseTitleGeneral']![index],
            TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18.sp > 40 ? 40 : 20.sp),
            null),
      ),
      // Content of the dialog box, which includes options to make a call or visit a website
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: [
                      // Button to make a phone call
                      GestureDetector(
                        child: CircleAvatar(
                          radius: 20, // adjust as needed
                          backgroundColor: primaryPurple,
                          foregroundColor: Colors.white,
                          child: const Icon(Icons.phone,
                              size: 20), // adjust as needed
                        ),
                        onTap: () async {
                          String url = 'tel:$number';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                      const SizedBox(width: 4),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: myText(
                            appInfoProvider
                                .phonePageTitles['emergencyDialogDial']![index],
                            TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18.sp > 35 ? 35 : 20.sp),
                            null),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Button to visit a website
                      GestureDetector(
                        child: CircleAvatar(
                          radius: 20, // adjust as needed
                          backgroundColor: primaryPurple,
                          foregroundColor: appWhite,
                          child: const Icon(Icons.search,
                              size: 20), // adjust as needed
                        ),
                        onTap: () async {
                          String url = appInfoProvider.phonePageTitles[
                          'emergencyDialogWebsite']![index];
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                      const SizedBox(width: 4),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: myText(
                            appInfoProvider.phonePageTitles[
                            'emergencyDialogWebsiteTitle']![index],
                            TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18.sp > 35 ? 35 : 20.sp),
                            null),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Back button to close the dialog box
      actions: <Widget>[
        TextButton(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: myText(
                appInfoProvider.phonePageTitles['emergencyDialogBack']![index],
                TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp > 30 ? 30 : 20.sp),
                null),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
