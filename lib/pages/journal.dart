import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mazilon/pages/thankYou.dart';
import 'package:mazilon/util/Thanks/thanksItemSug.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/Thanks/AddForm.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mazilon/lists.dart';

//Journal page, where the user can write thank you notes (add , edit, remove notes)
//the user can also see suggested thank you notes and refresh them
//(the code here is not related to todo list in home page, its the thank you notes page)
class Journal extends StatefulWidget {
  final List<String> fullSuggestionList;
  const Journal({required this.fullSuggestionList, super.key});

  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  List<String> thankYous = []; //list of thank you notes
  List<FocusNode> focusNodes = []; //list of focus nodes for each thank you note
  List<String> dates = []; //list of dates for each thank you note
  FocusNode myFocusNode = FocusNode(); //focus node for the text field
  String journalMainTitle = ''; //journal main title
  String journalSubTitle = ''; //journal sub title
  String sug1 = ''; //suggested thank you note 1
  String sug2 = ''; //suggested thank you note 2
  String sug3 = ''; //suggested thank you note 3
  int counter =
      0; //counter for the number of thank you notes you added (reset to 0 every time you enter the journal page again)
  List<String> thanksSuggestionList = []; //list of thank you notes suggestions

  //load the thank you notes and suggestions from the shared preferences
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      thankYous = prefs.getStringList('thankYous') ?? [];
      dates = prefs.getStringList('dates') ?? [];
      for (var _ in thankYous) {
        focusNodes.add(FocusNode());
      }
      List<String> tempThanksSuggestionList =
          List.from(widget.fullSuggestionList);
      thanksSuggestionList = List.from(tempThanksSuggestionList);

      // remove the thank you notes suggestions that are already in the thank you notes list
      for (String suggestion in tempThanksSuggestionList) {
        if (thanksSuggestionList.length > 3 && thankYous.contains(suggestion)) {
          thanksSuggestionList.remove(suggestion);
        }
      }
    });
  }

  // change the thank you note text at the index to the new text
  void changeThankYou(String text, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      thankYous[index] = text;
      prefs.setStringList('thankYous', thankYous);
    });
  }

  // remove the thank you note at the index
  void removeThankYou(int removeIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> thankYous_temp = prefs.getStringList('thankYous') ?? [];
    List<String> dates_temp = prefs.getStringList('dates') ?? [];
    thankYous_temp.removeAt(removeIndex);
    dates_temp.removeAt(removeIndex);
    setState(() {
      prefs.setStringList('thankYous', thankYous_temp);
      thankYous = thankYous_temp;
      focusNodes.removeAt(removeIndex);
      prefs.setStringList('dates', dates_temp);
      dates = dates_temp;
    });
  }

// add the thank you note to the list
  void addThankYou(String thankYou) async {
    counter = counter < 6 ? counter + 1 : counter;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> thankYous_temp = prefs.getStringList('thankYous') ?? [];
    List<String> dates_temp = prefs.getStringList('dates') ?? [];
    thankYous_temp.add(thankYou);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    dates_temp.add(formattedDate);
    setState(() {
      prefs.setStringList('thankYous', thankYous_temp);
      thankYous = thankYous_temp;
      focusNodes.add(FocusNode());
      prefs.setStringList('dates', dates_temp);
      dates = dates_temp;
    });
    //show the popup after adding the first thank you note (every time you enter the journal page)
    if (counter == 1) {
      showPopup();
    }
    //you can show the popup after adding the i-th thank you note (every time you enter the journal page)
    // if(counter == i){
    //   showPopupFunction();
    // }
  }

//show the popup with the text from the shared preferences
  void showPopup() {
    Future.delayed(const Duration(seconds: 0), () {
      final appInfoProvider =
          Provider.of<AppInformation>(context, listen: false);
      final userInfoProvider =
          Provider.of<UserInformation>(context, listen: false);
      final gender = userInfoProvider.gender;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(''),
            content: Text(
              AppLocalizations.of(context)!.homePageThankyouPopup(gender),
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15.sp),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                child:
                    //the text of the  close button in the popup according to gender
                    Text(AppLocalizations.of(context)!.confirmButton(gender)),
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

//load the data when the page is opened
  @override
  void initState() {
    super.initState();
    loadData().then((_) {
      setState(() {
        //get 3 random thank you notes suggestions from the list of suggestions to show in the page
        var indices = List<int>.generate(thanksSuggestionList.length, (i) => i);
        indices.shuffle();
        sug1 = thanksSuggestionList[indices[0]];
        sug2 = thanksSuggestionList[
            indices[thanksSuggestionList.length > 1 ? 1 : 0]];
        sug3 = thanksSuggestionList[
            indices[thanksSuggestionList.length > 2 ? 2 : 0]];
      });
    });
  }

// function we call when we want to add/edit a thank you note (to open the popup with the text field which is AddForm widget)
  void editNotification(String text, int index, String thanks) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddForm(
              add: addThankYou,
              index: index,
              edit: changeThankYou,
              text: text,
              formTitle: thanks);
        });
  }

// build the journal page
  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context)!;
    // get the app and user information providers
    final appInfoProvider = Provider.of<AppInformation>(context, listen: false);
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: myAutoSizedText(
                            AppLocalizations.of(context)!
                                .homePageThanksMainTitle(gender),
                            TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30.sp,
                            ),
                            null,
                            60),
                      ),

                      //the add button to add a new thank you note
                      IconButton(
                          //when the button is pressed, open the popup with empty text field to write a new thank you note
                          onPressed: () {
                            editNotification(
                                "", 0, AppLocalizations.of(context)!.thanks);
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
                      //the subtitle of the journal page
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: myAutoSizedText(
                            AppLocalizations.of(context)!
                                .homePageThanksSecondaryTitle(gender),
                            TextStyle(
                                color: darkGray,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                            null,
                            30),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //the list of thank you notes
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ThankYou(
                      text: thankYous[index],
                      number: (index + 1),
                      edit: (String text, int index) {
                        editNotification(
                            text, index, AppLocalizations.of(context)!.thanks);
                      },
                      remove: removeThankYou,
                      myFocusNode: focusNodes[index],
                      date: dates[index],
                      color: Colors.black,
                    ),
                itemCount: thankYous.length),
            thankYous.isEmpty
                ? Container()
                : Divider(
                    color: darkGray,
                    indent: 30,
                    endIndent: 30,
                  ),
            //the suggested thank you notes
            ThanksItemSuggested(
                add: addThankYou,
                inputText: sug1,
                fullSuggestionList: thanksList[appLocale.localeName]![
                    gender == "" ? "other" : gender]!),
            ThanksItemSuggested(
                add: addThankYou,
                inputText: sug2,
                fullSuggestionList: thanksList[appLocale.localeName]![
                    gender == "" ? "other" : gender]!),
            ThanksItemSuggested(
                add: addThankYou,
                inputText: sug3,
                fullSuggestionList: thanksList[appLocale.localeName]![
                    gender == "" ? "other" : gender]!),
            //the button to refresh the suggested thank you notes and get 3 new suggestions
            TextButton(
              onPressed: () async {
                setState(() {
                  // sug1 = appInfoProvider.thanksSuggestionsList[Random()
                  //     .nextInt(appInfoProvider.thanksSuggestionsList.length)];
                  // sug2 = appInfoProvider.thanksSuggestionsList[Random()
                  //     .nextInt(appInfoProvider.thanksSuggestionsList.length)];
                  // sug3 = appInfoProvider.thanksSuggestionsList[Random()
                  //     .nextInt(appInfoProvider.thanksSuggestionsList.length)];

                  //remove the thank you notes suggestions that are already in the thank you notes list (a.k.a chosen by the user already)
                  List<String> tempThanksSuggestionList =
                      List.from(widget.fullSuggestionList);
                  thanksSuggestionList = List.from(tempThanksSuggestionList);
                  for (String suggestion in tempThanksSuggestionList) {
                    if (thanksSuggestionList.length > 3 &&
                        thankYous.contains(suggestion)) {
                      thanksSuggestionList.remove(suggestion);
                    }
                  }
                  var indices =
                      List<int>.generate(thanksSuggestionList.length, (i) => i);
                  indices.shuffle();
                  sug1 = thanksSuggestionList[indices[0]];
                  sug2 = thanksSuggestionList[
                      indices[thanksSuggestionList.length > 1 ? 1 : 0]];
                  sug3 = thanksSuggestionList[
                      indices[thanksSuggestionList.length > 2 ? 2 : 0]];
                });
              },
              //the text of the refresh button
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.otherSuggestions(gender),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: appGreen),
                  ),
                  const SizedBox(width: 1.0),
                  Icon(
                    Icons.refresh,
                    color: appGreen,
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
