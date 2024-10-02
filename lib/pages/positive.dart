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
import 'dart:math';
import 'package:mazilon/util/userInformation.dart';

// positive traits page, where the user can add/edit/remove positive traits
// the user can also see suggestions for positive traits and refresh them
// the code here is not related to the "מעלות" section in homepage , its the positive triats page.
//the code here is similar to journal.dart page code

class Positive extends StatefulWidget {
  const Positive({super.key});

  @override
  State<Positive> createState() => _PositiveState();
}

class _PositiveState extends State<Positive> {
  List<String> positiveTraits = []; //list of positive traits
  List<FocusNode> focusNodes = []; //list of focus nodes
  List<String> dates = []; //list of dates
  FocusNode myFocusNode = FocusNode(); //focus node
  String positiveTraitsMainTitle = ''; //main title
  String positiveTraitsSubTitle = ''; //sub title
  String sug1 = ''; //suggestion 1
  String sug2 = ''; //suggestion 2
  String sug3 = ''; //suggestion 3
  List<String> positiveSuggestionList = []; //list of suggestions

  //load the data from the shared preferences
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final appInfoProvider = Provider.of<AppInformation>(context, listen: false);
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);
    setState(() {
      positiveTraits = prefs.getStringList('positiveTraits') ?? [];
      dates = prefs.getStringList('positiveDates') ?? [];
      for (var _ in positiveTraits) {
        focusNodes.add(FocusNode());
      }
      String gender = userInfoProvider.gender;
      List<String> tempPositiveSuggestionList = gender == 'male'
          ? appInfoProvider.positiveTraitsSuggestionsList['traits-male']!
          : (gender == 'female'
              ? appInfoProvider.positiveTraitsSuggestionsList['traits-female']!
              : appInfoProvider.positiveTraitsSuggestionsList['traits']!);
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
    });
  }

  //change the positive trait at the given index to the given text
  void changePositiveTrait(String text, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      positiveTraits[index] = text;
      prefs.setStringList('positiveTraits', positiveTraits);
    });
  }

  //remove the positive trait at the given index
  void removePositiveTrait(int removeIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> positiveTraits_temp =
        prefs.getStringList('positiveTraits') ?? [];
    List<String> positiveDates_temp =
        prefs.getStringList('positiveDates') ?? [];
    positiveTraits_temp.removeAt(removeIndex);
    positiveDates_temp.removeAt(removeIndex);
    setState(() {
      prefs.setStringList('positiveTraits', positiveTraits_temp);
      positiveTraits = positiveTraits_temp;
      focusNodes.removeAt(removeIndex);
      prefs.setStringList('positiveDates', positiveDates_temp);
      dates = positiveDates_temp;
    });
  }

  //add the given positive trait to the list
  void addPositiveTrait(String positiveTrait) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> positiveTraits_temp =
        prefs.getStringList('positiveTraits') ?? [];
    List<String> positiveDates_temp =
        prefs.getStringList('positiveDates') ?? [];
    positiveTraits_temp.add(positiveTrait);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    positiveDates_temp.add(formattedDate);
    setState(() {
      prefs.setStringList('positiveTraits', positiveTraits_temp);
      positiveTraits = positiveTraits_temp;
      focusNodes.add(FocusNode());
      prefs.setStringList('positiveDates', positiveDates_temp);
      dates = positiveDates_temp;
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
                appInfoProvider.positiveTraitsPopUpText[
                        'PositiveTraitPopup-' + gender] ??
                    '',
                style:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 15.sp),
                textAlign: TextAlign.center),
            actions: <Widget>[
              // close button
              TextButton(
                child: Text(
                    appInfoProvider.popupBack['popupBack-' + gender] ?? ''),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
    loadData().then((_) {
      setState(() {
        //shuffle 3 random suggestions from the suggestions list
        var indices =
            List<int>.generate(positiveSuggestionList.length, (i) => i);
        indices.shuffle();
        sug1 = positiveSuggestionList[indices[0]];
        sug2 = positiveSuggestionList[
            indices[positiveSuggestionList.length > 1 ? 1 : 0]];
        sug3 = positiveSuggestionList[
            indices[positiveSuggestionList.length > 2 ? 2 : 0]];
      });
    });
  }

  //the function we call when we want to add/edit a positive trait,(it opens a popup with a text field and a save button)
  void editNotification(String text, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddForm(
            add: addPositiveTrait,
            index: index,
            edit: changePositiveTrait,
            text: text,
            formTitle: 'מעלה',
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
                      //add button
                      IconButton(
                          onPressed: () {
                            editNotification("", 0);
                          },
                          icon: Icon(
                            Icons.add,
                            size: 50.0,
                            color: primaryPurple,
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        //main title
                        child: myAutoSizedText(
                            appInfoProvider.traitMainTitle[
                                    'TraitsMainTitle-' + gender] ??
                                '',
                            TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30.sp,
                            ),
                            null,
                            60),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //sub title
                      myAutoSizedText(
                          appInfoProvider.traitSubTitle[
                                  'TraitsSecondaryTitle-' + gender] ??
                              '',
                          TextStyle(
                              color: darkGray,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold),
                          null,
                          30),
                    ],
                  ),
                ],
              ),
            ),
            //list of positive traits
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ThankYou(
                      text: positiveTraits[index],
                      number: (index + 1),
                      edit: editNotification,
                      remove: removePositiveTrait,
                      myFocusNode: focusNodes[index],
                      date: dates[index],
                      color: Colors.purple,
                    ),
                itemCount: positiveTraits.length),
            positiveTraits.isEmpty
                ? Container()
                : Divider(
                    color: darkGray,
                    indent: 30,
                    endIndent: 30,
                  ),
            //suggestions
            PositiveTraitItemSug(
              add: addPositiveTrait,
              inputText: sug1,
            ),
            PositiveTraitItemSug(
              add: addPositiveTrait,
              inputText: sug2,
            ),
            PositiveTraitItemSug(
              add: addPositiveTrait,
              inputText: sug3,
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
                    appInfoProvider.othersuggestions[
                            'othersuggestions-' + userInfoProvider.gender] ??
                        'הצעות אחרות',
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
