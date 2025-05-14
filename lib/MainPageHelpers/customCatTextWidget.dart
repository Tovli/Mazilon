import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mazilon/util/styles.dart';
import 'package:mazilon/util/HomePage/sectionBarHome.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mazilon/util/customCatFunctions.dart';


// the thank you list widget, it shows the list of the thank yous
// this code is related to todo list in homepage.
class customCatWidget extends StatefulWidget {
  final Function(BuildContext, int)
      onTabTapped; // the function to call when pressing on the "see more" to go to wanted page (journal page)
  const customCatWidget({super.key, required this.onTabTapped});
  @override
  State<customCatWidget> createState() => _CustomCatWidgetState();
}

class _CustomCatWidgetState extends State<customCatWidget> {
  List<String> categoryNames = [];
  List<String> catContents = [];
  @override
  void initState() {
    super.initState();
  }

Future<List<String>> _listCategories() async {
    Map<String, List<String>> categoryMap = await loadCategories();
    
    // Get the category names (keys of the map)

      return categoryMap.keys.toList();

  }

  Future<List<String>> _catContents(String category) async {
  List<String>? catContents = await getStringsInCategory(category);
  return (catContents ?? []).take(3).toList(); // Return empty list if null
}
  
  @override
Widget build(BuildContext context) {
  return FutureBuilder<List<String>>(
    future: _listCategories(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator(); // Or any loading widget
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return SizedBox(); // Empty if no categories
      } else {
        final categoryNames = snapshot.data!;
        return SizedBox(
          width: MediaQuery.of(context).size.width > 1000
              ? 800
              : MediaQuery.of(context).size.width * 1,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: [
                SectionBarHome(
                  textWidget: TextButton(
                    onPressed: () {
                      widget.onTabTapped(context, 3);
                    },
                    child: myAutoSizedText(
                      "Custom categories",
                      TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      null,
                      40,
                    ),
                  ),
                  icon: FontAwesome5.asterisk,
                  icons: [
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: primaryPurple,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                  ],
                  subHeader: "Categories:",
                ),
                 /// Now generate a widget for each string in categoryNames
        ...categoryNames.map((category) {
          return FutureBuilder<List<String>>(
    future: _catContents(category),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator(); // Or any loading widget
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return SizedBox(); // Empty if no categories
      } else {
      return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Text(
        category, // 👈 Displays the current category name
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    ),
    ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 315), //max height
              child: SingleChildScrollView(
                child: Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: (snapshot.data ?? []).asMap().entries.map((entry) {

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
                                            /// set later
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
                                            /// set later
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
            )]
          );}}
          );
        }),
              ],
            ),
          ),
        );
      }
    },
  );
}
}