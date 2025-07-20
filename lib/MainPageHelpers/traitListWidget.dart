import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:mazilon/AnalyticsService.dart';
import 'package:mazilon/global_enums.dart';
import 'package:mazilon/util/Form/retrieveInformation.dart';
import 'package:mazilon/util/HomePage/sectionBarHome.dart';
import 'package:mazilon/util/LP_extended_state.dart';
import 'package:mazilon/util/Thanks/AddForm.dart';
//import 'package:mazilon/util/Thanks/thanksItem.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/Traits/positiveTraitItemSug.dart';
import 'package:mazilon/l10n/app_localizations.dart';

// the trait list widget, it shows the list of the traits
// this code is related to "מעלות" section in homepage.
// this code is similar to thanksListWidget.dart .
class TraitListWidget extends StatefulWidget {
  final Function(BuildContext, PagesCode)
      onTabTapped; // the function to navigate to another page
  const TraitListWidget({super.key, required this.onTabTapped});
  @override
  State<TraitListWidget> createState() => _TraitListWidgetState();
}

class _TraitListWidgetState extends LPExtendedState<TraitListWidget> {
  List<String> threeLatestTraits = [];
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
    print(positiveTraits_temp);
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

// build the trait list widget
  @override
  Widget build(BuildContext context) {
    // get the app information provider and the user information provider

    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: true);
    final gender = userInfoProvider.gender;
    final traitsListlength = userInfoProvider.positiveTraits.length;

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
                      widget.onTabTapped(
                          context,
                          PagesCode
                              .QualitiesList); // 2 is the index of the trait page
                    },
                    child: myAutoSizedText(
                        appLocale!.homePageTraitsMainTitle(gender),
                        TextStyle(
                          fontSize: 24.sp, // the font size of the title
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // the color of the title
                        ),
                        null,
                        40)),
                icon: Icons.diamond, // the icon of the section bar
                icons: [
                  // add button with the add icon
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: primaryPurple, // the color of the add icon
                      size: 30, // the size of the add icon
                    ),
                    onPressed: () {
                      editTrait(
                          appLocale!.trait); // the function to add a trait
                    },
                  ),
                ],

                // the subheader of the section bar
                subHeader: appLocale!.homePageTraitsSecondaryTitle(gender)),
            // gap between the section bar and the trait list
            const SizedBox(height: 10),
            // a suggested trait with add button
            Container(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: PositiveTraitItemSug(
                  stopShowing: 0,
                  add: addPositiveTrait,
                  inputText: "",
                  fullSuggestionList: retrieveTraitsList(
                      appLocale, gender == "" ? "other" : gender),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: PositiveTraitItemSug(
                  stopShowing: 2,
                  add: addPositiveTrait,
                  inputText: "",
                  fullSuggestionList: retrieveTraitsList(
                      appLocale, gender == "" ? "other" : gender),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: PositiveTraitItemSug(
                  stopShowing: 3,
                  add: addPositiveTrait,
                  inputText: "",
                  fullSuggestionList: retrieveTraitsList(
                      appLocale, gender == "" ? "other" : gender),
                ),
              ),
            ),
            // the list of the traits
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 315), //max height
              child: SingleChildScrollView(
                child: Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: userInfoProvider.positiveTraits
                        .asMap()
                        .entries
                        .map((entry) {
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
                                    // the trait text
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          trait,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: "Rubix",
                                              fontSize: 16
                                                  .sp, // the font size of the trait
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    // the edit button
                                    Container(
                                      width: 32, // the width of the edit button
                                      child: MaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            editTrait(
                                                appLocale!.trait,
                                                userInfoProvider
                                                    .positiveTraits[index],
                                                traitsListlength -
                                                    userInfoProvider
                                                        .positiveTraits.length +
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
                                      width:
                                          32, // the width of the delete button
                                      child: MaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            removePositiveTrait(
                                                traitsListlength -
                                                    userInfoProvider
                                                        .positiveTraits.length +
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
                          ],
                        ),
                      );
                    }).toList()),
              ),
            ),

            // the see all button
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    widget.onTabTapped(context, PagesCode.QualitiesList);
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
