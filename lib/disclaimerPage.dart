// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mazilon/util/disclaimer_lang.dart';

// the disclaimer page widget,
// it shows the disclaimer text and a button to confirm the disclaimer
class DisclaimerPage extends StatefulWidget {
  final Function changeLocale;
  DisclaimerPage({
    required this.changeLocale,
    super.key,
  });
  @override
  State<DisclaimerPage> createState() => _DisclaimerPageState();
}

// a function to update the disclaimer signed in the shared preferences
void updateDisclaimers(userInfo) async {
  // get the shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('disclaimerConfirmed',
      true); //update the disclaimer signed in the shared preferences
  userInfo.updateDisclaimerSigned(
      true); //update the disclaimer signed in the user information provider
}

// update the disclaimer signed in the shared preferences
void updateDisclaimer() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('disclaimerConfirmed', true);
}

class _DisclaimerPageState extends State<DisclaimerPage> {
  // build the disclaimer page widget
  @override
  Widget build(BuildContext context) {
    // get the appInformation and userInformation providers
    final appInfoProvider = Provider.of<AppInformation>(context, listen: false);
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: true);
    final gender = userInfoProvider.gender;
    final appLocale = AppLocalizations.of(context);
    // show the disclaimer text and a button to confirm the disclaimer
    print(appInfoProvider.disclaimerText);
    return PopScope(
      canPop: false, //can't go back from this page
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  Container(
                    width: MediaQuery.of(context).size.width > 1000
                        ? 600
                        : MediaQuery.of(context).size.width * 0.6,
                  ),

                  LanguageDropDown(changeLocale: widget.changeLocale),
                  SizedBox(height: 20.0),
                  Container(
                    width: MediaQuery.of(context).size.width > 1000
                        ? 600
                        : MediaQuery.of(context).size.width * 0.6,
                  ),

                  LanguageDropDown(changeLocale: widget.changeLocale),
                  SizedBox(
                      height:
                          20.0), //space between the top of the screen and the disclaimer text
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: myAutoSizedText(
                        appLocale!
                            .disclaimerText, //disclaimer text from CMS(Saved in appinfo)
                        TextStyle(
                          fontSize: 16.sp, //text size
                          fontWeight: FontWeight.normal,
                        ),
                        appLocale.textDirection == 'rtl'
                            ? TextAlign.right
                            : TextAlign.left,
                        40),
                  ),
                  // the confirm disclaimer button
                  ConfirmationButton(context, () {
                    setState(() {
                      updateDisclaimers(
                          userInfoProvider); //if button is clicked,
                      //update the disclaimer signed in the shared preferences (call the updateDisclaimers function)
                    });
                  },
                      //disclaimer next button text from CMS(Saved in appinfo)
                      appLocale!.confirmButton(gender),
                      myTextStyle.copyWith(
                        fontSize: 20.sp,
                      )),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
