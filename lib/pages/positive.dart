import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/pages/thankYou.dart';
import 'package:mazilon/util/Traits/positiveTraitItemSug.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Thanks/AddForm.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// positive traits page, where the user can add/edit/remove positive traits
// the user can also see suggestions for positive traits and refresh them
// the code here is not related to the "מעלות" section in homepage , its the positive triats page.
//the code here is similar to journal.dart page code
import 'package:mazilon/lists.dart';

class Positive extends StatefulWidget {
  const Positive({super.key});

  @override
  State<Positive> createState() => _PositiveState();
}

class _PositiveState extends State<Positive> {
  List<String> positiveTraits = []; //list of positive traits
  List<FocusNode> focusNodes = []; //list of focus nodes

  FocusNode myFocusNode = FocusNode(); //focus node
  String positiveTraitsMainTitle = ''; //main title
  String positiveTraitsSubTitle = ''; //sub title
  String sug1 = ''; //suggestion 1
  String sug2 = ''; //suggestion 2
  String sug3 = ''; //suggestion 3
  List<String> positiveSuggestionList = []; //list of suggestions

  //load the data from the shared preferences
  void loadData(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);
    setState(() {
      positiveTraits = userInfoProvider.positiveTraits;

      for (var _ in positiveTraits) {
        focusNodes.add(FocusNode());
      }
      String gender = userInfoProvider.gender;
      List<String> tempPositiveSuggestionList = traitsList[
          userInfoProvider.localeName]![gender == "" ? "other" : gender]!;
      //  List<String> tempPositiveSuggestionList =
      //     List.from(appInfoProvider.positiveTraitsSuggestionsList);

      positiveSuggestionList = List.from(tempPositiveSuggestionList);

      //remove the suggestions that are already in the positive traits list
      for (String suggestion in tempPositiveSuggestionList) {
        if (positiveSuggestionList.length > 3 &&
            positiveTraits.contains(suggestion)) {
          positiveSuggestionList.remove(suggestion);
        }
      }
      var indices = List<int>.generate(positiveSuggestionList.length, (i) => i);
      indices.shuffle();
      sug1 = positiveSuggestionList[indices[0]];
      sug2 = positiveSuggestionList[
          indices[positiveSuggestionList.length > 1 ? 1 : 0]];
      sug3 = positiveSuggestionList[
          indices[positiveSuggestionList.length > 2 ? 2 : 0]];
    });
  }

  //change the positive trait at the given index to the given text
  void changePositiveTrait(
      String text, int index, UserInformation userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      positiveTraits[index] = text;
      prefs.setStringList('positiveTraits', positiveTraits);
      userInfo.updatePositiveTraits(positiveTraits);
    });
  }

  //remove the positive trait at the given index
  void removePositiveTrait(int removeIndex, UserInformation userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> positiveTraits_temp =
        prefs.getStringList('positiveTraits') ?? [];

    positiveTraits_temp.removeAt(removeIndex);

    setState(() {
      prefs.setStringList('positiveTraits', positiveTraits_temp);
      positiveTraits = positiveTraits_temp;
      focusNodes.removeAt(removeIndex);
      userInfo.updatePositiveTraits(positiveTraits);
    });
  }

  //add the given positive trait to the list
  void addPositiveTrait(String positiveTrait, UserInformation userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> positiveTraits_temp =
        prefs.getStringList('positiveTraits') ?? [];

    positiveTraits_temp.add(positiveTrait);
    userInfo.updatePositiveTraits(positiveTraits_temp);

    setState(() {
      prefs.setStringList('positiveTraits', positiveTraits_temp);
      positiveTraits = positiveTraits_temp;
      focusNodes.add(FocusNode());
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 10), () {
      final appInfoProvider =
          Provider.of<AppInformation>(context, listen: false);
      final userInfoProvider =
          Provider.of<UserInformation>(context, listen: false);
      final gender = userInfoProvider.gender;
      // show the popup every time the user enters the positive traits page (after 10 seconds)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(''),
            //popup text
            content: Text(
                AppLocalizations.of(context)!
                    .homePagePositiveTraitPopup(gender),
                style:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 15.sp),
                textAlign: TextAlign.center),
            actions: <Widget>[
              // close button
              TextButton(
                child: Text(AppLocalizations.of(context)!.backButton(gender)),
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

  //the function we call when we want to add/edit a positive trait,(it opens a popup with a text field and a save button)
  void editNotification(
      String text, int index, String trait, UserInformation userInfoProvider) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddForm(
            add: (String text) {
              addPositiveTrait(text, userInfoProvider);
            },
            index: index,
            edit: (String text, int index) {
              changePositiveTrait(text, index, userInfoProvider);
            },
            text: text,
            formTitle: trait,
          );
        });
  }

  //build the positive traits page
  @override
  Widget build(BuildContext context) {
    //get the app information and user information providers
    final appInfoProvider = Provider.of<AppInformation>(context);
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);
    final gender = userInfoProvider.gender;
    loadData(context);
    return KeyboardDismisser(
      gestures: const [GestureType.onTap, GestureType.onPanUpdateAnyDirection],
      child: Scaffold(
        backgroundColor: appWhite,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 20, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: myAutoSizedText(
                            AppLocalizations.of(context)!
                                .homePageTraitsMainTitle(gender),
                            TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30.sp,
                            ),
                            null,
                            60),
                      ),
                      //add button
                      IconButton(
                          onPressed: () {
                            editNotification(
                                "",
                                0,
                                AppLocalizations.of(context)!.trait,
                                userInfoProvider);
                          },
                          icon: Icon(
                            Icons.add,
                            size: 50.0,
                            color: primaryPurple,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      //sub title
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: myAutoSizedText(
                              AppLocalizations.of(context)!
                                  .homePageTraitsSecondaryTitle(gender),
                              //TODO: WORK HERE
                              TextStyle(
                                color: darkGray,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              AppLocalizations.of(context)!.textDirection ==
                                      "rtl"
                                  ? TextAlign.right
                                  : TextAlign.left,
                              30,
                              3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //list of positive traits
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: positiveTraits.length,
              itemBuilder: (context, index) => ThankYou(
                text: positiveTraits[index],
                number: (index + 1),
                edit: (String text, int index) {
                  editNotification(text, index,
                      AppLocalizations.of(context)!.trait, userInfoProvider);
                },
                remove: (int index) {
                  removePositiveTrait(index, userInfoProvider);
                },
                myFocusNode: focusNodes[index],
                date: "",
                color: primaryPurple,
              ),
            ),
            positiveTraits.isEmpty
                ? Container()
                : Divider(
                    color: darkGray,
                    indent: 30,
                    endIndent: 30,
                  ),
            //suggestions
            PositiveTraitItemSug(
              add: (String text) {
                addPositiveTrait(text, userInfoProvider);
              },
              inputText: sug1,
              fullSuggestionList: traitsList[userInfoProvider.localeName]![
                  gender == "" ? "other" : gender]!,
            ),
            PositiveTraitItemSug(
              add: (String text) {
                addPositiveTrait(text, userInfoProvider);
              },
              inputText: sug2,
              fullSuggestionList: traitsList[userInfoProvider.localeName]![
                  gender == "" ? "other" : gender]!,
            ),
            PositiveTraitItemSug(
              add: (String text) {
                addPositiveTrait(text, userInfoProvider);
              },
              inputText: sug3,
              fullSuggestionList: traitsList[userInfoProvider.localeName]![
                  gender == "" ? "other" : gender]!,
            ),
            //refresh button
            TextButton(
              onPressed: () async {
                String gender = userInfoProvider.gender;
                List<String> tempPositiveSuggestionList = gender == 'male'
                    ? appInfoProvider
                        .positiveTraitsSuggestionsList['traits-male']!
                    : (gender == 'female'
                        ? appInfoProvider
                            .positiveTraitsSuggestionsList['traits-female']!
                        : appInfoProvider
                            .positiveTraitsSuggestionsList['traits']!);
                positiveSuggestionList = List.from(tempPositiveSuggestionList);
                for (String suggestion in tempPositiveSuggestionList) {
                  if (positiveSuggestionList.length > 3 &&
                      positiveTraits.contains(suggestion)) {
                    positiveSuggestionList.remove(suggestion);
                  }
                }
                setState(() {
                  var indices = List<int>.generate(
                      positiveSuggestionList.length, (i) => i);
                  indices.shuffle();
                  sug1 = positiveSuggestionList[indices[0]];
                  sug2 = positiveSuggestionList[
                      indices[positiveSuggestionList.length > 1 ? 1 : 0]];
                  sug3 = positiveSuggestionList[
                      indices[positiveSuggestionList.length > 2 ? 2 : 0]];
                });
              },
              //refresh button
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //refresh button text
                  Text(
                    AppLocalizations.of(context)!.otherSuggestions(gender),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: appGreen),
                  ),
                  const SizedBox(width: 1.0),
                  Icon(
                    Icons.refresh, //refresh icon
                    color: appGreen, //refresh icon color
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
