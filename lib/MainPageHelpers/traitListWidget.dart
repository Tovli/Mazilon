import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:mazilon/util/HomePage/sectionBarHome.dart';
//import 'package:mazilon/util/Thanks/thanksItem.dart';
import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/userInformation.dart';
import 'package:provider/provider.dart';
import 'package:mazilon/util/appInformation.dart';
import 'package:mazilon/util/Traits/positiveTraitItemSug.dart';

// the trait list widget, it shows the list of the traits
// this code is related to "מעלות" section in homepage.
// this code is similar to thanksListWidget.dart .
class TraitListWidget extends StatefulWidget {
  final List<String> traits; // the list of the traits
  final Function add; // the function to add a trait
  final Function edit; // the function to edit a trait
  final Function remove; // the function to remove a trait
  final int traitListLength; // the length of the trait list
  final Function addSuggested; // the function to add a suggested trait
  final Function(int) onTabTapped; // the function to navigate to another page
  const TraitListWidget(
      {super.key,
      required this.traits,
      required this.add,
      required this.edit,
      required this.remove,
      required this.traitListLength,
      required this.addSuggested,
      required this.onTabTapped});
  @override
  State<TraitListWidget> createState() => _TraitListWidgetState();
}

class _TraitListWidgetState extends State<TraitListWidget> {
  @override
  void initState() {
    super.initState();
  }

// build the trait list widget
  @override
  Widget build(BuildContext context) {
    // get the app information provider and the user information provider
    final appInfoProvider = Provider.of<AppInformation>(context);
    final userInfoProvider =
        Provider.of<UserInformation>(context, listen: false);
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
                      widget.onTabTapped(2); // 2 is the index of the trait page
                    },
                    child: Directionality(
                      // the title of the trait list
                      textDirection: TextDirection.rtl,
                      child: myAutoSizedText(
                          appInfoProvider.traitsHomePageTitles['mainTitle']!,
                          TextStyle(
                            fontSize: 24.sp, // the font size of the title
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // the color of the title
                          ),
                          null,
                          40),
                    )),
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
                      widget.add(); // the function to add a trait
                    },
                  ),
                ],
                // the subheader of the section bar
                subHeader: appInfoProvider.traitsHomePageTitles[
                    'secondaryTitle-${userInfoProvider.gender}']!),
            // gap between the section bar and the trait list
            const SizedBox(height: 10),
            // the list of the traits
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 315), //max height
              child: SingleChildScrollView(
                child: Wrap(
                    textDirection: TextDirection.rtl,
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: widget.traits.asMap().entries.map((entry) {
                      int index = entry.key;
                      String trait = entry.value;
                      return Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                                    // the delete button
                                    Container(
                                      width:
                                          32, // the width of the delete button
                                      child: MaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.remove(
                                                widget.traitListLength -
                                                    widget.traits.length +
                                                    index);
                                          });
                                        },
                                        splashColor: Colors.transparent,
                                        enableFeedback: false,
                                        child: const Icon(
                                          Icons.delete, // the delete icon
                                        ),
                                      ),
                                    ),
                                    // the edit button
                                    Container(
                                      width: 32, // the width of the edit button
                                      child: MaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.edit(
                                                widget.traits[index],
                                                widget.traitListLength -
                                                    widget.traits.length +
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
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    // the trait text
                                    Expanded(
                                      child: Container(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Text(
                                            trait,
                                            textAlign: TextAlign.right,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "Rubix",
                                                fontSize: 16
                                                    .sp, // the font size of the trait
                                                fontWeight: FontWeight.normal),
                                          ),
                                          // child: AutoSizeText(
                                          //   trait,
                                          //   maxLines: 1,
                                          //   minFontSize: 14,
                                          //   overflow: TextOverflow.ellipsis,
                                          //   style: TextStyle(
                                          //       fontFamily: "Rubix",
                                          //       fontSize: 20.sp,
                                          //       fontWeight: FontWeight.bold,
                                          //       //color: Colors.purple
                                          //       ),
                                          // ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
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
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: myAutoSizedText(
                                      '${index + 1}', // index + 1 because the index starts from 0 in code :)
                                      TextStyle(
                                          color: Colors
                                              .white, // the color of the number
                                          fontSize: index + 1 < 10
                                              ? (14.sp)
                                              : (10.sp),
                                          fontWeight: FontWeight.bold),
                                      null,
                                      30),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList()),
              ),
            ),
            // a suggested trait with add button
            Container(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: PositiveTraitItemSug(
                    add: widget.addSuggested, inputText: ""),
              ),
            ),
            // the see all button
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    widget.onTabTapped(2);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.arrow_back_ios,
                        size: 12,
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(userInfoProvider.gender == 'female'
                            ? 'ראי הכל'
                            : (userInfoProvider.gender == 'male'
                                ? 'ראה הכל'
                                : 'ראה.י הכל')),
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
