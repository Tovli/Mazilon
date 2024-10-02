import 'package:flutter/material.dart';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dotted_border/dotted_border.dart';

import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:shared_preferences/shared_preferences.dart';
// the positive trait item suggested widget, it shows a suggested positive trait text and an add button
//its used in positive trait page/homepage in todo list section to suggest a trait to the user
// we use this in 2 ways , if the input text is not empty, it will show the input text in the suggestion
// if the input text is empty, it will show a random trait from the suggested traits list that is not written today
//this is similar to thanksItemSug.dart but for the positive traits
// (it has some differences in the way suggestion is randomized, we dont look at traits written today but at traits written all time)

class PositiveTraitItemSug extends StatefulWidget {
  final Function add; // the function to add the trait to the list of traits
  final String inputText; // the input text of the suggested trait
  const PositiveTraitItemSug(
      {super.key, required this.add, required this.inputText});

  @override
  State<PositiveTraitItemSug> createState() => _PositiveTraitItemSugState();
}

class _PositiveTraitItemSugState extends State<PositiveTraitItemSug> {
  String text = ''; // the text of the suggested trait (initially empty)
  List<String> myPositiveTraits = []; // the list of the traits
  List<String> positiveTraitsSuggestionList =
      []; // the list of the suggested traits
  Future<void> loadData() async {
    // get the shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final appInfoProvider = Provider.of<AppInformation>(context, listen: false);
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);

    setState(() {
      myPositiveTraits = prefs.getStringList('positiveTraits') ?? [];
      String gender = userInfoProvider.gender;
      List<String> tempTraitSuggestionList = gender == 'male'
          ? appInfoProvider.positiveTraitsSuggestionsList['traits-male']!
          : (gender == 'female'
              ? appInfoProvider.positiveTraitsSuggestionsList['traits-female']!
              : appInfoProvider.positiveTraitsSuggestionsList['traits']!);

      positiveTraitsSuggestionList = List.from(tempTraitSuggestionList);
      // remove the traits that are already written by the user
      for (String suggestion in tempTraitSuggestionList) {
        if (positiveTraitsSuggestionList.length > 1 &&
            myPositiveTraits.contains(suggestion)) {
          positiveTraitsSuggestionList.remove(suggestion);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
    loadData().then((_) {
      setState(() {
        // text is the random trait from the suggested traits list
        text = positiveTraitsSuggestionList[
            Random().nextInt(positiveTraitsSuggestionList.length)];
      });
    });
  }

// build the positive trait item suggested widget
  @override
  Widget build(BuildContext context) {
    // get the appInformation and userInformation providers
    final appInfoProvider = Provider.of<AppInformation>(context);
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);
    String gender = userInfoProvider.gender;
    List<String> positiveTraits = gender == 'male'
        ? appInfoProvider.positiveTraitsSuggestionsList['traits-male']!
        : (gender == 'female'
            ? appInfoProvider.positiveTraitsSuggestionsList['traits-female']!
            : appInfoProvider.positiveTraitsSuggestionsList['traits']!);
    return Container(
      padding: const EdgeInsets.all(10),
      // the row that contains the suggested trait and the add button
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // the design of the suggested trait (a dotted border with the trait text)
          DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(20),
            dashPattern: const [5, 5],
            color: appGreen,
            strokeWidth: 2,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.of(context).size.width > 1000
                          ? 600
                          : MediaQuery.of(context).size.width * 0.6 + 36,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        // the text of the suggested trait
                        child: AutoSizeText(
                          widget.inputText == ''
                              ? text
                              : widget
                                  .inputText, // if the input text is empty, show the suggested trait text
                          maxLines: 3,
                          minFontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "Rubix",
                            fontSize: 14.sp, // the font size of the text
                            fontWeight: FontWeight.bold,
                            color: darkGray,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // gap between the text and the add button
          const SizedBox(
            width: 10,
          ),
          // the add button
          GestureDetector(
            // when the add button is clicked ,
            // add the trait to the list of traits and show a new suggested trait
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              final userInfoProvider =
                  Provider.of<UserInformation>(context, listen: false);

              setState(() {
                widget.add(widget.inputText == '' ? text : widget.inputText);
                myPositiveTraits = prefs.getStringList('positiveTraits') ?? [];
                myPositiveTraits
                    .add(widget.inputText == '' ? text : widget.inputText);

                String gender = userInfoProvider.gender;
                List<String> tempTraitSuggestionList = gender == 'male'
                    ? appInfoProvider
                        .positiveTraitsSuggestionsList['traits-male']!
                    : (gender == 'female'
                        ? appInfoProvider
                            .positiveTraitsSuggestionsList['traits-female']!
                        : appInfoProvider
                            .positiveTraitsSuggestionsList['traits']!);

                positiveTraitsSuggestionList =
                    List.from(tempTraitSuggestionList);

                for (String suggestion in tempTraitSuggestionList) {
                  if (positiveTraitsSuggestionList.length > 1 &&
                      myPositiveTraits.contains(suggestion)) {
                    positiveTraitsSuggestionList.remove(suggestion);
                  }
                }

                // positiveTraitsSuggestionList.remove(text);
                if (positiveTraitsSuggestionList.isNotEmpty) {
                  text = positiveTraitsSuggestionList[
                      Random().nextInt(positiveTraitsSuggestionList.length)];
                }
              });
            },
            // the design of the add button
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(20),
              dashPattern: const [5, 5],
              color: const Color.fromARGB(
                  255, 12, 207, 19), // the color of the border
              strokeWidth: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.add,
                      color: Colors.green,
                      size: 20,
                    ),
                    Transform.translate(
                      offset: const Offset(0.5, 0.5),
                      child: const Icon(
                        Icons.add, // the icon of the add button
                        color: Colors.green, // the color of the icon
                        size: 20, // the size of the icon
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:dotted_border/dotted_border.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:auto_size_text/auto_size_text.dart';

// import 'package:mazilon/util/styles.dart';

// class MainPage_Trait_Sug extends StatefulWidget {
//   const MainPage_Trait_Sug({super.key});

//   @override
//   State<MainPage_Trait_Sug> createState() => MainPage_Trait_SugState();
// }

// class MainPage_Trait_SugState extends State<MainPage_Trait_Sug> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   String tempTrait = '';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           DottedBorder(
//             borderType: BorderType.RRect,
//             radius: Radius.circular(20),
//             dashPattern: const [5, 5],
//             color: appGreen,
//             strokeWidth: 2,
//             child: Container(
//               height: 50,
//               decoration: BoxDecoration(
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.circular(20)),
//               child: Padding(
//                 padding: const EdgeInsets.all(7.0),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: MediaQuery.of(context).size.width > 1000
//                           ? 600
//                           : (MediaQuery.of(context).size.width * 60 / 100) + 45,
//                       child: Directionality(
//                         textDirection: TextDirection.rtl,
//                         child: AutoSizeText(
//                           'הצעה - אני חזק',
//                           maxLines: 1,
//                           minFontSize: 10,
//                           style: TextStyle(
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.bold,
//                               color: darkGray),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 10,
//           ),
//           DottedBorder(
//             borderType: BorderType.RRect,
//             radius: const Radius.circular(20),
//             dashPattern: const [5, 5],
//             color: appGreen,
//             strokeWidth: 2,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 shape: BoxShape.circle,
//               ),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: <Widget>[
//                   Icon(
//                     Icons.add,
//                     color: appGreen,
//                     size: 20,
//                   ),
//                   Transform.translate(
//                     offset: Offset(0.5, 0.5),
//                     child: Icon(
//                       Icons.add,
//                       color: appGreen,
//                       size: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
