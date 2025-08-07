import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mazilon/AnalyticsService.dart';
import 'package:mazilon/MainPageHelpers/list_util.dart';
import 'package:mazilon/MainPageHelpers/Show_all_widget.dart';
import 'package:mazilon/global_enums.dart';
import 'package:mazilon/util/Form/retrieveInformation.dart';
import 'package:mazilon/util/HomePage/sectionBarHome.dart';
import 'package:mazilon/util/LP_extended_state.dart';
import 'package:mazilon/util/Thanks/AddForm.dart';
import 'package:mazilon/util/Thanks/thanksItemSug.dart';
//import 'package:mazilon/util/Thanks/thanksItem.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/Traits/positiveTraitItemSug.dart';
import 'package:mazilon/l10n/app_localizations.dart';

// the trait list widget, it shows the list of the traits
// this code is related to "מעלות" section in homepage.
// this code is similar to thanksListWidget.dart .
class ListWidget extends StatefulWidget {
  final Function(BuildContext, PagesCode)
      onTabTapped; // the function to navigate to another page
  final PagesCode pageCode; // the title of the widget
  const ListWidget(
      {super.key, required this.onTabTapped, required this.pageCode});
  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends LPExtendedState<ListWidget> {
  List<String> threeLatestTraits = [];
  List<String> thankYous = [];
  List<String> todayThankYous = [];
  List<String> thankYouDates = [];
  @override
  void initState() {
    super.initState();
  }

  void editTrait(String title, [String text = '', int index = 0]) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddForm(
            add: addPositiveTrait,
            index: index,
            edit: editPositiveTrait,
            text: text,
            formTitle: title,
          );
        });
  }

  List<String> threeLatestTraitsFunc(List<String> traits) {
    List<String> threeLatestTraits = [];
    if (traits.length <= 3) {
      threeLatestTraits = traits;
    } else {
      for (int i = traits.length - 3; i < traits.length; i++) {
        threeLatestTraits.add(traits[i]);
      }
    }
    return threeLatestTraits;
  }

  void addPositiveTrait(
      String positiveTrait, UserInformation userInfoProvider) {
    List<String> positiveTraits_temp = userInfoProvider.positiveTraits;
    positiveTraits_temp.add(positiveTrait);

    setState(() {
      userInfoProvider.updatePositiveTraits(positiveTraits_temp);
      threeLatestTraits = threeLatestTraitsFunc(positiveTraits_temp);
    });
    AnalyticsService mixPanelService = GetIt.instance<AnalyticsService>();
    mixPanelService.trackEvent(
      "Item added to Qualities List",
    );
  }

//function to handle a change in a trait
  void editPositiveTrait(
      String text, int index, UserInformation userInfoProvider) {
    List<String> positiveTraits = userInfoProvider.positiveTraits;
    setState(() {
      positiveTraits[index] = text;
      userInfoProvider.updatePositiveTraits(positiveTraits);
      threeLatestTraits = threeLatestTraitsFunc(positiveTraits);
    });
  }

//fuction to handle the removal of a trait
  void removePositiveTrait(int removeIndex, UserInformation userInfoProvider) {
    List<String> positiveTraits_temp = userInfoProvider.positiveTraits;
    positiveTraits_temp.removeAt(removeIndex);
    setState(() {
      userInfoProvider.updatePositiveTraits(positiveTraits_temp);

      threeLatestTraits = threeLatestTraitsFunc(positiveTraits_temp);
    });
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
          return AlertDialog(
            title: const Text(''),
            content: Text(
              appLocale.homePageThankyouPopup(gender),
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.sp),
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
    AnalyticsService mixPanelService = GetIt.instance<AnalyticsService>();
    mixPanelService.trackEvent(
      "Item added to Gratitude Journal",
    );
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

// build the trait list widget
  @override
  Widget build(BuildContext context) {
    // get the app information provider and the user information provider

    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: true);
    final gender = userInfoProvider.gender;
    final traitsListlength = userInfoProvider.positiveTraits.length;
    final thanksListLength = userInfoProvider.thanks['thanks']?.length ?? 0;
    todayThankYous = todayThankYousFunc(userInfoProvider.thanks["thanks"] ?? [],
        userInfoProvider.thanks["dates"] ?? []);
    final pageData = getLocalizedText(appLocale, gender, widget.pageCode);
    final listItems = widget.pageCode == PagesCode.GratitudeJournal
        ? todayThankYous
        : userInfoProvider.positiveTraits;
    traitItemSugBox(int stopShowingNumber) => PositiveTraitItemSug(
          stopShowing: stopShowingNumber,
          add: addPositiveTrait,
          inputText: "",
          fullSuggestionList:
              retrieveTraitsList(appLocale, gender == "" ? "other" : gender),
        );
    thanksItemSubBox(int stopShowingNumber) => ThanksItemSuggested(
          stopShowing: stopShowingNumber,
          add: addThankYou,
          inputText: "",
          fullSuggestionList:
              retrieveThanksList(appLocale, gender == "" ? "other" : gender),
        );
    final sugBox = widget.pageCode == PagesCode.QualitiesList
        ? traitItemSugBox
        : thanksItemSubBox;

    return SizedBox(
      // the width of the widget is 800 if the screen width is more than 1000, otherwise it is the screen width
      width: MediaQuery.of(context).size.width > 1000
          ? 800
          : MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            // the section bar of the trait list ,
            // which contains the title, the icon, the subheader and the add icon,
            // when its clicked it navigates to the add trait page
            SectionBarHome(
                textWidget: TextButton(
                    onPressed: () {
                      widget.onTabTapped(context, widget.pageCode);
                    },
                    child: myAutoSizedText(
                        pageData['mainTitle'],
                        TextStyle(
                          fontSize: 24.sp, // the font size of the title
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // the color of the title
                        ),
                        null,
                        40)),
                icon: pageData["icon"], // the icon of the section bar
                icons: [
                  // add button with the add icon
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: primaryPurple, // the color of the add icon
                      size: 30, // the size of the add icon
                    ),
                    onPressed: () {
                      if (widget.pageCode == PagesCode.QualitiesList) {
                        editTrait(
                            appLocale.trait); // the function to add a trait
                      } else {
                        editThanks(
                            appLocale.thanks); // the function to add a thanks
                      }
                    },
                  ),
                ],

                // the subheader of the section bar
                subHeader: pageData['SecondaryTitle'] ?? ""),
            // gap between the section bar and the trait list
            const SizedBox(height: 10),
            // a suggested trait with add button
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: sugBox(1),
            ),
            Padding(padding: const EdgeInsets.all(0.0), child: sugBox(2)),
            Padding(padding: const EdgeInsets.all(0.0), child: sugBox(3)),
            // the list of the traits
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 315), //max height
              child: SingleChildScrollView(
                child: Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: listItems.asMap().entries.map((entry) {
                      int index = entry.key;
                      String trait = entry.value;
                      return Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // the number of the trait (in a circle)
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
                                    '${index + 1}', // index + 1 because the index starts from 0 in code :)
                                    TextStyle(
                                        color: Colors
                                            .white, // the color of the number
                                        fontSize:
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
                              height: 80,
                              width: MediaQuery.of(context).size.width > 1000
                                  ? 600
                                  : MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    // the trait text
                                    Expanded(
                                      child: Text(
                                        maxLines: 2,
                                        trait,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: "Rubix",
                                            fontSize: 16
                                                .sp, // the font size of the trait
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    // the edit button
                                    SizedBox(
                                      width: 32, // the width of the edit button
                                      child: MaterialButton(
                                        onPressed: () {
                                          if (widget.pageCode ==
                                              PagesCode.GratitudeJournal) {
                                            setState(() {
                                              editThanks(
                                                  appLocale.thanks,
                                                  todayThankYous[index],
                                                  thanksListLength -
                                                      todayThankYous.length +
                                                      index);
                                            });
                                          } else {
                                            setState(() {
                                              editTrait(
                                                  appLocale!.trait,
                                                  userInfoProvider
                                                      .positiveTraits[index],
                                                  traitsListlength -
                                                      userInfoProvider
                                                          .positiveTraits
                                                          .length +
                                                      index);
                                            });
                                          }
                                        },
                                        splashColor: Colors.transparent,
                                        enableFeedback: false,
                                        child: const Icon(
                                          Icons.edit, // the edit icon
                                        ),
                                      ),
                                    ),

                                    // the delete button
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width:
                                            32, // the width of the delete button
                                        child: MaterialButton(
                                          onPressed: () {
                                            if (widget.pageCode ==
                                                PagesCode.GratitudeJournal) {
                                              setState(() {
                                                removeThankYou(
                                                    thanksListLength -
                                                        todayThankYous.length +
                                                        index,
                                                    userInfoProvider);
                                              });
                                            } else {
                                              setState(() {
                                                removePositiveTrait(
                                                    traitsListlength -
                                                        userInfoProvider
                                                            .positiveTraits
                                                            .length +
                                                        index,
                                                    userInfoProvider);
                                              });
                                            }
                                          },
                                          splashColor: Colors.transparent,
                                          enableFeedback: false,
                                          child: const Icon(
                                            Icons.delete, // the delete icon
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList()),
              ),
            ),
            // the see all button
            ShowAllWidget(
                onTabTapped: widget.onTabTapped, pageCode: widget.pageCode)
          ],
        ),
      ),
    );
  }
}
