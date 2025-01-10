import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/util/Form/retrieveInformation.dart';
import 'package:mazilon/util/Thanks/AddForm.dart';

import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/HomePage/sectionBarHome.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mazilon/util/Thanks/thanksItemSug.dart';

import 'package:mazilon/util/userInformation.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// the thank you list widget, it shows the list of the thank yous
// this code is related to todo list in homepage.
class ThanksListWidget extends StatefulWidget {
  final Function(BuildContext, int)
      onTabTapped; // the function to call when pressing on the "see more" to go to wanted page (journal page)
  const ThanksListWidget({super.key, required this.onTabTapped});
  @override
  State<ThanksListWidget> createState() => _ThanksListWidgetState();
}

class _ThanksListWidgetState extends State<ThanksListWidget> {
  List<String> thankYous = [];
  List<String> todayThankYous = [];

  List<String> thankYouDates = [];
  @override
  void initState() {
    super.initState();
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

//pop up to show after adding a thank you item
// it triggers only after the first one each day
  void showThankYouPopup(UserInformation userInfoProvider) {
    Future.delayed(const Duration(seconds: 0), () {
      final gender = userInfoProvider.gender;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final appLocale = AppLocalizations.of(context);
          return AlertDialog(
            title: const Text(''),
            content: Text(
              appLocale!.homePageThankyouPopup(gender),
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15.sp),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(appLocale!.confirmButton(gender),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    )),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  void addThankYou(String thankYou, UserInformation userInfoProvider) {
    List<String> thankYous_temp = userInfoProvider.thanks['thanks'] ?? [];
    List<String> dates_temp = userInfoProvider.thanks['dates'] ?? [];

    thankYous_temp.add(thankYou);

    DateTime now = DateTime.now();
    String formattedDate = intl.DateFormat('yyyy-MM-dd – kk:mm').format(now);
    dates_temp.add(formattedDate);

    setState(() {
      userInfoProvider
          .updateThanks({'thanks': thankYous_temp, 'dates': dates_temp});
      thankYous = thankYous_temp;
      thankYouDates = dates_temp;
      todayThankYous = todayThankYousFunc(thankYous, thankYouDates);
    });
    if (todayThankYousFunc(userInfoProvider.thanks["thanks"] ?? [],
                userInfoProvider.thanks["dates"] ?? [])
            .length ==
        1) {
      showThankYouPopup(userInfoProvider);
    }
  }

  void removeThankYou(int removeIndex, UserInformation userInfoProvider) {
    List<String> thankYous_temp = userInfoProvider.thanks['thanks'] ?? [];
    List<String> dates_temp = userInfoProvider.thanks['dates'] ?? [];

    thankYous_temp.removeAt(removeIndex);
    dates_temp.removeAt(removeIndex);
    setState(() {
      userInfoProvider
          .updateThanks({'thanks': thankYous_temp, 'dates': dates_temp});
      thankYous = thankYous_temp;
      thankYouDates = dates_temp;
      todayThankYous = todayThankYousFunc(thankYous, thankYouDates);
    });
  }

//function to change a thank you
  void editThankYou(String text, int index, UserInformation userinfoProvider) {
    setState(() {
      thankYous[index] = text;
      userinfoProvider.updateThanks({
        'thanks': thankYous,
        'dates': userinfoProvider.thanks['dates'] ?? []
      });
      todayThankYous = todayThankYousFunc(thankYous, thankYouDates);
    });
  }

//fuction to show the edit form for a thank you
  void editThanks(String title, [String text = '', int index = 0]) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddForm(
              add: addThankYou,
              index: index,
              edit: editThankYou,
              text: text,
              formTitle: title);
        });
  }

  // build the thank you list widget
  @override
  Widget build(BuildContext context) {
    // get the user information provider and the app information provider
    final appLocale = AppLocalizations.of(context);
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);

    final gender = userInfoProvider.gender;
    final thanksListLength = userInfoProvider.thanks['thanks']?.length ?? 0;
    todayThankYous = todayThankYousFunc(userInfoProvider.thanks["thanks"] ?? [],
        userInfoProvider.thanks["dates"] ?? []);

    return SizedBox(
      // width of the widget is 800 if the screen width is more than 1000, else it is the screen width
      width: MediaQuery.of(context).size.width > 1000
          ? 800
          : MediaQuery.of(context).size.width * 1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            // the section bar of the thank you list ,
            // which contains the title, the icon, the sub title and the add button,
            // when tapped it goes to the journal page

            SectionBarHome(
              textWidget: TextButton(
                onPressed: () {
                  widget.onTabTapped(
                      context, 3); // 3 is the index of the journal page
                },
                child: myAutoSizedText(
                    appLocale!.homePageThanksMainTitle(gender),
                    TextStyle(
                      fontSize: 24.sp, // the size of the title
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // the color of the title
                    ),
                    null,
                    40),
              ),
              icon: FontAwesome5
                  .praying_hands, // the icon of the thank you list , adjust as needed
              icons: [
                // the add button
                IconButton(
                  icon: Icon(
                    Icons.add, // the add icon
                    color: primaryPurple, // the color of the icon
                    size: 30, // the size of the icon
                  ),
                  onPressed: () {
                    editThanks(appLocale.thanks);
                  },
                ),
              ],
              // the sub title of the thank you list
              subHeader: appLocale.homePageThanksSecondaryTitle(gender),
            ),
            // gap between the section bar and the list
            const SizedBox(height: 10),
            // the list of the thank yous
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 315), //max height
              child: SingleChildScrollView(
                child: Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: todayThankYous.asMap().entries.map((entry) {
                      int index = entry.key;
                      String thank = entry.value;
                      return Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // the number of the thank you/trait (in a circle)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: index + 1 < 10
                                    ? const EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 7)
                                    : const EdgeInsets.symmetric(
                                        horizontal: 11, vertical: 7),
                                color: primaryPurple, // the color of the circle
                                child: myAutoSizedText(
                                    '${index + 1}', // number + 1 because we start from 0 in code :)
                                    TextStyle(
                                        color: Colors
                                            .white, // the color of the number
                                        fontSize: // the size of the number
                                            index + 1 < 10 ? (14.sp) : (10.sp),
                                        fontWeight: FontWeight.bold),
                                    null,
                                    30),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),

                            Container(
                              constraints: BoxConstraints(
                                minHeight: 20,
                                maxWidth:
                                    MediaQuery.sizeOf(context).width * 0.76,
                              ),
                              height: 50,
                              width: MediaQuery.of(context).size.width > 1000
                                  ? 600
                                  : MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(95)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      // the text of the thank you/trait
                                      child: Container(
                                        child: Text(
                                          thank,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: "Rubix",
                                              fontSize:
                                                  16.sp, // the size of the text
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    // the edit button
                                    Container(
                                      width: 32,
                                      child: MaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            editThanks(
                                                appLocale.thanks,
                                                todayThankYous[index],
                                                thanksListLength -
                                                    todayThankYous.length +
                                                    index);
                                          });
                                        },
                                        splashColor: Colors.transparent,
                                        enableFeedback: false,
                                        child: const Icon(
                                          Icons.edit, // the edit icon
                                        ),
                                      ),
                                    ),

                                    // the delete button
                                    Container(
                                      width: 32,
                                      child: MaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            removeThankYou(
                                                thanksListLength -
                                                    todayThankYous.length +
                                                    index,
                                                userInfoProvider);
                                          });
                                        },
                                        splashColor: Colors.transparent,
                                        enableFeedback: false,
                                        child: const Icon(
                                          Icons.delete, // the delete icon
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //gap between the text and the number
                          ],
                        ),
                      );
                    }).toList()),
              ),
            ),
            // a suggested thank you with an add button to add it to the list if the user wants to
            Container(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: ThanksItemSuggested(
                  add: addThankYou,
                  inputText: "",
                  fullSuggestionList: retrieveThanksList(
                      appLocale, gender == "" ? "other" : gender),
                ),
              ),
            ),
            // the "see more" button to go to the journal page
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    widget.onTabTapped(context, 3);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(appLocale!.showAll(gender),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
